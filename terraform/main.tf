locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

module "vpc" {
  source = "./modules/vpc"

  project_name             = var.project_name
  environment              = var.environment
  vpc_cidr                 = var.vpc_cidr
  availability_zones       = var.availability_zones
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_app_subnet_cidrs = var.private_app_subnet_cidrs
  private_db_subnet_cidrs  = var.private_db_subnet_cidrs
}

module "security_groups" {
  source = "./modules/security-groups"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
}

module "alb" {
  source = "./modules/alb"

  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.security_groups.alb_sg_id
}

module "rds" {
  source = "./modules/rds"

  project_name          = var.project_name
  environment           = var.environment
  private_db_subnet_ids = module.vpc.private_db_subnet_ids
  rds_sg_id             = module.security_groups.rds_sg_id
  db_instance_class     = var.db_instance_class
  db_name               = var.db_name
  db_username           = var.db_username
  db_password           = var.db_password
}

module "ec2" {
  source = "./modules/ec2"

  project_name           = var.project_name
  environment            = var.environment
  private_app_subnet_ids = module.vpc.private_app_subnet_ids
  app_sg_id              = module.security_groups.app_sg_id
  target_group_arn       = module.alb.target_group_arn
  instance_type          = var.instance_type
  asg_min_size           = var.asg_min_size
  asg_max_size           = var.asg_max_size
  asg_desired_capacity   = var.asg_desired_capacity
  db_host                = module.rds.db_host
  db_name                = var.db_name
  db_username            = var.db_username
  db_password            = var.db_password
}

module "cloudwatch" {
  source = "./modules/cloudwatch"

  project_name         = var.project_name
  environment          = var.environment
  asg_name             = module.ec2.asg_name
  alb_arn              = module.alb.alb_arn
  target_group_arn     = module.alb.target_group_arn
  scale_out_policy_arn = module.ec2.scale_out_policy_arn
  scale_in_policy_arn  = module.ec2.scale_in_policy_arn
  alert_email          = var.alert_email
}