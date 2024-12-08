locals {
  name                   = "${var.name}-${lookup(var.configuration, "name", "")}"
  namespace              = "default"
  additional_helm_values = lookup(var.configuration, "values", {})
  helm_values = {
    controller = {
      service = {
        annotations = {
          "service.beta.kubernetes.io/aws-load-balancer-backend-protocol"                  = "tcp"
          "service.beta.kubernetes.io/aws-load-balancer-connection-idle-timeout"           = "60"
          "service.beta.kubernetes.io/aws-load-balancer-ssl-ports"                         = "443"
          "service.beta.kubernetes.io/aws-load-balancer-nlb-target-type"                   = "ip"
          "service.beta.kubernetes.io/aws-load-balancer-type"                              = "nlb"
          "service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled" = "true"
          "service.beta.kubernetes.io/aws-load-balancer-type"                              = "external"
          "service.beta.kubernetes.io/aws-load-balancer-name"                              = local.name
          "service.beta.kubernetes.io/aws-load-balancer-scheme"                            = "internet-facing"
        }
        config = {
          entries = {
            proxy-protocol             = true
            real-ip-header             = "proxy_protocol"
            set-real-ip-from           = "0.0.0.0/0"
            use-forwarded-headers      = true
            compute-full-forwarded-for = true
          }
        }
      }
      enableSnippets = true
    }
  }
}

resource "helm_release" "nginx-ingress" {
  repository      = "oci://ghcr.io/nginxinc/charts"
  chart           = "nginx-ingress"
  version         = "1.4.2"
  name            = "nginx-ingress"
  namespace       = local.namespace
  values          = [yamlencode(local.helm_values), yamlencode(local.additional_helm_values)]
  cleanup_on_fail = true
  wait            = true
}

data "kubernetes_service_v1" "nginx-ingress" {
  depends_on = [helm_release.nginx-ingress]
  metadata {
    name = "nginx-ingress-controller"
    namespace = local.namespace
  }
}