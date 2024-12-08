locals {
  helm_values = {
    anyResources = { for key, value in var.resources : key => yamlencode(value) }
  }
}

resource "helm_release" "any-k8s-resources" {
  name             = var.name
  repository       = "https://kiwigrid.github.io"
  chart            = "any-resource"
  cleanup_on_fail  = true
  wait             = true
  version          = "0.1.0"
  create_namespace = true
  namespace        = var.namespace
  values           = [yamlencode(local.helm_values)]
}
