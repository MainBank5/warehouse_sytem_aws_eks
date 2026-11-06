data "aws_caller_identity" "current" {}

data "aws_secretsmanager_secret" "resend_smtp" {
  name = "enterprise-stock-system/resend-smtp"
}