output "db_endpoint" {
  description = "Connection endpoint for the RDS instance."
  value       = aws_db_instance.main.endpoint
}

output "db_host" {
  description = "Hostname of the RDS instance (without port)."
  value       = aws_db_instance.main.address
}

output "db_name" {
  description = "Name of the database."
  value       = aws_db_instance.main.db_name
}

output "db_port" {
  description = "Port the database is listening on."
  value       = aws_db_instance.main.port
}