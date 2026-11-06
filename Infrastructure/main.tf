
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
  aws_account_id          = data.aws_caller_identity.current.account_id
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
  developer_role_arn      = module.iam.eks_developer_role_arn

  depends_on = [module.iam]
}

resource "aws_iam_openid_connect_provider" "eks" {
  url = module.eks.cluster_oidc_issuer_url

  client_id_list = [
    "sts.amazonaws.com"
  ]

  tags = {
    Name        = "${var.enterprise_stock_system}-eks-oidc-provider"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}


module "irsa" {
  source = "./modules/irsa"

  enterprise_stock_system = var.enterprise_stock_system
  environment             = var.environment

  oidc_provider_arn = aws_iam_openid_connect_provider.eks.arn
  oidc_issuer_url   = module.eks.cluster_oidc_issuer_url

  namespace            = "enterprise-stock-system"
  service_account_name = "email-service"

  secret_arn = data.aws_secretsmanager_secret.resend_smtp.arn
}

module "pod_identity" {
  source = "./modules/pod-identity"

  enterprise_stock_system = var.enterprise_stock_system
  environment             = var.environment

  cluster_name = module.eks.cluster_name

  namespace            = "enterprise-stock-system"
  service_account_name = "email-service-pod-identity"

  secret_arn = data.aws_secretsmanager_secret.resend_smtp.arn
}

resource "aws_eks_pod_identity_association" "email_service" {
  cluster_name    = module.eks.cluster_name
  namespace       = "enterprise-stock-system"
  service_account = "email-service-pod-identity"
  role_arn        = module.pod_identity.email_service_role_arn

  depends_on = [
    module.eks.pod_identity_agent_addon_id,
    module.pod_identity
  ]
}