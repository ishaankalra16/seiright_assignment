provider "aws" {
  profile = "default"
  region  = local.network.region
}

provider "kubernetes" {
  host                   = module.kubernetes.kubernetes_details.host
  cluster_ca_certificate = module.kubernetes.kubernetes_details.cluster_certificate_authority_data
  token                  = module.kubernetes.kubernetes_details.token
}

provider "helm" {
  kubernetes {
    host                   = module.kubernetes.kubernetes_details.host
    cluster_ca_certificate = module.kubernetes.kubernetes_details.cluster_certificate_authority_data
    token                  = module.kubernetes.kubernetes_details.token
  }
}