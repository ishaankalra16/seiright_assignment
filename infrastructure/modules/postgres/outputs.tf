output "attributes" {
  value = {
    host              = "${helm_release.postgres.name}-postgresql-writer.${helm_release.postgres.namespace}.svc.cluster.local"
    username          = "postgres"
    password          = module.password.result
    port              = "5432"
    name              = local.name
    connection_string = "jdbc:postgresql://postgres:${module.password.result}@${local.name}-postgresql-writer.${local.namespace}.svc.cluster.local:5432/postgres"
  }
}