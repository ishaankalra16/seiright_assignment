resource "kubernetes_storage_class_v1" "cap-expandable-storage" {
  metadata {
    name = "default"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }
  storage_provisioner = "kubernetes.io/aws-ebs"
  reclaim_policy      = "Retain"
  parameters = {
    type = "gp2"
    fsType : "ext4"
    encrypted : "true"
  }
  allow_volume_expansion = true
  volume_binding_mode    = "Immediate"
}