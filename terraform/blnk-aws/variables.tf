variable "blnk_version" {
  description = "Version of the Blnk application"
  type        = string
  default     = "0.8.0"
}

variable "enable_redis" {
  description = "Whether to enable Redis cache creation"
  type        = bool
  default     = true
}

variable "custom_redis_url" {
  description = "Custom Redis URL for Blnk Server and Worker"
  type        = string
  default     = ""
}

variable "redis_subnet_group_name" {
  description = "Name of the Redis subnet group"
  type        = string
  default     = "redis-subnet-group"
}

variable "redis_cluster_id" {
  description = "ID of the Redis cluster"
  type        = string
  default     = "redis-cluster"
}

variable "redis_engine_version" {
  description = "Engine version for Redis"
  type        = string
  default     = "7.0"
}

variable "redis_instance_type" {
  description = "The instance type for the Redis ElastiCache cluster"
  type        = string
  default     = "cache.t3.micro"
}

variable "redis_host" {
  description = "Redis host for the blnk-blnk_server.sh script"
  type        = string
  default     = "blnk-redis"
}

variable "redis_num_cache_nodes" {
  description = "Number of cache nodes for Redis"
  type        = number
  default     = 1
}

variable "redis_parameter_group_name" {
  description = "Parameter group name for Redis"
  type        = string
  default     = "default.redis7"
}

variable "redis_port" {
  description = "Port for Redis"
  type        = number
  default     = 6379
}

variable "enable_postgres" {
  description = "Whether to enable PostgreSQL database creation"
  type        = bool
  default     = true
}

variable "custom_postgres_url" {
  description = "Custom PostgreSQL URL for Blnk Server and Worker"
  type        = string
  default     = ""
}

variable "postgres_subnet_group_name" {
  description = "Name of the PostgreSQL subnet group"
  type        = string
  default     = "blnk-postgres-subnet-group"
}

variable "postgres_allocated_storage" {
  description = "Allocated storage for PostgreSQL"
  type        = number
  default     = 20
}

variable "postgres_instance_type" {
  description = "The instance type for the PostgreSQL RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "postgres_engine_version" {
  description = "Engine version for PostgreSQL"
  type        = string
  default     = "17.2"
}

variable "postgres_identifier" {
  description = "Identifier for the PostgreSQL instance"
  type        = string
  default     = "blnk-db"
}

variable "postgres_username" {
  description = "Username for PostgreSQL"
  type        = string
  default     = "postgres"
}

variable "postgres_password" {
  description = "Password for PostgreSQL"
  type        = string
  default     = "securepassword"
  sensitive   = true
}

variable "postgres_db_name" {
  description = "Database name for PostgreSQL"
  type        = string
  default     = "blnkfinance"
}

variable "postgres_multi_az" {
  description = "Whether to enable Multi-AZ for PostgreSQL"
  type        = bool
  default     = false
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "existing_security_group" {
  description = "ID of an existing security group"
  type        = string
  default     = ""
}

variable "optional_sg_inbound_rules" {
  description = "Optional inbound rules for the instance security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate to use"
  type        = string
  default     = ""
}

variable "create_acm_certificate" {
  description = "Whether to create a new ACM certificate"
  type        = bool
  default     = false
}

variable "key_name" {
  description = "The name of the key pair to use for the instances"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "update_strategy" {
  description = "Update strategy for the Blnk Service and Worker Auto Scaling Group. Options are 'rolling_update' or 'instance_refresh'."
  type        = string
  default     = "instance_refresh"
}

variable "instance_refresh_min_healthy_percentage" {
  description = "Minimum healthy percentage for instance refresh"
  type        = number
  default     = 50
}

variable "instance_refresh_instance_warmup" {
  description = "Instance warmup time for instance refresh"
  type        = number
  default     = 300
}

variable "blnk_server_instance_type" {
  description = "The instance type for the blnk_server"
  type        = string
  default     = "t2.micro"
}

variable "blnk_worker_instance_type" {
  description = "The instance type for the blnk_worker"
  type        = string
  default     = "t2.micro"
}

variable "blnk_server_desired_capacity" {
  description = "The desired capacity for the blnk_server ASG"
  type        = number
  default     = 1
}

variable "blnk_server_max_size" {
  description = "The maximum size for the blnk_server ASG"
  type        = number
  default     = 2
}

variable "blnk_server_min_size" {
  description = "The minimum size for the blnk_server ASG"
  type        = number
  default     = 1
}

variable "blnk_worker_desired_capacity" {
  description = "The desired capacity for the blnk_worker ASG"
  type        = number
  default     = 1
}

variable "blnk_worker_max_size" {
  description = "The maximum size for the blnk_worker ASG"
  type        = number
  default     = 2
}

variable "blnk_worker_min_size" {
  description = "The minimum size for the blnk_worker ASG"
  type        = number
  default     = 1
}

variable "create_rds" {
  description = "Whether to create an RDS instance"
  type        = bool
  default     = false
}

variable "zone_id" {
  description = "The ID of the Route 53 hosted zone"
  type        = string
}

variable "domain_name" {
  description = "The domain name for the Route 53 record"
  type        = string
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic to use for CloudWatch alarms"
  type        = string
  default     = ""
}

variable "enable_cw_alarms" {
  description = "Whether to enable CloudWatch alarms"
  type        = bool
  default     = false
}

variable "cw_alert_thresholds" {
  description = "Custom thresholds for CloudWatch alarms"
  type = object({
    ec2_cpu_utilization    = optional(number, 80),
    ec2_memory_utilization = optional(number, 80),
    alb_5xx_count          = optional(number, 10),
    network_in_alarm       = optional(number, 100000000), # 100 MB
    network_out_alarm      = optional(number, 100000000), # 100 MB
    disk_write_ops_alarm   = optional(number, 1000)
  })
  default = {}
}

variable "enable_cw_dashboard" {
  description = "Whether to enable the CloudWatch dashboard"
  type        = bool
  default     = false
}

variable "ssl_email" {
  description = "Email address for SSL certificate"
  type        = string
  default     = ""
}

variable "slack_webhook" {
  description = "Slack webhook URL for notifications"
  type        = string
  default     = ""
}
