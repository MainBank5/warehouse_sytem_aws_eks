output "cluster_name" {
  description = "Name of the EKS cluster."
  value       = aws_eks_cluster.main_cluster.name
}

output "cluster_arn" {
  description = "ARN of the EKS cluster."
  value       = aws_eks_cluster.main_cluster.arn
}

output "cluster_endpoint" {
  description = "Endpoint of the Kubernetes API server."
  value       = aws_eks_cluster.main_cluster.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Certificate authority data for the Kubernetes API server."
  value       = aws_eks_cluster.main_cluster.certificate_authority[0].data
}

output "cluster_oidc_issuer_url" {
  description = "OIDC issuer URL for the EKS cluster."
  value       = aws_eks_cluster.main_cluster.identity[0].oidc[0].issuer
}

output "pod_identity_agent_addon_id" {
  description = "ID of the EKS Pod Identity Agent add-on."
  value       = aws_eks_addon.pod_identity_agent.id
}