locals {
  records = toset(distinct([for key, value in lookup(var.configuration, "rules", {}): value.domain_prefix]))
  hosted_zone_domain = lookup(var.configuration, "hosted_zone_domain", "")
  loadbalancer_endpoint = data.kubernetes_service_v1.nginx-ingress.status.0.load_balancer.0.ingress.0.hostname
}

data "aws_route53_zone" "zone" {
  name = local.hosted_zone_domain
}

resource "aws_route53_record" "record" {
  for_each = local.records
  name = "${each.key}.${local.hosted_zone_domain}"
  zone_id = data.aws_route53_zone.zone.id
  type = "CNAME"
  ttl = "300"
  records = [local.loadbalancer_endpoint]
}