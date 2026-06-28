output "alb_sg_id" {
  description = "Security group ID for the ALB."
  value       = aws_security_group.alb.id
}

output "app_sg_id" {
  description = "Security group ID for the application servers."
  value       = aws_security_group.app.id
}

output "rds_sg_id" {
  description = "Security group ID for the RDS database."
  value       = aws_security_group.rds.id
}