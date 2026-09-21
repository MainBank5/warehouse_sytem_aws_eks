variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "enterprise_stock_system" {
  description = "Name used to identify project resources."
  type        = string
}

variable "environment" {
  description = "Deployment environment for VPC resources."
  type        = string
}

variable "availability_zones" {
  description = "Availability zones where VPC subnets will be created."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets."
  type        = list(string)
}