output "attributes" {
  value = {
    endpoint          = "${local.name}.${local.namespace}.svc.cluster.local:5672"
    connection_string = sensitive("amqp://${local.username}:${module.password.result}@${local.name}.${local.namespace}.svc.cluster.local:5672/")
    username          = local.username
    password          = module.password.result
  }
}