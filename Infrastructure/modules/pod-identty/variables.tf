variable "enterprise_stock_system" {
  description = "Project name used to name AWS resources."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster receiving the Pod Identity association."
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace for the workload."
  type        = string
  default     = "enterprise-stock-system"
}

variable "service_account_name" {
  description = "ServiceAccount that will use the Pod Identity role."
  type        = string
  default     = "email-service-pod-identity"
}

variable "secret_arn" {
  description = "ARN of the secret this workload may read."
  type        = string
}