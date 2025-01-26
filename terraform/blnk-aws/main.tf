# Redis
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  count      = var.enable_redis ? 1 : 0
  name       = var.redis_subnet_group_name
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_cluster" "redis" {
  count                = var.enable_redis ? 1 : 0
  cluster_id           = var.redis_cluster_id
  engine               = "redis"
  engine_version       = var.redis_engine_version
  node_type            = var.redis_instance_type
  num_cache_nodes      = var.redis_num_cache_nodes
  parameter_group_name = var.redis_parameter_group_name
  port                 = var.redis_port
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group[0].name
  security_group_ids   = var.existing_security_group != "" ? [var.existing_security_group] : [aws_security_group.instance_sg[0].id]
  tags                 = local.tags
}

# PostgreSQL RDS
resource "aws_db_subnet_group" "postgres_subnet_group" {
  name       = var.postgres_subnet_group_name
  subnet_ids = var.subnet_ids
  tags       = local.tags
}

resource "aws_db_instance" "postgres" {
  count                  = var.enable_postgres ? 1 : 0
  allocated_storage      = var.postgres_allocated_storage
  instance_class         = var.postgres_instance_type
  engine                 = "postgres"
  engine_version         = var.postgres_engine_version
  identifier             = var.postgres_identifier
  username               = var.postgres_username
  password               = var.postgres_password
  db_name                = var.postgres_db_name
  vpc_security_group_ids = var.existing_security_group != "" ? [var.existing_security_group] : [aws_security_group.instance_sg[0].id]
  multi_az               = var.postgres_multi_az
  tags                   = local.tags
}

# Key Pair
resource "aws_key_pair" "key" {
  count      = var.key_name == null ? 1 : 0
  key_name   = var.key_name == null ? "my-key" : var.key_name
  public_key = file("~/.ssh/id_rsa.pub")
}

# Security Groups
resource "aws_security_group" "instance_sg" {
  count       = var.existing_security_group == "" ? 1 : 0
  name        = local.instance_name
  description = "Security group for EC2 instance"
  vpc_id      = var.vpc_id
  tags        = local.tags

  # Allow inbound traffic from ALB
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # Allow inbound traffic for Redis
  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound traffic for PostgreSQL
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow optional inbound rules
  dynamic "ingress" {
    for_each = var.optional_sg_inbound_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "${local.alb_name}-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id
  tags        = local.tags

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Get the latest Amazon Linux AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Launch Configurations and Auto Scaling Groups

resource "aws_launch_configuration" "blnk_server_app_config" {
  name_prefix     = local.instance_name
  image_id        = data.aws_ami.amazon_linux.id
  instance_type   = var.blnk_server_instance_type
  security_groups = var.existing_security_group != "" ? [var.existing_security_group] : [aws_security_group.instance_sg[0].id]

  # User data using file function
  user_data = templatefile("../../../scripts/bash/blnk-server.sh", {
    redis_host     = local.redis_url,
    postgress_host = local.postgres_url
    ssl_email      = var.ssl_email,
    slack_webhook  = var.slack_webhook,
    blnk_version   = var.blnk_version
  })
  key_name = var.key_name == null ? aws_key_pair.key[0].key_name : var.key_name

  lifecycle {
    create_before_destroy = true
  }
  # tags = local.tags
}

resource "aws_autoscaling_group" "blnk_server_asg" {
  desired_capacity          = var.blnk_server_desired_capacity
  max_size                  = var.blnk_server_max_size
  min_size                  = var.blnk_server_min_size
  launch_configuration      = aws_launch_configuration.blnk_server_app_config.id
  vpc_zone_identifier       = var.subnet_ids
  health_check_type         = "EC2"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "Blnk-Server"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = local.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = var.instance_refresh_min_healthy_percentage
      instance_warmup        = var.instance_refresh_instance_warmup
    }
    triggers = ["tag"]
  }

  # Force new instances to be created when the launch configuration changes
  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_launch_configuration" "blnk_worker_app_config" {
  name_prefix     = local.instance_name
  image_id        = data.aws_ami.amazon_linux.id
  instance_type   = var.blnk_worker_instance_type
  security_groups = var.existing_security_group != "" ? [var.existing_security_group] : [aws_security_group.instance_sg[0].id]

  # User data using file function
  user_data = templatefile("../../../scripts/bash/blnk-worker.sh", {
    redis_host     = local.redis_url,
    postgress_host = local.postgres_url,
    ssl_email      = var.ssl_email,
    slack_webhook  = var.slack_webhook,
    blnk_version   = var.blnk_version
  })
  key_name = var.key_name == null ? aws_key_pair.key[0].key_name : var.key_name

  lifecycle {
    create_before_destroy = true
  }
  # tags = local.tags
}

resource "aws_autoscaling_group" "blnk_worker_asg" {
  desired_capacity          = var.blnk_worker_desired_capacity
  max_size                  = var.blnk_worker_max_size
  min_size                  = var.blnk_worker_min_size
  launch_configuration      = aws_launch_configuration.blnk_worker_app_config.id
  vpc_zone_identifier       = var.subnet_ids
  health_check_type         = "EC2"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "Blnk-Worker"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = local.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = var.instance_refresh_min_healthy_percentage
      instance_warmup        = var.instance_refresh_instance_warmup
    }
    triggers = ["tag"]
  }
  # Force new instances to be created when the launch configuration changes
  lifecycle {
    create_before_destroy = true
  }

}

# Application Load Balancer
resource "aws_alb" "alb" {
  name                       = local.alb_name
  internal                   = false
  security_groups            = [aws_security_group.alb_sg.id]
  subnets                    = var.subnet_ids
  enable_deletion_protection = false
  tags                       = local.tags

  depends_on = [aws_acm_certificate.cert]
}

resource "aws_alb_target_group" "alb_target_group" {
  name     = "${local.alb_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  tags     = local.tags
}

# ALB Listeners and Rules
resource "aws_alb_listener" "http_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  depends_on = [aws_alb.alb]
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_certificate_arn != "" ? var.acm_certificate_arn : (var.create_acm_certificate ? aws_acm_certificate.cert[0].arn : data.aws_acm_certificate.cert[0].arn)

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: Not Found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "alb_rules" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority     = 100

  condition {
    host_header {
      values = ["${local.route53_record_name}"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_target_group.arn
  }
  depends_on = [aws_alb.alb]
}

# Route 53 DNS Record
resource "aws_route53_record" "dns_record" {
  # count = var.use_cloudflare ? 0 : 1
  zone_id = var.zone_id
  name    = local.route53_record_name
  type    = "A"
  alias {
    name                   = aws_alb.alb.dns_name
    zone_id                = aws_alb.alb.zone_id
    evaluate_target_health = false
  }
}

# ACM Certificate
resource "aws_acm_certificate" "cert" {
  count             = var.create_acm_certificate ? 1 : 0
  domain_name       = local.route53_record_name #var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Route 53 DNS Record for ACM validation
resource "aws_route53_record" "acm_validation" {
  for_each   = var.create_acm_certificate ? { for dvo in aws_acm_certificate.cert[0].domain_validation_options : dvo.domain_name => dvo } : {}
  zone_id    = var.zone_id
  name       = each.value.resource_record_name
  type       = each.value.resource_record_type
  records    = [each.value.resource_record_value]
  ttl        = 60
  depends_on = [aws_acm_certificate.cert]
}
