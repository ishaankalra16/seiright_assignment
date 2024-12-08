locals {
  namespace              = "kube-system"
  name                   = "aws-alb-ingress-controller"
  additional_helm_values = lookup(var.configuration, "values", {})
  helm_values = {
    serviceMutatorWebhookConfig = {
      failurePolicy = "Ignore"
    }
    clusterName = var.kubernetes_details.id
    rbac = {
      create = true
    }
    serviceAccount = {
      create = true
      name   = local.name
      annotations = {
        "eks.amazonaws.com/role-arn" = module.irsa.iam_role_arn
      }
    }
    tolerations  = []
    nodeSelector = {}
    defaultTags  = {}
  }
}

module "irsa" {
  source                                 = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                                = "5.48.0"
  role_name                              = "${var.name}-lb-controller"
  attach_load_balancer_controller_policy = true

  cluster_autoscaler_cluster_names = [var.kubernetes_details.id]
  oidc_providers = {
    one = {
      provider_arn               = var.kubernetes_details.aws.oidc_provider_arn
      namespace_service_accounts = ["${local.namespace}:${local.name}"]
    }
  }
}

resource "helm_release" "aws_alb_ingress_controller" {
  name       = local.name
  chart      = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  version    = "1.10.0"
  namespace  = local.namespace
  values = [
    yamlencode(local.helm_values),
    yamlencode(local.additional_helm_values)
  ]
}