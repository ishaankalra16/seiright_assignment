locals {
  helm_metadata = jsondecode(helm_release.service.metadata[0].values)
  containers    = local.helm_metadata.spec.containers
}

output "attributes" {
  value = {
    host = "${local.helm_metadata.name}.${local.namespace}.svc.cluster.local"
    port = "${local.containers.servicePort}"
    name = local.helm_metadata.name
  }
}