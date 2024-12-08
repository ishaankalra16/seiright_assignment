module "network" {
  source  = "./modules/network"
  name    = local.name
  network = local.network
}

module "kubernetes" {
  source          = "./modules/kubernetes"
  name            = local.name
  kubernetes      = local.kubernetes
  network_details = module.network.network_details
}

module "cluster-autoscaler" {
  depends_on         = [module.kubernetes]
  source             = "./modules/cluster-autoscaler"
  name               = local.name
  kubernetes_details = module.kubernetes.kubernetes_details
  network_details    = module.network.network_details
  configuration      = local.cluster-autoscaler
}

module "aws-lb-controller" {
  depends_on         = [module.kubernetes]
  source             = "./modules/aws-lb-controller"
  name               = local.name
  kubernetes_details = module.kubernetes.kubernetes_details
  network_details    = module.network.network_details
  configuration      = local.aws-lb-controller
}

module "cert-manager" {
  depends_on    = [module.kubernetes]
  source        = "./modules/cert-manager"
  name          = local.name
  configuration = local.cert-manager
}

module "postgres" {
  depends_on    = [module.kubernetes]
  source        = "./modules/postgres"
  name          = local.name
  configuration = local.postgres
}

module "rabbitmq" {
  depends_on    = [module.kubernetes]
  source        = "./modules/rabbitmq"
  name          = local.name
  configuration = local.rabbitmq
}

module "backend_service" {
  depends_on    = [module.kubernetes]
  source        = "./modules/service"
  name          = local.backend_service.name
  configuration = local.backend_service
}

module "frontend_service" {
  depends_on      = [module.kubernetes]
  source          = "./modules/service"
  name            = local.frontend_service.name
  configuration   = local.frontend_service
}

module "nginx-ingress" {
  depends_on         = [module.kubernetes, module.network, module.aws-lb-controller]
  source             = "./modules/nginx-ingress"
  configuration      = local.nginx-ingress
  network_details    = module.network.network_details
  kubernetes_details = module.kubernetes.kubernetes_details
  name               = local.name
}