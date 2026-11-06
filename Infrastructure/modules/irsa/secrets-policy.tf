data "aws_iam_policy_document" "resend_smtp_secret" {
  statement {
    sid       = "ReadResendSmtpSecret"
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [var.secret_arn]
  }
}

resource "aws_iam_policy" "resend_smtp_secret" {
  name        = "${var.enterprise_stock_system}-resend-smtp-secret-read"
  description = "Allow email-service to read its Resend SMTP configuration"

  policy = data.aws_iam_policy_document.resend_smtp_secret.json

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "email_service_resend_smtp" {
  role       = aws_iam_role.email_service.name #automatically referenced from irsa/main.tf where the role is created. 
  policy_arn = aws_iam_policy.resend_smtp_secret.arn
}