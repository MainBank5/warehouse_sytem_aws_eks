variable "enterprise_stock_system" {
  description = "Name of the application."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the EKS IAM OIDC provider."
  type        = string
}

variable "oidc_issuer_url" {
  description = "OIDC issuer URL exposed by the EKS cluster."
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace containing the workload."
  type        = string
  default     = "enterprise-stock-system"
}

variable "service_account_name" {
  description = "Kubernetes ServiceAccount allowed to assume the IAM role."
  type        = string
  default     = "email-service"
}