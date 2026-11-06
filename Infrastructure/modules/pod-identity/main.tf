data "aws_iam_policy_document" "assume_role" {
  statement {
    sid    = "AllowEksPodIdentity"
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes-namespace"
      values   = [var.namespace]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes-service-account"
      values   = [var.service_account_name]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/eks-cluster-name"
      values   = [var.cluster_name]
    }
  }
}

resource "aws_iam_role" "email_service" {
  name               = "${var.enterprise_stock_system}-email-service-pod-identity-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = {
    Name        = "${var.enterprise_stock_system}-email-service-pod-identity-role"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

data "aws_iam_policy_document" "secret_access" {
  statement {
    sid       = "ReadResendSmtpSecret"
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [var.secret_arn]
  }
}

resource "aws_iam_policy" "secret_access" {
  name        = "${var.enterprise_stock_system}-resend-smtp-pod-identity-read"
  description = "Allow the email service to read its Resend SMTP secret"

  policy = data.aws_iam_policy_document.secret_access.json

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "secret_access" {
  role       = aws_iam_role.email_service.name
  policy_arn = aws_iam_policy.secret_access.arn
}