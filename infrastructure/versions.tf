terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.80.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.34.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.16.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.3"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.3.5"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.6"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.12.1"
    }
  }
}