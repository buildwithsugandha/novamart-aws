# NovaMart AWS — Production-Grade 3-Tier Architecture

A fully automated, highly available 3-tier web application infrastructure on AWS, built with Terraform. Deployed and verified live in ap-south-1 (Mumbai).

---

## Architecture Overview

```
Internet
    │
    ▼
[Application Load Balancer]  ← Public Subnets (ap-south-1a, ap-south-1b)
    │
    ▼
[Auto Scaling Group]         ← Private App Subnets (ap-south-1a, ap-south-1b)
[EC2 t3.micro instances]
    │
    ▼
[RDS MySQL 8.0]              ← Private DB Subnets (ap-south-1a, ap-south-1b)
```

---

## What's Built

| Layer | Resource | Details |
|---|---|---|
| Network | VPC | CIDR 10.0.0.0/16, DNS enabled |
| Network | Subnets | 6 subnets across 2 AZs (public, private-app, private-db) |
| Network | Internet Gateway | Public internet access for ALB |
| Network | NAT Gateways | Outbound internet for private app servers |
| Network | Route Tables | Separate tables per subnet tier |
| Security | Security Groups | ALB, App, RDS — least privilege |
| Presentation | Application Load Balancer | Internet-facing, HTTP listener |
| Presentation | Target Group | Health check on /health |
| Application | Launch Template | Amazon Linux 2023, t3.micro |
| Application | Auto Scaling Group | Min: 2, Max: 4, Desired: 2 |
| Application | IAM Role | SSM access — no SSH keys needed |
| Application | Scale-out policy | Triggers at 70% CPU |
| Application | Scale-in policy | Triggers at 20% CPU |
| Data | RDS MySQL 8.0 | db.t3.micro, private subnet, encrypted |
| Observability | CloudWatch Alarms | CPU high/low + ALB 5XX errors |
| Observability | CloudWatch Dashboard | CPU, Request Count, 5XX metrics |
| Observability | SNS Topic | Email alerts on alarm state |

**Total: 44 AWS resources provisioned by a single `terraform apply`**

---

## Terraform Module Structure

```
terraform/
├── main.tf                    ← Root — wires all modules together
├── variables.tf               ← Input variable declarations
├── outputs.tf                 ← ALB DNS, VPC ID, ASG name
├── versions.tf                ← Provider + version constraints
├── environments/
│   └── dev/
│       └── terraform.tfvars   ← Dev environment values
└── modules/
    ├── vpc/                   ← VPC, subnets, IGW, NAT, route tables
    ├── security-groups/       ← ALB, app, and RDS security groups
    ├── alb/                   ← Load balancer, target group, listener
    ├── ec2/                   ← Launch template, ASG, IAM, scaling policies
    ├── rds/                   ← MySQL instance and subnet group
    └── cloudwatch/            ← Alarms, dashboard, SNS topic
```

---

## Security Design

- App servers accept traffic **only from the ALB** — not from the internet
- RDS accepts traffic **only from app servers** — not from the ALB or internet
- No SSH ports open anywhere — EC2 access via AWS Systems Manager (SSM)
- All subnets in private tiers have no public IP assignment
- RDS storage encrypted at rest

---

## Prerequisites

- Terraform >= 1.5.0
- AWS CLI configured with appropriate credentials
- AWS account with permissions to create VPC, EC2, RDS, IAM resources

---

## Deploy

```bash
cd terraform

# Initialize
terraform init

# Preview
terraform plan -var-file="environments/dev/terraform.tfvars" -var="db_password=YOUR_PASSWORD"

# Deploy
terraform apply -var-file="environments/dev/terraform.tfvars" -var="db_password=YOUR_PASSWORD"
```

After apply completes, the ALB DNS name is printed as output — open it in a browser to reach the application.

---

## Destroy

```bash
terraform destroy -var-file="environments/dev/terraform.tfvars" -var="db_password=YOUR_PASSWORD"
```

---

## Screenshots

Live infrastructure verified in AWS Console — ap-south-1 (Mumbai):

| Resource | Screenshot |
|---|---|
| VPC | docs/screenshots/novamart-dev-vpc.jpg |
| Load Balancer | docs/screenshots/novamart-dev-alb.jpg |
| Auto Scaling Group | docs/screenshots/novamart-dev-asg.jpg |
| RDS Database | docs/screenshots/novamart-dev-rds-connectivity-and-security.jpg |
| CloudWatch Dashboard | docs/screenshots/novamart-dev-dashboard-cloudwatch.jpg |
| CloudWatch Alarm | docs/screenshots/novamart-dev-cpu-low-alarm.jpg |

---

## Author

**Sugandha Vashishtha** — Cloud & Site Reliability Engineer  
[github.com/buildwithsugandha](https://github.com/buildwithsugandha) · [linkedin.com/in/sugandha-vashishtha](https://linkedin.com/in/sugandha-vashishtha)
