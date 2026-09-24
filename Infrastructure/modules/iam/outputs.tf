output "eks_cluster_role_arn" {
  description = "ARN of the IAM role used by the EKS cluster."
  value       = aws_iam_role.eks_cluster.arn
}

output "eks_node_role_arn" {
  description = "ARN of the IAM role used by EKS worker nodes."
  value       = aws_iam_role.eks_node.arn
}