# Blnk-Finance AWS Infrastructure Module
This repository contains the Terraform configuration files for setting up the Blnk-Finance infrastructure stack on AWS. The stack includes resources for Redis, PostgreSQL, EC2 instances, Auto Scaling Groups, Application Load Balancer (ALB), ACM, Security Group, CloudWatch alarms, and dashboards.

### File Descriptions
`main.tf`

This file contains the main Terraform configuration for the Blnk-Finance AWS infrastructure. It includes the following resources:

- Redis: Configures an ElastiCache Redis cluster, or you can bring your own redis
- PostgreSQL RDS: Configures a PostgreSQL RDS instance, or provide your own postgres.
- Key Pair: Creates an SSH key pair for EC2 instances or specify your own key_pair.
- Security Groups: Defines security groups for EC2 instances and ALB or use your existing security group.
- Launch Configurations and Auto Scaling Groups: Configures launch configurations and auto-scaling groups for the Blnk - server and worker instances.
- Application Load Balancer: Sets up an ALB with listeners and target groups.
- Route 53 DNS Record: Creates DNS records for the ALB.
- ACM Certificate: Manages ACM certificates for SSL.

`variables.tf`

This file defines the input variables used in the Terraform configuration. It includes variables for configuring Redis, PostgreSQL, EC2 instances, Auto Scaling Groups, ALB, CloudWatch alarms, and dashboards.

`outputs.tf`

This file defines the output values for the Terraform configuration. It includes outputs for key resources such as the key pair name and security group IDs.
```
output "key_pair_name" {
  value = aws_key_pair.key.key_name
}

output "instance_security_group_id" {
  value = aws_security_group.instance_sg.id
}
....
```

`locals.tf`

This file defines local variables used in the Terraform configuration. It includes local variables for service names and other reusable values.
```
locals {
  service_name = "blnk"
  ...
}
```

`datasource.tf`

This file defines the data sources used in the Terraform configuration. It includes a data source for fetching an existing ACM certificate.

`cloudwatch.tf`

This file contains the configuration for creating CloudWatch alarms and dashboards for the EC2 instances and ALB. It includes:

- SNS Topic: Creates an SNS topic for CloudWatch alarm notifications.
- CloudWatch Alarms: Configures alarms for EC2 CPU utilization, memory utilization, ALB 5XX errors, network in/out, and disk write operations.
- CloudWatch Dashboard: Creates a dashboard for monitoring EC2 and ALB metrics.

`blnk-server.sh`

This Bash script sets up and deploys the Blnk-Finance server service. It performs the following tasks:

Sets up environment variables for Redis, PostgreSQL, SSL email, Slack webhook, and Blnk version.
Detects the operating system to determine the appropriate Docker installation commands.
Checks if Docker is installed and installs it if necessary.
Ensures the configuration directory exists.
Creates a JSON configuration file with the provided environment variables.
Deploys the blnk-fiance server service using Docker.

`blnk-worker.sh`

This Bash script sets up and deploys the Blnk-Finance worker service. It performs similar tasks to the `blnk-server.sh` script but is tailored for the worker service.

## Module Usage
To use this module, include it in your Terraform configuration as follows:

```
module "blnk_finance" {
  source                   = "../../blnk-aws/"
  vpc_id                   = "vpc-xxxxxxxx"
  subnet_ids               = ["subnet-xxxxxx", "subnet-xxxxxx"]
  key_name                 = "my-key-pair"
  existing_security_group  = "sg-xxxxxxx"
  domain_name              = "my-domain"
  zone_id                  = "MY_ZONE_ID"
  create_acm_certificate   = true
  enable_cw_alarms         = true
  enable_postgres          = true
  postgres_instance_type   = "db.t3.micro"
  enable_redis             = true
  redis_instance_type      = "cache.t3.micro"
  redis_host               = "redis.example.com"
  ssl_email                = "your-email@example.com"
  slack_webhook            = "https://hooks.slack.com/services/your/webhook/url"
  tags                     = {
    Environment = "test"
    Project     = "blnk-finance"
  }
}
```

### Steps
Initialize Terraform: Run terraform init to initialize the Terraform configuration.
Plan the Deployment: Run terraform plan to see the changes that will be made by the Terraform configuration.
Apply the Configuration: Run terraform apply to apply the Terraform configuration and create the resources on AWS.
Destroy the Resources: Run terraform destroy to destroy the resources created by the Terraform configuration.
Customization
You can customize the configuration by modifying the variables in the variables.tf file. For example, you can change the instance types, desired capacities, and thresholds for CloudWatch alarms.

Conclusion
This Terraform configuration sets up a complete infrastructure for the Blnk-Finance application on AWS, including Redis, PostgreSQL, EC2 instances, Auto Scaling Groups, ALB, CloudWatch alarms, and dashboards. By using this configuration, you can quickly deploy and manage the Blnk-Finance application stack on AWS.
##

# Module Specs

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_alb.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb) | resource |
| [aws_alb_listener.http_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener) | resource |
| [aws_alb_target_group.alb_target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_target_group) | resource |
| [aws_autoscaling_group.blnk_server_asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_autoscaling_group.blnk_worker_asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_cloudwatch_dashboard.ec2_dashboard](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_dashboard) | resource |
| [aws_cloudwatch_metric_alarm.alb_5xx_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.disk_write_ops_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.ec2_cpu_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.ec2_memory_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.network_in_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.network_out_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_db_instance.postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.postgres_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_elasticache_cluster.redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_elasticache_subnet_group.redis_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_key_pair.key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_launch_configuration.blnk_server_app_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration) | resource |
| [aws_launch_configuration.blnk_worker_app_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration) | resource |
| [aws_lb_listener.https_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener_rule.alb_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_route53_record.acm_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.dns_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.alb_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.instance_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_sns_topic.sns_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_acm_certificate.cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_ami.amazon_linux](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_certificate_arn"></a> [acm\_certificate\_arn](#input\_acm\_certificate\_arn) | ARN of the ACM certificate to use | `string` | `""` | no |
| <a name="input_blnk_server_desired_capacity"></a> [blnk\_server\_desired\_capacity](#input\_blnk\_server\_desired\_capacity) | The desired capacity for the blnk\_server ASG | `number` | `1` | no |
| <a name="input_blnk_server_instance_type"></a> [blnk\_server\_instance\_type](#input\_blnk\_server\_instance\_type) | The instance type for the blnk\_server | `string` | `"t2.micro"` | no |
| <a name="input_blnk_server_max_size"></a> [blnk\_server\_max\_size](#input\_blnk\_server\_max\_size) | The maximum size for the blnk\_server ASG | `number` | `2` | no |
| <a name="input_blnk_server_min_size"></a> [blnk\_server\_min\_size](#input\_blnk\_server\_min\_size) | The minimum size for the blnk\_server ASG | `number` | `1` | no |
| <a name="input_blnk_version"></a> [blnk\_version](#input\_blnk\_version) | Version of the Blnk application | `string` | `"0.8.0"` | no |
| <a name="input_blnk_worker_desired_capacity"></a> [blnk\_worker\_desired\_capacity](#input\_blnk\_worker\_desired\_capacity) | The desired capacity for the blnk\_worker ASG | `number` | `1` | no |
| <a name="input_blnk_worker_instance_type"></a> [blnk\_worker\_instance\_type](#input\_blnk\_worker\_instance\_type) | The instance type for the blnk\_worker | `string` | `"t2.micro"` | no |
| <a name="input_blnk_worker_max_size"></a> [blnk\_worker\_max\_size](#input\_blnk\_worker\_max\_size) | The maximum size for the blnk\_worker ASG | `number` | `2` | no |
| <a name="input_blnk_worker_min_size"></a> [blnk\_worker\_min\_size](#input\_blnk\_worker\_min\_size) | The minimum size for the blnk\_worker ASG | `number` | `1` | no |
| <a name="input_create_acm_certificate"></a> [create\_acm\_certificate](#input\_create\_acm\_certificate) | Whether to create a new ACM certificate | `bool` | `false` | no |
| <a name="input_create_rds"></a> [create\_rds](#input\_create\_rds) | Whether to create an RDS instance | `bool` | `false` | no |
| <a name="input_custom_postgres_url"></a> [custom\_postgres\_url](#input\_custom\_postgres\_url) | Custom PostgreSQL URL for Blnk Server and Worker | `string` | `""` | no |
| <a name="input_custom_redis_url"></a> [custom\_redis\_url](#input\_custom\_redis\_url) | Custom Redis URL for Blnk Server and Worker | `string` | `""` | no |
| <a name="input_cw_alert_thresholds"></a> [cw\_alert\_thresholds](#input\_cw\_alert\_thresholds) | Custom thresholds for CloudWatch alarms | <pre>object({<br/>    ec2_cpu_utilization    = optional(number, 80),<br/>    ec2_memory_utilization = optional(number, 80),<br/>    alb_5xx_count          = optional(number, 10),<br/>    network_in_alarm       = optional(number, 100000000), # 100 MB<br/>    network_out_alarm      = optional(number, 100000000), # 100 MB<br/>    disk_write_ops_alarm   = optional(number, 1000)<br/>  })</pre> | `{}` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The domain name for the Route 53 record | `string` | n/a | yes |
| <a name="input_enable_cw_alarms"></a> [enable\_cw\_alarms](#input\_enable\_cw\_alarms) | Whether to enable CloudWatch alarms | `bool` | `false` | no |
| <a name="input_enable_cw_dashboard"></a> [enable\_cw\_dashboard](#input\_enable\_cw\_dashboard) | Whether to enable the CloudWatch dashboard | `bool` | `false` | no |
| <a name="input_enable_postgres"></a> [enable\_postgres](#input\_enable\_postgres) | Whether to enable PostgreSQL database creation | `bool` | `true` | no |
| <a name="input_enable_redis"></a> [enable\_redis](#input\_enable\_redis) | Whether to enable Redis cache creation | `bool` | `true` | no |
| <a name="input_existing_security_group"></a> [existing\_security\_group](#input\_existing\_security\_group) | ID of an existing security group | `string` | `""` | no |
| <a name="input_instance_refresh_instance_warmup"></a> [instance\_refresh\_instance\_warmup](#input\_instance\_refresh\_instance\_warmup) | Instance warmup time for instance refresh | `number` | `300` | no |
| <a name="input_instance_refresh_min_healthy_percentage"></a> [instance\_refresh\_min\_healthy\_percentage](#input\_instance\_refresh\_min\_healthy\_percentage) | Minimum healthy percentage for instance refresh | `number` | `50` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | The name of the key pair to use for the instances | `string` | `null` | no |
| <a name="input_optional_sg_inbound_rules"></a> [optional\_sg\_inbound\_rules](#input\_optional\_sg\_inbound\_rules) | Optional inbound rules for the instance security group | <pre>list(object({<br/>    from_port   = number<br/>    to_port     = number<br/>    protocol    = string<br/>    cidr_blocks = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_postgres_allocated_storage"></a> [postgres\_allocated\_storage](#input\_postgres\_allocated\_storage) | Allocated storage for PostgreSQL | `number` | `20` | no |
| <a name="input_postgres_db_name"></a> [postgres\_db\_name](#input\_postgres\_db\_name) | Database name for PostgreSQL | `string` | `"blnkfinance"` | no |
| <a name="input_postgres_engine_version"></a> [postgres\_engine\_version](#input\_postgres\_engine\_version) | Engine version for PostgreSQL | `string` | `"17.2"` | no |
| <a name="input_postgres_identifier"></a> [postgres\_identifier](#input\_postgres\_identifier) | Identifier for the PostgreSQL instance | `string` | `"blnk-db"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | The instance type for the PostgreSQL RDS instance | `string` | `"db.t3.micro"` | no |
| <a name="input_postgres_multi_az"></a> [postgres\_multi\_az](#input\_postgres\_multi\_az) | Whether to enable Multi-AZ for PostgreSQL | `bool` | `false` | no |
| <a name="input_postgres_password"></a> [postgres\_password](#input\_postgres\_password) | Password for PostgreSQL | `string` | `"securepassword"` | no |
| <a name="input_postgres_subnet_group_name"></a> [postgres\_subnet\_group\_name](#input\_postgres\_subnet\_group\_name) | Name of the PostgreSQL subnet group | `string` | `"blnk-postgres-subnet-group"` | no |
| <a name="input_postgres_username"></a> [postgres\_username](#input\_postgres\_username) | Username for PostgreSQL | `string` | `"postgres"` | no |
| <a name="input_redis_cluster_id"></a> [redis\_cluster\_id](#input\_redis\_cluster\_id) | ID of the Redis cluster | `string` | `"redis-cluster"` | no |
| <a name="input_redis_engine_version"></a> [redis\_engine\_version](#input\_redis\_engine\_version) | Engine version for Redis | `string` | `"7.0"` | no |
| <a name="input_redis_host"></a> [redis\_host](#input\_redis\_host) | Redis host for the blnk-blnk\_server.sh script | `string` | `"blnk-redis"` | no |
| <a name="input_redis_instance_type"></a> [redis\_instance\_type](#input\_redis\_instance\_type) | The instance type for the Redis ElastiCache cluster | `string` | `"cache.t3.micro"` | no |
| <a name="input_redis_num_cache_nodes"></a> [redis\_num\_cache\_nodes](#input\_redis\_num\_cache\_nodes) | Number of cache nodes for Redis | `number` | `1` | no |
| <a name="input_redis_parameter_group_name"></a> [redis\_parameter\_group\_name](#input\_redis\_parameter\_group\_name) | Parameter group name for Redis | `string` | `"default.redis7"` | no |
| <a name="input_redis_port"></a> [redis\_port](#input\_redis\_port) | Port for Redis | `number` | `6379` | no |
| <a name="input_redis_subnet_group_name"></a> [redis\_subnet\_group\_name](#input\_redis\_subnet\_group\_name) | Name of the Redis subnet group | `string` | `"redis-subnet-group"` | no |
| <a name="input_slack_webhook"></a> [slack\_webhook](#input\_slack\_webhook) | Slack webhook URL for notifications | `string` | `""` | no |
| <a name="input_sns_topic_arn"></a> [sns\_topic\_arn](#input\_sns\_topic\_arn) | ARN of the SNS topic to use for CloudWatch alarms | `string` | `""` | no |
| <a name="input_ssl_email"></a> [ssl\_email](#input\_ssl\_email) | Email address for SSL certificate | `string` | `""` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_update_strategy"></a> [update\_strategy](#input\_update\_strategy) | Update strategy for the Blnk Service and Worker Auto Scaling Group. Options are 'rolling\_update' or 'instance\_refresh'. | `string` | `"instance_refresh"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC | `string` | n/a | yes |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | The ID of the Route 53 hosted zone | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_5xx_alarm_arn"></a> [alb\_5xx\_alarm\_arn](#output\_alb\_5xx\_alarm\_arn) | ARN of the ALB 5XX error count alarm |
| <a name="output_alb_arn"></a> [alb\_arn](#output\_alb\_arn) | ARN of the ALB |
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | DNS name of the ALB |
| <a name="output_alb_http_listener_arn"></a> [alb\_http\_listener\_arn](#output\_alb\_http\_listener\_arn) | ARN of the ALB HTTP listener |
| <a name="output_alb_https_listener_arn"></a> [alb\_https\_listener\_arn](#output\_alb\_https\_listener\_arn) | ARN of the ALB HTTPS listener |
| <a name="output_alb_security_group_id"></a> [alb\_security\_group\_id](#output\_alb\_security\_group\_id) | ID of the ALB security group |
| <a name="output_alb_target_group_arn"></a> [alb\_target\_group\_arn](#output\_alb\_target\_group\_arn) | ARN of the ALB target group |
| <a name="output_blnk_server_asg_name"></a> [blnk\_server\_asg\_name](#output\_blnk\_server\_asg\_name) | Name of the blnk\_server auto-scaling group |
| <a name="output_blnk_server_launch_configuration_id"></a> [blnk\_server\_launch\_configuration\_id](#output\_blnk\_server\_launch\_configuration\_id) | ID of the blnk\_server launch configuration |
| <a name="output_blnk_worker_asg_name"></a> [blnk\_worker\_asg\_name](#output\_blnk\_worker\_asg\_name) | Name of the blnk\_worker auto-scaling group |
| <a name="output_blnk_worker_launch_configuration_id"></a> [blnk\_worker\_launch\_configuration\_id](#output\_blnk\_worker\_launch\_configuration\_id) | ID of the blnk\_worker launch configuration |
| <a name="output_disk_write_ops_alarm_arn"></a> [disk\_write\_ops\_alarm\_arn](#output\_disk\_write\_ops\_alarm\_arn) | ARN of the EC2 disk write operations alarm |
| <a name="output_ec2_cpu_alarm_arn"></a> [ec2\_cpu\_alarm\_arn](#output\_ec2\_cpu\_alarm\_arn) | ARN of the EC2 CPU utilization alarm |
| <a name="output_ec2_dashboard_name"></a> [ec2\_dashboard\_name](#output\_ec2\_dashboard\_name) | Name of the EC2 CloudWatch dashboard |
| <a name="output_ec2_memory_alarm_arn"></a> [ec2\_memory\_alarm\_arn](#output\_ec2\_memory\_alarm\_arn) | ARN of the EC2 memory utilization alarm |
| <a name="output_instance_security_group_id"></a> [instance\_security\_group\_id](#output\_instance\_security\_group\_id) | ID of the instance security group |
| <a name="output_key_pair_name"></a> [key\_pair\_name](#output\_key\_pair\_name) | Name of the key pair |
| <a name="output_network_in_alarm_arn"></a> [network\_in\_alarm\_arn](#output\_network\_in\_alarm\_arn) | ARN of the EC2 network in alarm |
| <a name="output_network_out_alarm_arn"></a> [network\_out\_alarm\_arn](#output\_network\_out\_alarm\_arn) | ARN of the EC2 network out alarm |
| <a name="output_postgres_endpoint"></a> [postgres\_endpoint](#output\_postgres\_endpoint) | PostgreSQL RDS endpoint |
| <a name="output_redis_endpoint"></a> [redis\_endpoint](#output\_redis\_endpoint) | Redis Configuration endpoint |
| <a name="output_route53_record_name"></a> [route53\_record\_name](#output\_route53\_record\_name) | Name of the Route 53 record |
| <a name="output_sns_topic_arn"></a> [sns\_topic\_arn](#output\_sns\_topic\_arn) | ARN of the SNS topic used for CloudWatch alarms |


#
*Side note to reader*
-  This file contains the main Terraform configuration for the Blnk AWS infrastructure
-  Redis and PostgreSQL RDS are optional resources that can be enabled or disabled using the `enable_redis` and `enable_postgres` variables
-  The `existing_security_group` variable can be used to specify an existing security group to use for the EC2 instances
-  The `optional_sg_inbound_rules` variable can be used to specify additional inbound rules for the instance security group
-  The `create_acm_certificate` variable can be used to create a new ACM certificate for the ALB
-  The `acm_certificate_arn` variable can be used to specify an existing ACM certificate to use for the ALB
-  The `tags` variable can be used to specify tags to apply to resources
-  The `ssl_email` and `slack_webhook` variables are used to configure the email address for SSL certificate notifications and the Slack webhook URL for CloudWatch alarms
-  The `subnet_ids` variable should be set to a list of subnet IDs in the VPC
-  The `zone_id` variable should be set to the Route 53 hosted zone ID
-  The `domain_name` variable should be set to the domain name for the Route 53 record
-  The `key_name` variable can be used to specify the name of an existing key pair to use for the EC2 instances
-  The `postgres_multi_az` variable can be used to enable Multi-AZ for the PostgreSQL RDS instance
-  The `enable_cw_alarms` variable can be used to enable CloudWatch alarms for EC2 instances and the ALB
-  The `enable_postgres` and `enable_redis` variables can be used to enable or disable the Redis and PostgreSQL RDS resources

#
Maintained by Bolatito Kabir @iamtito