resource "random_password" "password" {
  length  = var.length
  special = var.special
}