output "key_pair_name" {
  description = "Name of the key pair"
  value       = length(aws_key_pair.key) > 0 ? aws_key_pair.key[0].key_name : var.key_name
}

output "instance_security_group_id" {
  description = "ID of the instance security group"
  value       = length(aws_security_group.instance_sg) > 0 ? aws_security_group.instance_sg[0].id : var.existing_security_group
}

output "alb_security_group_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb_sg.id
}

output "blnk_server_launch_configuration_id" {
  description = "ID of the blnk_server launch configuration"
  value       = aws_launch_configuration.blnk_server_app_config.id
}

output "blnk_worker_launch_configuration_id" {
  description = "ID of the blnk_worker launch configuration"
  value       = aws_launch_configuration.blnk_worker_app_config.id
}

output "blnk_server_asg_name" {
  description = "Name of the blnk_server auto-scaling group"
  value       = aws_autoscaling_group.blnk_server_asg.name
}

output "blnk_worker_asg_name" {
  description = "Name of the blnk_worker auto-scaling group"
  value       = aws_autoscaling_group.blnk_worker_asg.name
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_alb.alb.dns_name
}

output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_alb.alb.arn
}

output "alb_target_group_arn" {
  description = "ARN of the ALB target group"
  value       = aws_alb_target_group.alb_target_group.arn
}

output "alb_http_listener_arn" {
  description = "ARN of the ALB HTTP listener"
  value       = aws_alb_listener.http_listener.arn
}

output "alb_https_listener_arn" {
  description = "ARN of the ALB HTTPS listener"
  value       = aws_lb_listener.https_listener.arn
}

output "route53_record_name" {
  description = "Name of the Route 53 record"
  value       = aws_route53_record.dns_record.name
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic used for CloudWatch alarms"
  value       = length(aws_sns_topic.sns_topic) > 0 ? aws_sns_topic.sns_topic[0].arn : var.sns_topic_arn
}

output "ec2_cpu_alarm_arn" {
  description = "ARN of the EC2 CPU utilization alarm"
  value       = length(aws_cloudwatch_metric_alarm.ec2_cpu_alarm) > 0 ? aws_cloudwatch_metric_alarm.ec2_cpu_alarm[0].arn : "Cloudwatch alarms not enabled"
}

output "ec2_memory_alarm_arn" {
  description = "ARN of the EC2 memory utilization alarm"
  value       = length(aws_cloudwatch_metric_alarm.ec2_memory_alarm) > 0 ? aws_cloudwatch_metric_alarm.ec2_memory_alarm[0].arn : "Cloudwatch alarms not enabled"
}

output "alb_5xx_alarm_arn" {
  description = "ARN of the ALB 5XX error count alarm"
  value       = length(aws_cloudwatch_metric_alarm.alb_5xx_alarm) > 0 ? aws_cloudwatch_metric_alarm.alb_5xx_alarm[0].arn : "Cloudwatch alarms not enabled"
}

output "network_in_alarm_arn" {
  description = "ARN of the EC2 network in alarm"
  value       = length(aws_cloudwatch_metric_alarm.network_in_alarm) > 0 ? aws_cloudwatch_metric_alarm.network_in_alarm[0].arn : "Cloudwatch alarms not enabled"
}

output "network_out_alarm_arn" {
  description = "ARN of the EC2 network out alarm"
  value       = length(aws_cloudwatch_metric_alarm.network_out_alarm) > 0 ? aws_cloudwatch_metric_alarm.network_out_alarm[0].arn : "Cloudwatch alarms not enabled"
}

output "disk_write_ops_alarm_arn" {
  description = "ARN of the EC2 disk write operations alarm"
  value       = length(aws_cloudwatch_metric_alarm.disk_write_ops_alarm) > 0 ? aws_cloudwatch_metric_alarm.disk_write_ops_alarm[0].arn : "Cloudwatch alarms not enabled"
}

output "ec2_dashboard_name" {
  description = "Name of the EC2 CloudWatch dashboard"
  value       = length(aws_cloudwatch_dashboard.ec2_dashboard) > 0 ? aws_cloudwatch_dashboard.ec2_dashboard[0].dashboard_name : "Cloudwatch Dashboard not enabled"
}

output "postgres_endpoint" {
  value       = aws_db_instance.postgres[0].endpoint
  description = "PostgreSQL RDS endpoint"
}
output "redis_endpoint" {
  value       = aws_elasticache_cluster.redis[0].configuration_endpoint
  description = "Redis Configuration endpoint"
}
