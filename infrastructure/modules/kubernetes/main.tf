module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.31.0"
  cluster_name    = var.name
  vpc_id          = var.network_details.vpc_id
  subnet_ids      = var.network_details.private_subnets
  cluster_version = "1.31"

  create_iam_role                          = true
  create_cluster_security_group            = true
  cluster_endpoint_private_access          = true
  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_group_defaults = {
    ami_type       = "AL2023_x86_64_STANDARD"
    instance_types = [lookup(var.kubernetes, "default_instance", "t3.medium")]
  }

  cluster_addons = { for key, value in lookup(var.kubernetes, "addons", {}) : key => value }

  eks_managed_node_groups = { for key, value in lookup(var.kubernetes, "eks_managed_node_groups", {}) : key => merge(value, {
    tags = {
      "k8s.io/cluster-autoscaler/enabled" : "true",
      "k8s.io/cluster-autoscaler/${var.name}" : "owned"
    }
    })
  }
  self_managed_node_group_defaults = {
    ami_type       = "AL2023_x86_64_STANDARD"
    instance_types = [lookup(var.kubernetes, "default_instance", "t3.medium")]
  }
  self_managed_node_groups = { for key, value in lookup(var.kubernetes, "self_managed_node_groups", {}) : key => merge(value, {
    tags = {
      "k8s.io/cluster-autoscaler/enabled" : "true",
      "k8s.io/cluster-autoscaler/${var.name}" : "owned"
    }
  }) }
  create_cloudwatch_log_group = false
}