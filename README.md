Blnk-Finance Infrastructure
This repository contains Terraform modules for setting up the Blnk-Finance application stack on various cloud platforms, including AWS, Azure, and GCP. Each folder contains the necessary configurations to deploy the application stack on the respective cloud provider.

Folder Structure
```
blnk-infrastructure/
├── ansible/
│   ├── files
│   │   ├── blnk.json.sh
│   ├── task
│   │   ├── main.yml
│   ├── vars
│   │   ├── variables.yml
│   ├── templates
│   │   ├── blnk.json.j2
├── kubernetes/
│   ├── deployments
├── scripts/
│   ├── bash
│   │   ├── blnk-server.sh
│   │   ├── blnk-worker.sh
├── blnk-aws/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── locals.tf
│   ├── datasource.tf
│   ├── cloudwatch.tf
├── blnk-azure/
├── blnk-gcp/
├── examples/
│   ├── aws-deploy/
│   │   ├── main.tf
│   │   ├── output.tf
├── README.md
```

## Folder Descriptions

### `blnk-aws`
Contains the Terraform module for setting up the Blnk-Finance infrastructure stack on AWS, including resources for EC2, RDS, ElastiCache, ALB, security groups, CloudWatch, and Route 53.

### `blnk-azure`
It will contain the Terraform module for setting up the Blnk-Finance application stack on Azure, including resources for Virtual Machines, Azure Database for PostgreSQL, Azure Cache for Redis, Load Balancer, Network Security Groups, Azure Monitor, and Azure DNS.

### `blnk-gcp`
It will contain the Terraform module for setting up the Blnk-Finance application stack on Google Cloud Platform, including resources for Compute Engine, Cloud SQL, Cloud Memorystore, Cloud Load Balancing, Firewall Rules, Google Cloud Monitoring, and Cloud DNS.

### `kubernetes`
It will contain Kubernetes manifests and Helm charts for deploying the Blnk-Finance application stack on a Kubernetes cluster, including deployments, services, ingress, configmaps, secrets, and Helm charts.

### `Scripts`
Contains helpful script to deploy your blnk-finance application

### `Ansible`
It will Contains helpful ansible deployment playbook  to deploy your blnk-finance application

### `README.md`
Provides an overview and instructions for using the Terraform modules to deploy the Blnk-Finance application stack on various cloud platforms.




#
This is an entirely open source blnk-finance infrastructure repository and is maintained by Bolatito Kabir - iamtito, to contribute fork this repo, and submit a pull request. Thank you.