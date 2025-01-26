# Blnk-Finance Infrastructure Modules
This repository contains Terraform modules for setting up the Blnk-Finance application stack on various cloud platforms, including AWS, Azure, and GCP. Each folder contains the necessary configurations to deploy the application stack on the respective cloud provider.

## Module Descriptions
### `blnk-aws` - `In Progress`
This module sets up the Blnk-Finance application stack on AWS. It includes resources for:

- **Amazon ElastiCache (Redis)**: Configures a Redis cluster.
- **Amazon RDS (PostgreSQL)**: Configures a PostgreSQL database instance.
- **Amazon EC2 Instances**: Sets up EC2 instances for the Blnk server and worker services.
- **Auto Scaling Groups**: Configures Auto Scaling Groups for the EC2 instances.
- **Application Load Balancer (ALB)**: Sets up an ALB with listeners and target groups.
- **Security Groups**: Defines security groups for the EC2 instances and ALB.
- **Amazon CloudWatch Alarms and Dashboards**: Creates CloudWatch alarms and dashboards for monitoring the infrastructure.
- **Amazon Route 53 DNS Records**: Manages DNS records for the ALB.
- **AWS Certificate Manager (ACM)**: Manages ACM certificates for SSL.

*Note: You can use your own Redis, Postgress, existing security group and SNS Topic*

### `blnk-azure` - `Not Started`
This module sets up the Blnk-Finance application stack on Azure. It includes resources for:

- **Azure Cache for Redis**: Configures a Redis Cache instance.
- **Azure Database for PostgreSQL**: Sets up a PostgreSQL database instance.
- **Azure Virtual Machines**: Configures virtual machines for the Blnk server and worker services.
- **Virtual Machine Scale Sets**: Sets up scale sets for the virtual machines to enable auto-scaling.
- **Azure Load Balancer**: Configures a Load Balancer with backend pools and rules.
- **Network Security Groups**: Defines network security groups for the virtual machines and load balancer.
- **Azure Monitor Alerts and Dashboards**: Creates alerts and dashboards for monitoring the infrastructure.
- **Azure DNS Zones**: Manages DNS records for the load balancer.
- **Azure Key Vault**: Manages SSL certificates and secrets.

### `blnk-gcp` - `Not Started`

This module sets up the Blnk-Finance application stack on Google Cloud Platform (GCP). It includes resources for:

- **Google Cloud Memorystore (Redis)**: Configures a Redis instance.
- **Google Cloud SQL (PostgreSQL)**: Sets up a PostgreSQL database instance.
- **Google Compute Engine Instances**: Configures Compute Engine instances for the Blnk server and worker services.
- **Instance Groups**: Sets up instance groups for the Compute Engine instances to enable auto-scaling.
- **Google Cloud Load Balancing**: Configures a Load Balancer with backend services and URL maps.
- **Firewall Rules**: Defines firewall rules for the Compute Engine instances and load balancer.
- **Google Cloud Monitoring and Logging**: Creates monitoring alerts and dashboards using Google Cloud Monitoring.
- **Google Cloud DN**S: Manages DNS records for the load balancer.
- **Google Cloud Certificate Manager**: Manages SSL certificates for the load balancer.

## Usage
To use these modules, include them in your Terraform configuration as follows:

```
provider "your_cloud_provider" {
  
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
  tags = {
    Environment = "test"
    Project     = "blnk-finance"
  }
}

```

### Steps

1. **Initialize Terraform**: Run terraform init to initialize the Terraform configuration.
2. **Plan the Deployment**: Run terraform plan to see the changes that will be made by the Terraform configuration.
3. **Apply the Configuration**: Run terraform apply to apply the Terraform configuration and create the resources on the respective cloud platform.
4. **Destroy the Resources**: Run terraform destroy to destroy the resources created by the Terraform configuration.

### Customization
You can customize the configuration by modifying the variables in each module. For example, you can change the instance types, desired capacities, and thresholds for monitoring alerts.

### Conclusion
This repository provides Terraform modules for deploying the Blnk-Finance infrastructure stack on AWS - `In Progress`, Azure - `no ready` , and GCP - `no ready`. By using these modules, you can quickly deploy and manage the Blnk-Finance application stack on your preferred cloud platform.