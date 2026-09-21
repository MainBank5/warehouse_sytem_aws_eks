variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "enterprise_stock_system" {
  description = "Name used to identify project resources."
  type        = string
  default     = "enterprise-stock-system"
}

variable "environment" {
  description = "Deployment environment for VPC resources."
  type        = string
}