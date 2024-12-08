resource "kubernetes_ingress_v1" "rule" {
  depends_on = [aws_route53_record.record]
  for_each = lookup(var.configuration, "rules", {})
  metadata {
    name = "${each.key}"
    namespace = local.namespace
    annotations = {
      "cert-manager.io/cluster-issuer" = "letsencrypt-staging-http01"
      "acme.cert-manager.io/http01-edit-in-place" = "true"
      "nginx.org/proxy-set-headers" = "Access-Control-Allow-Origin: *,Access-Control-Allow-Methods: GET, POST, OPTIONS,Access-Control-Allow-Headers: Origin, Authorization, Content-Type, Accept"
    }
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = "${each.value.domain_prefix}.${local.hosted_zone_domain}"
      http {
        path {
          path_type = "Prefix"
          path = each.value.path
          backend {
            service {
              name = each.value.service
              port {
                number = each.value.port
              }
            }
          }
        }
      }
    }
    tls {
      hosts = ["${each.value.domain_prefix}.${local.hosted_zone_domain}"]
      secret_name = "${each.value.domain_prefix}-nginx-ingress"
    }
  }
}