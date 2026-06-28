variable "project_name" {
  description = "Project name for resource naming."
  type        = string
}

variable "environment" {
  description = "Environment name for resource naming."
  type        = string
}

variable "asg_name" {
  description = "Name of the Auto Scaling Group to monitor."
  type        = string
}

variable "alb_arn" {
  description = "ARN of the Application Load Balancer to monitor."
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the ALB target group to monitor."
  type        = string
}

variable "scale_out_policy_arn" {
  description = "ARN of the ASG scale-out policy."
  type        = string
}

variable "scale_in_policy_arn" {
  description = "ARN of the ASG scale-in policy."
  type        = string
}

variable "alert_email" {
  description = "Email address to receive CloudWatch alarm notifications."
  type        = string
}