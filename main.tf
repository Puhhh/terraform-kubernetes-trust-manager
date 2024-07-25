terraform {
  required_version = ">= 0.13"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
    }

    helm = {
      source = "hashicorp/helm"
    }
  }

  backend "s3" {
    bucket = "terraform-kubernetes-puhhh-s3"
    key    = "test/trust-manager/terraform.tfstate"
    region = "eu-north-1"
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig-path
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig-path
  }
}
