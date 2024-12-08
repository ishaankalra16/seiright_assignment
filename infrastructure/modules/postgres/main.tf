locals {
  name                   = "postgres-${lookup(var.configuration, "name", "")}"
  namespace              = lookup(var.configuration, "namespace", "default")
  additional_helm_values = lookup(var.configuration, "values", {})
  replica_count          = 0
  helm_values = {
    architecture = "replication"
    auth = {
      postgresPassword    = module.password.result
      replicationPassword = module.password.result
    }
    primary = {
      name = "writer"
      resources = {
        requests = {
          cpu    = "250m"
          memory = "256Mi"
        }
      }
    }
    readReplicas = {
      name         = "reader"
      replicaCount = local.replica_count
      resources = {
        requests = {
          cpu    = "250m"
          memory = "256Mi"
        }
      }
    }
  }
}

module "password" {
  source  = "../utility-modules/password"
  length  = 16
  special = false
}

resource "helm_release" "postgres" {
  repository      = "oci://registry-1.docker.io/bitnamicharts"
  chart           = "postgresql"
  name            = local.name
  cleanup_on_fail = true
  version         = "16.2.5"
  namespace       = "default"
  wait            = true
  values          = [yamlencode(local.helm_values), yamlencode(local.additional_helm_values)]
}