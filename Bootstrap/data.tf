#prevent requests made over unencrypted HTTP policy
data "aws_iam_policy_document" "terraform_state_https" {
  statement {
    sid    = "DenyInsecureTransport"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["s3:*"]

    resources = [
      aws_s3_bucket.terraform_state_bucket.arn,
      "${aws_s3_bucket.terraform_state_bucket.arn}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}


#access from another account 
data "aws_iam_policy_document" "team_cross_account_access" {
  statement {
    sid    = "AllowTeamStateAccess"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::123456789012:role/TerraformTeamRole"
      ]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      "${aws_s3_bucket.terraform_state_bucket.arn}/*"
    ]
  }

  statement {
    sid    = "AllowTeamListBucket"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::123456789012:role/TerraformTeamRole"
      ]
    }

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.terraform_state_bucket.arn
    ]
  }
}

#combined state access
data "aws_iam_policy_document" "terraform_state_combined" {
  source_policy_documents = [
    data.aws_iam_policy_document.terraform_state_https.json,
    data.aws_iam_policy_document.team_cross_account_access.json
  ]
}