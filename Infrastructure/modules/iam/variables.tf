variable "enterprise_stock_system" {
  description = "Name used to identify project resources."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID used by IAM trust policies."
  type        = string
}