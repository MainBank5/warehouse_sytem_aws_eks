output "email_service_role_arn" {
  description = "IAM role ARN for the email service Pod Identity."
  value       = aws_iam_role.email_service.arn
}

output "email_service_policy_arn" {
  description = "IAM policy ARN granting access to the Resend SMTP secret."
  value       = aws_iam_policy.secret_access.arn
}
