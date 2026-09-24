resource "aws_eks_cluster" "main_cluster" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids = var.private_subnet_ids

    endpoint_private_access = true
    endpoint_public_access  = true
  }

  tags = {
    Name        = var.cluster_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = var.enterprise_stock_system
  }
}

resource "aws_eks_node_group" "main_node_group" {
  cluster_name    = aws_eks_cluster.main_cluster.name
  node_group_name = var.node_group_name
  node_role_arn   = var.node_role_arn

  subnet_ids = var.private_subnet_ids

  instance_types = var.node_instance_types
  capacity_type  = "ON_DEMAND"

  scaling_config {
    desired_size = var.node_desired_size
    min_size     = var.node_min_size
    max_size     = var.node_max_size
  }

  update_config {
    max_unavailable = 1
  }

  tags = {
    Name        = var.node_group_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = var.enterprise_stock_system
  }

  depends_on = [
    aws_eks_cluster.main_cluster
  ]
}


#resource "aws_eks_addon" "vpc_cni" {
  #cluster_name  = aws_eks_cluster.main_cluster.name
  #addon_name    = "vpc-cni"
  #addon_version = "v1.20.4-eksbuild.2" #There is already a self-managed VPC CNI installation. If there are conflicting settings, overwrite them with the managed add-on configuration.

  #resolve_conflicts_on_create = "OVERWRITE"

  #tags = {
    #Name        = "${var.cluster_name}-vpc-cni"
    #Environment = var.environment
    #ManagedBy   = "Terraform"
    #Project     = var.enterprise_stock_system
  #}

  #depends_on = [
    #aws_eks_node_group.main_node_group
  #]
#}

#resource "aws_eks_addon" "coredns" {
  #cluster_name  = aws_eks_cluster.main_cluster.name
  #addon_name    = "coredns"
  #addon_version = "v1.14.3-eksbuild.16"

  #resolve_conflicts_on_create = "OVERWRITE"

  #tags = {
    #Name        = "${var.cluster_name}-coredns"
    #Environment = var.environment
    #ManagedBy   = "Terraform"
    #Project     = var.enterprise_stock_system
  #}

  #depends_on = [
   # aws_eks_node_group.main_node_group
  #]
#}

#resource "aws_eks_addon" "kube_proxy" {
  #cluster_name  = aws_eks_cluster.main_cluster.name
  #addon_name    = "kube-proxy"
  #addon_version = "v1.36.0-eksbuild.21"

  #resolve_conflicts_on_create = "OVERWRITE"

  #tags = {
    #Name        = "${var.cluster_name}-kube-proxy"
    #Environment = var.environment
    #ManagedBy   = "Terraform"
    #Project     = var.enterprise_stock_system
  #}

  #depends_on = [
   # aws_eks_node_group.main_node_group
  #]
#}