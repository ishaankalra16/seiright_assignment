locals {
  cidr            = lookup(var.network, "cidr", "10.0.0.0/16")
  private_subnets = [cidrsubnet(local.cidr, 4, 0), cidrsubnet(local.cidr, 4, 1), cidrsubnet(local.cidr, 4, 2)]
  public_subnets  = [cidrsubnet(local.cidr, 4, 3), cidrsubnet(local.cidr, 4, 4), cidrsubnet(local.cidr, 4, 5)]
}

module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "5.16.0"
  cidr                 = local.cidr
  name                 = var.name
  azs                  = var.network.azs
  create_igw           = true
  create_vpc           = true
  enable_dns_hostnames = true
  private_subnets      = local.private_subnets
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
  public_subnets = local.public_subnets
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }
  enable_nat_gateway = true
  single_nat_gateway = true
  tags = {
    Terraform                           = "true",
    "kubernetes.io/cluster/${var.name}" = "owned"
  }
}