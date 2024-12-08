locals {
  name      = "${var.name}-cert-mgr"
  namespace = "cert-manager"
  helm_values = {
    installCRDs  = true
    nodeSelector = {}
    tolerations  = []
    replicaCount = 2
    webhook = {
      nodeSelector = {}
      tolerations  = []
      replicaCount = 3
    }
    cainjector = {
      nodeSelector = {}
      tolerations  = []
    }
    startupapicheck = {
      nodeSelector = {}
      tolerations  = []
    }
  }
  additional_helm_values = lookup(var.configuration, "values", {})
  http_validations = {
    staging-http01 = {
      name = "letsencrypt-staging-http01"
      url  = "https://acme-staging-v02.api.letsencrypt.org/directory"
      solvers = [
        {
          http01 = {
            ingress = {
              podTemplate = {
                spec = {
                  nodeSelector = {}
                  tolerations  = []
                }
              }
            }
          }
        },
      ]
    }
    production-http01 = {
      name = "letsencrypt-prod-http01"
      url  = "https://acme-v02.api.letsencrypt.org/directory"
      solvers = [
        {
          http01 = {
            ingress = {
              podTemplate = {
                spec = {
                  nodeSelector = {}
                  tolerations  = []
                }
              }
            }
          }
        },
      ]
    }
  }
  resources = { for key, value in local.http_validations :
    key => {
      apiVersion = "cert-manager.io/v1"
      kind       = "ClusterIssuer"
      metadata = {
        name = value.name
      }
      spec = {
        acme = {
          email  = "ishaankalra16@hotmail.com"
          server = value.url
          privateKeySecretRef = {
            name = "letsencrypt-${key}-account-key"
          }
          solvers = value.solvers
        }
      }
    }
  }
}