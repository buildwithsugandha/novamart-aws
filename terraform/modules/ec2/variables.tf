variable "project_name" {
  description = "Project name for resource naming."
  type        = string
}

variable "environment" {
  description = "Environment name for resource naming."
  type        = string
}

variable "private_app_subnet_ids" {
  description = "List of private subnet IDs for EC2 instances."
  type        = list(string)
}

variable "app_sg_id" {
  description = "Security group ID for the application servers."
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the ALB target group to register instances with."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
}

variable "asg_min_size" {
  description = "Minimum number of instances in the ASG."
  type        = number
}

variable "asg_max_size" {
  description = "Maximum number of instances in the ASG."
  type        = number
}

variable "asg_desired_capacity" {
  description = "Desired number of instances in the ASG."
  type        = number
}

variable "db_host" {
  description = "RDS endpoint passed to the app via user data."
  type        = string
}

variable "db_name" {
  description = "Database name passed to the app via user data."
  type        = string
}

variable "db_username" {
  description = "Database username passed to the app via user data."
  type        = string
}

variable "db_password" {
  description = "Database password passed to the app via user data."
  type        = string
  sensitive   = true
}