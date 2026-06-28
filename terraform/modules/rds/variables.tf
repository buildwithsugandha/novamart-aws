variable "project_name" {
  description = "Project name for resource naming."
  type        = string
}

variable "environment" {
  description = "Environment name for resource naming."
  type        = string
}

variable "private_db_subnet_ids" {
  description = "List of private subnet IDs for the RDS subnet group."
  type        = list(string)
}

variable "rds_sg_id" {
  description = "Security group ID for the RDS instance."
  type        = string
}

variable "db_instance_class" {
  description = "RDS instance class."
  type        = string
}

variable "db_name" {
  description = "Name of the initial database."
  type        = string
}

variable "db_username" {
  description = "Master username for the database."
  type        = string
}

variable "db_password" {
  description = "Master password for the database."
  type        = string
  sensitive   = true
}