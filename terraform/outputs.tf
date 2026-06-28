output "alb_dns_name" {
  description = "DNS name of the ALB — open this in your browser to access the app."
  value       = module.alb.alb_dns_name
}

output "vpc_id" {
  description = "ID of the created VPC."
  value       = module.vpc.vpc_id
}

output "rds_endpoint" {
  description = "RDS connection endpoint."
  value       = module.rds.db_endpoint
  sensitive   = true
}

output "cloudwatch_dashboard" {
  description = "Name of the CloudWatch dashboard."
  value       = module.cloudwatch.dashboard_name
}

output "asg_name" {
  description = "Name of the Auto Scaling Group."
  value       = module.ec2.asg_name
}