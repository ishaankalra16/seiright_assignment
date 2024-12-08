locals {
  additional_helm_values = lookup(var.configuration, "values", {})
  helm_values = {
    autoDiscovery = {
      clusterName = var.kubernetes_details.id
    }
    rbac = {
      create = true
      serviceAccount = {
        annotations = {
          "eks.amazonaws.com/role-arn" = module.irsa.iam_role_arn
        }
      }
    }
    tolerations = []
  }
  service_account_name = "cluster-autoscaler-aws-cluster-autoscaler"
  namespace            = "kube-system"
}

resource "helm_release" "cluster-autoscaler" {
  name            = "cluster-autoscaler"
  repository      = "https://kubernetes.github.io/autoscaler"
  chart           = "cluster-autoscaler"
  version         = "9.43.2"
  cleanup_on_fail = true
  namespace       = local.namespace

  set {
    name  = "awsRegion"
    value = var.network_details.region
  }

  values = [yamlencode(local.helm_values), yamlencode(local.additional_helm_values)]
}

module "irsa" {
  source                           = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                          = "5.48.0"
  role_name                        = "${var.name}-cluster-autoscaler"
  attach_cluster_autoscaler_policy = true
  cluster_autoscaler_cluster_names = [var.kubernetes_details.id]
  oidc_providers = {
    one = {
      provider_arn               = var.kubernetes_details.aws.oidc_provider_arn
      namespace_service_accounts = ["${local.namespace}:${local.service_account_name}"]
    }
  }
}