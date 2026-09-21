resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.enterprise_stock_system}-vpc"
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}


resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name        = "${var.enterprise_stock_system}-igw"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}