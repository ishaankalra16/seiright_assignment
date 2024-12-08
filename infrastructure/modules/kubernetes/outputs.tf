output "kubernetes_details" {
  value = {
    host                               = module.eks.cluster_endpoint
    cluster_certificate_authority_data = base64decode(module.eks.cluster_certificate_authority_data)
    token                              = kubernetes_secret_v1.this.data["token"]
    id                                 = module.eks.cluster_name
    aws = {
      oidc_provider_arn = module.eks.oidc_provider_arn
    }
  }
}