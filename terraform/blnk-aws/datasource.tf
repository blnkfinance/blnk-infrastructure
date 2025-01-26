# Purpose: This file is used to define the data sources that are used in the terraform code.
data "aws_acm_certificate" "cert" {
  count    = var.acm_certificate_arn == "" && !var.create_acm_certificate ? 1 : 0
  domain   = "*.${var.domain_name}"
  statuses = ["ISSUED"]
}
