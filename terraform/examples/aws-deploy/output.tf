output "key_pair_name" {
  description = "Name of the key pair"
  value       = module.blnk_finance.key_pair_name
}

output "instance_security_group_id" {
  description = "ID of the instance security group"
  value       = module.blnk_finance.instance_security_group_id
}

output "alb_security_group_id" {
  description = "ID of the ALB security group"
  value       = module.blnk_finance.alb_security_group_id
}

output "blnk_server_launch_configuration_id" {
  description = "ID of the blnk_server launch configuration"
  value       = module.blnk_finance.blnk_server_launch_configuration_id
}

output "blnk_worker_launch_configuration_id" {
  description = "ID of the blnk_worker launch configuration"
  value       = module.blnk_finance.blnk_worker_launch_configuration_id
}

output "blnk_server_asg_name" {
  description = "Name of the blnk_server auto-scaling group"
  value       = module.blnk_finance.blnk_server_asg_name
}

output "blnk_worker_asg_name" {
  description = "Name of the blnk_worker auto-scaling group"
  value       = module.blnk_finance.blnk_worker_asg_name
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = module.blnk_finance.alb_dns_name
}

output "alb_arn" {
  description = "ARN of the ALB"
  value       = module.blnk_finance.alb_arn
}

output "alb_target_group_arn" {
  description = "ARN of the ALB target group"
  value       = module.blnk_finance.alb_target_group_arn
}

output "alb_http_listener_arn" {
  description = "ARN of the ALB HTTP listener"
  value       = module.blnk_finance.alb_http_listener_arn
}

output "alb_https_listener_arn" {
  description = "ARN of the ALB HTTPS listener"
  value       = module.blnk_finance.alb_https_listener_arn
}

output "route53_record_name" {
  description = "Name of the Route 53 record"
  value       = module.blnk_finance.route53_record_name
}

# output "cloudflare_record_name" {
#   description = "Name of the Cloudflare record"
#   value       = module.blnk_finance.cloudflare_record_name
# }

output "sns_topic_arn" {
  description = "ARN of the SNS topic used for CloudWatch alarms"
  value       = module.blnk_finance.sns_topic_arn
}

output "ec2_cpu_alarm_arn" {
  description = "ARN of the EC2 CPU utilization alarm"
  value       = module.blnk_finance.ec2_cpu_alarm_arn
}

output "ec2_memory_alarm_arn" {
  description = "ARN of the EC2 memory utilization alarm"
  value       = module.blnk_finance.ec2_memory_alarm_arn
}

output "alb_5xx_alarm_arn" {
  description = "ARN of the ALB 5XX error count alarm"
  value       = module.blnk_finance.alb_5xx_alarm_arn
}

output "network_in_alarm_arn" {
  description = "ARN of the EC2 network in alarm"
  value       = module.blnk_finance.network_in_alarm_arn
}

output "network_out_alarm_arn" {
  description = "ARN of the EC2 network out alarm"
  value       = module.blnk_finance.network_out_alarm_arn
}

output "disk_write_ops_alarm_arn" {
  description = "ARN of the EC2 disk write operations alarm"
  value       = module.blnk_finance.disk_write_ops_alarm_arn
}

output "ec2_dashboard_name" {
  description = "Name of the EC2 CloudWatch dashboard"
  value       = module.blnk_finance.ec2_dashboard_name
}

output "rds_instance_id" {
  description = "ID of the RDS instance"
  value       = module.blnk_finance.postgres_endpoint
}

output "redis_endpoint" {
  description = "Endpoint of the Redis cluster"
  value       = module.blnk_finance.redis_endpoint
}