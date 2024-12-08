resource "kubernetes_namespace" "namespace" {
  metadata {
    name = local.namespace
  }
}

resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = local.namespace
  create_namespace = false
  version          = "1.16.2"
  cleanup_on_fail  = true
  wait             = true
  values           = [yamlencode(local.helm_values), yamlencode(local.additional_helm_values)]
}

module "cluster-issuers" {
  depends_on = [helm_release.cert_manager]
  source     = "../utility-modules/any-k8s-resource"
  name       = local.name
  namespace  = local.namespace
  resources  = local.resources
}