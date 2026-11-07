resource "helm_release" "external_secrets" {
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  version    = "2.14.0"

  namespace        = "external-secrets"
  create_namespace = true

  set = [
    {
      name  = "installCRDs"
      value = "true"
    }
  ]
}