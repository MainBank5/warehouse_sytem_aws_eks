variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster."
  type        = string
}

variable "cluster_role_arn" {
  description = "ARN of the IAM role used by the EKS control plane."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the EKS cluster will run."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs used by the EKS cluster."
  type        = list(string)
}

variable "enterprise_stock_system" {
  description = "Name used to identify project resources."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}


variable "node_role_arn" {
  description = "ARN of the IAM role used by EKS worker nodes."
  type        = string
}

variable "node_group_name" {
  description = "Name of the EKS managed node group."
  type        = string
}

variable "node_instance_types" {
  description = "EC2 instance types used by the node group."
  type        = list(string)
}

variable "node_desired_size" {
  description = "Desired number of worker nodes."
  type        = number
}

variable "node_min_size" {
  description = "Minimum number of worker nodes."
  type        = number
}

variable "node_max_size" {
  description = "Maximum number of worker nodes."
  type        = number
}

variable "developer_role_arn" {
  description = "IAM role ARN granted access to the EKS cluster."
  type        = string
}