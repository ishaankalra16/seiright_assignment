locals {
  namespace              = "default"
  additional_helm_values = lookup(var.configuration, "values", {})
  helm_values = {
    name = var.name
    spec = {
      namespace   = local.namespace
      replicas    = 1
      minReplicas = 1
      maxReplicas = 2
    }
  }
}

resource "helm_release" "service" {
  chart           = "${path.module}/service"
  name            = var.name
  namespace       = local.namespace
  values          = [yamlencode(local.helm_values), yamlencode(local.additional_helm_values)]
  cleanup_on_fail = true
  wait            = true
}