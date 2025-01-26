provider "aws" {
  region = "us-east-1"
}

module "blnk_finance" {
  source                  = "../../blnk-aws/"
  create_acm_certificate  = true
  enable_cw_alarms        = true
  enable_redis            = true
  enable_postgres         = true
  blnk_version            = "0.8.0"
  key_name                = "my-key"
  vpc_id                  = "vpc-xxxx"
  existing_security_group = "sg-xxxxxxx"
  domain_name             = "example.com"
  zone_id                 = "12345679ABCDEFG"
  postgres_password       = "SUPER_SECRET_PASSWORD"
  ssl_email               = "your-email@example.com"
  subnet_ids              = ["subnet-xxxxxx", "subnet-xxxxxxxxx"]
  slack_webhook           = "https://hooks.slack.com/services/your/webhook/url"
  optional_sg_inbound_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["127.0.0.1/0"]
    }
  ]
  tags = {
    Environment = "test"
    Project     = "blnk-finance"
  }
}
