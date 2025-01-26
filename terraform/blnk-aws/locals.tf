# Purpose: Define local variables for the module
locals {
  service_name        = "blnk"
  instance_name       = "${local.service_name}-instance"
  alb_name            = "${local.service_name}-alb"
  db_name             = "${local.service_name}-db"
  route53_record_name = "${local.service_name}.${var.domain_name}"
  sns_topic_arn       = var.sns_topic_arn != "" ? var.sns_topic_arn : aws_sns_topic.sns_topic[0].arn

  postgres_url = var.enable_postgres ? format("postgres://%s:%s@%s:%d/%s?sslmode=disable",
    var.postgres_username,
    var.postgres_password,
    aws_db_instance.postgres[0].address,
    5432,
    var.postgres_db_name) : var.custom_postgres_url
  redis_url = var.enable_redis ? "${aws_elasticache_cluster.redis[0].cache_nodes[0].address}:${aws_elasticache_cluster.redis[0].port}" : var.custom_redis_url
  
  thresholds = {
    ec2_cpu_utilization    = coalesce(var.cw_alert_thresholds.ec2_cpu_utilization, 80)
    ec2_memory_utilization = coalesce(var.cw_alert_thresholds.ec2_memory_utilization, 80)
    alb_5xx_count          = coalesce(var.cw_alert_thresholds.alb_5xx_count, 10)
    network_in_alarm       = coalesce(var.cw_alert_thresholds.network_in_alarm, 100000000)
    network_out_alarm      = coalesce(var.cw_alert_thresholds.network_out_alarm, 100000000)
    disk_write_ops_alarm   = coalesce(var.cw_alert_thresholds.disk_write_ops_alarm, 1000)
  }

  tags = merge(var.tags, {
    Service = local.service_name,
    Version = var.blnk_version,
  })
}
