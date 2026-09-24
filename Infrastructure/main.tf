
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr                = var.vpc_cidr
  enterprise_stock_system = var.enterprise_stock_system
  environment             = var.environment
  availability_zones      = var.availability_zones
  public_subnet_cidrs     = var.public_subnet_cidrs
  private_subnet_cidrs    = var.private_subnet_cidrs
}



module "iam" {
  source = "./modules/iam"

  enterprise_stock_system = var.enterprise_stock_system
  environment             = var.environment
}

module "eks" {
  source = "./modules/eks"

  cluster_name       = var.cluster_name
  kubernetes_version = var.kubernetes_version

  cluster_role_arn = module.iam.eks_cluster_role_arn
  node_role_arn    = module.iam.eks_node_role_arn

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  node_group_name     = var.node_group_name
  node_instance_types = var.node_instance_types
  node_desired_size   = var.node_desired_size
  node_min_size       = var.node_min_size
  node_max_size       = var.node_max_size

  enterprise_stock_system = var.enterprise_stock_system
  environment             = var.environment

  depends_on = [module.iam]
}


