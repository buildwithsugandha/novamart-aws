output "asg_name" {
  description = "Name of the Auto Scaling Group."
  value       = aws_autoscaling_group.app.name
}

output "scale_out_policy_arn" {
  description = "ARN of the scale-out policy."
  value       = aws_autoscaling_policy.scale_out.arn
}

output "scale_in_policy_arn" {
  description = "ARN of the scale-in policy."
  value       = aws_autoscaling_policy.scale_in.arn
}

output "launch_template_id" {
  description = "ID of the EC2 launch template."
  value       = aws_launch_template.app.id
}