# NovaMart AWS — Production-Grade 3-Tier Architecture

A fully automated, highly available 3-tier web application infrastructure on AWS, built with Terraform. Deployed and verified live in ap-south-1 (Mumbai).

---

## The Problem This Solves

Imagine you run an online store called NovaMart. Your website is getting popular and you're worried about a few things:

**Problem 1 — What if your server crashes?**
If your website runs on a single server and that server goes down, your entire store is offline. Every minute of downtime means lost sales and unhappy customers.

**Problem 2 — What if too many people visit at once?**
If 10 people visit your site normally but suddenly 10,000 people show up during a sale, your single server will get overwhelmed and the site will become slow or crash.

**Problem 3 — What if someone hacks your database?**
If your database is directly connected to the internet, attackers can try to break in and steal customer data, orders, and passwords.

**Problem 4 — Setting up servers manually takes forever**
Clicking through dashboards to set up servers one by one takes days, is error-prone, and impossible to repeat exactly. If you need to set up a second environment (like staging or production), you have to do everything again from scratch.

---

## How This Project Solves It

**Solution 1 — No single point of failure**
Instead of one server, we run multiple servers across two separate AWS data centers (Availability Zones). If one entire data center goes down, the other one keeps the website running. Users never notice anything went wrong.

**Solution 2 — Automatic scaling**
We set up an Auto Scaling Group that watches CPU usage. If traffic spikes and servers get busy (above 70% CPU), AWS automatically adds more servers within minutes. When traffic drops (below 20% CPU), it removes the extra servers so you don't pay for what you don't need.

**Solution 3 — Three separate layers with strict security**
- The **Load Balancer** is the only thing that faces the internet — it receives all incoming traffic
- The **App Servers** only accept traffic from the Load Balancer — nothing else can reach them
- The **Database** only accepts traffic from the App Servers — it is completely hidden from the internet

Even if someone broke through the Load Balancer, they still cannot reach the database directly. This is called Defence in Depth.

**Solution 4 — Everything is code**
The entire infrastructure — every server, every network rule, every alarm — is written as Terraform code. To deploy the whole system you run one command. To tear it all down you run one command. To set up an identical staging environment, you change one variable. No clicking, no forgetting steps, no human error.

**The result:** A website that stays online even when servers fail, handles traffic spikes automatically, keeps customer data protected, and can be rebuilt from scratch in under 15 minutes.

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
