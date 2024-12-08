locals {
  name                   = "rabbitmq-${lookup(var.configuration, "name", "")}"
  namespace              = "default"
  username               = "root"
  additional_helm_values = lookup(var.configuration, "values", {})
  replica_count          = 1
  helm_values = {
    replicaCount = local.replica_count
    auth = {
      username = local.username
      password = module.password.result
    }
    resources = {
      requests = {
        cpu    = "250m"
        memory = "256Mi"
      }
    }
  }
}

module "password" {
  source = "../utility-modules/password"
  length = 16
}

resource "helm_release" "rabbitmq" {
  repository      = "oci://registry-1.docker.io/bitnamicharts"
  chart           = "rabbitmq"
  name            = local.name
  cleanup_on_fail = true
  version         = "15.1.0"
  namespace       = local.namespace
  wait            = true
  values          = [yamlencode(local.helm_values), yamlencode(local.additional_helm_values)]
}