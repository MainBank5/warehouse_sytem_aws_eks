variable "aws_region" {
  description = "AWS region where infrastructure resources will be deployed."
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "enterprise_stock_system" {
  description = "Name used to identify project resources."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "production"
}
