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
}

provider "kubernetes" {
  config_path    = var.kubeconfig-path
  config_context = var.kube-context
}

provider "helm" {
  kubernetes {
    config_path    = var.kubeconfig-path
    config_context = var.kube-context
  }
}
