locals {
  oidc_issuer = trimprefix(var.oidc_issuer_url, "https://")
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_issuer}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_issuer}:sub"
      values = [
        "system:serviceaccount:${var.namespace}:${var.service_account_name}"
      ]
    }
  }
}

resource "aws_iam_role" "email_service" {
  name               = "${var.enterprise_stock_system}-email-service-irsa-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = {
    Name        = "${var.enterprise_stock_system}-email-service-irsa-role"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

