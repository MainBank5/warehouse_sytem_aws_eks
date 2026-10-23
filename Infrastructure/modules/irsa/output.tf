output "email_service_role_arn" {
  description = "IAM role ARN assumed by the email-service ServiceAccount."
  value       = aws_iam_role.email_service.arn
}