output "network_details" {
  value = {
    vpc_id                 = module.vpc.vpc_id
    private_subnets        = module.vpc.private_subnets
    private_subnet_objects = module.vpc.private_subnet_objects
    cidr                   = module.vpc.vpc_cidr_block
    public_subnets         = module.vpc.public_subnets
    public_subnet_objects  = module.vpc.public_subnet_objects
    azs                    = module.vpc.azs
    region                 = var.network.region
    nat_public_ips         = module.vpc.nat_public_ips
  }
}