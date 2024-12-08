locals {
  sa_name = "${var.name}-terraform"
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

resource "kubernetes_service_account_v1" "this" {
  metadata {
    name = local.sa_name
  }
}

resource "kubernetes_cluster_role_binding_v1" "this" {
  metadata {
    name = local.sa_name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.this.metadata[0].name
    namespace = "default"
  }
}

resource "kubernetes_secret_v1" "this" {
  metadata {
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account_v1.this.metadata[0].name
    }
    name = local.sa_name
  }
  type                           = "kubernetes.io/service-account-token"
  wait_for_service_account_token = true
}