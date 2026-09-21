
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr                = var.vpc_cidr
  enterprise_stock_system = var.enterprise_stock_system
  environment             = var.environment
}