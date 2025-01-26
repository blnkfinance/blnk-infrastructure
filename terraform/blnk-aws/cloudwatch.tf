# Purpose: This file contains the code to create CloudWatch alarms and dashboards for the EC2 instances and ALB.
# SNS topic
resource "aws_sns_topic" "sns_topic" {
  count = var.sns_topic_arn == "" && var.enable_cw_alarms ? 1 : 0
  name  = "${local.alb_name}-sns"
}

# CloudWatch alarms
resource "aws_cloudwatch_metric_alarm" "ec2_cpu_alarm" {
  count               = var.enable_cw_alarms ? 1 : 0
  alarm_name          = "${local.instance_name}-CPUUtilizationHigh"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = local.thresholds.ec2_cpu_utilization
  alarm_actions       = [local.sns_topic_arn]
  dimensions = {
    InstanceId = aws_autoscaling_group.blnk_server_asg.id
  }
}

resource "aws_cloudwatch_metric_alarm" "ec2_memory_alarm" {
  count               = var.enable_cw_alarms ? 1 : 0
  alarm_name          = "${local.instance_name}-MemoryUtilizationHigh"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "MemoryUtilization"
  namespace           = "CWAgent" # Requires CloudWatch Agent to be installed
  period              = 300
  statistic           = "Average"
  threshold           = local.thresholds.ec2_memory_utilization
  alarm_actions       = [local.sns_topic_arn]
  dimensions = {
    InstanceId = aws_autoscaling_group.blnk_server_asg.id
  }
}

resource "aws_cloudwatch_metric_alarm" "alb_5xx_alarm" {
  count               = var.enable_cw_alarms ? 1 : 0
  alarm_name          = "${local.alb_name}-HTTPCode_ELB_5XX_Count"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = local.thresholds.alb_5xx_count
  alarm_actions       = [local.sns_topic_arn]
  dimensions = {
    LoadBalancer = aws_alb.alb.name
  }
}

resource "aws_cloudwatch_metric_alarm" "network_in_alarm" {
  count               = var.enable_cw_alarms ? 1 : 0
  alarm_name          = "${local.instance_name}-NetworkInHigh"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "NetworkIn"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Sum"
  threshold           = local.thresholds.network_in_alarm
  alarm_actions       = [local.sns_topic_arn]
  dimensions = {
    InstanceId = aws_autoscaling_group.blnk_server_asg.id
  }
}

resource "aws_cloudwatch_metric_alarm" "network_out_alarm" {
  count               = var.enable_cw_alarms ? 1 : 0
  alarm_name          = "${local.instance_name}-NetworkOutHigh"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "NetworkOut"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Sum"
  threshold           = local.thresholds.network_out_alarm
  alarm_actions       = [local.sns_topic_arn]
  dimensions = {
    InstanceId = aws_autoscaling_group.blnk_server_asg.id
  }
}

resource "aws_cloudwatch_metric_alarm" "disk_write_ops_alarm" {
  count               = var.enable_cw_alarms ? 1 : 0
  alarm_name          = "${local.instance_name}-DiskWriteOpsHigh"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "DiskWriteOps"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Sum"
  threshold           = local.thresholds.disk_write_ops_alarm
  alarm_actions       = [local.sns_topic_arn]
  dimensions = {
    InstanceId = aws_autoscaling_group.blnk_server_asg.id
  }
}

# CloudWatch dashboard
resource "aws_cloudwatch_dashboard" "ec2_dashboard" {
  count          = var.enable_cw_dashboard ? 1 : 0
  dashboard_name = "Blnk-EC2-Metrics-Dashboard"
  dashboard_body = jsonencode({
    "widgets" = [
      {
        "type"   = "metric",
        "x"      = 0,
        "y"      = 0,
        "width"  = 24,
        "height" = 6,
        "properties" = {
          "metrics" = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", aws_autoscaling_group.blnk_server_asg.id]
          ],
          "view"    = "timeSeries",
          "stacked" = false,
          "region"  = "us-east-1",
          "period"  = 300,
          "stat"    = "Average",
          "title"   = "EC2 CPU Utilization"
        }
      },
      {
        "type"   = "metric",
        "x"      = 0,
        "y"      = 6,
        "width"  = 24,
        "height" = 6,
        "properties" = {
          "metrics" = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", aws_alb.alb.name]
          ],
          "view"    = "timeSeries",
          "stacked" = false,
          "region"  = "us-east-1",
          "period"  = 300,
          "stat"    = "Sum",
          "title"   = "ALB Request Count"
        }
      }
    ]
  })
}
