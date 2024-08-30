variable "kubeconfig-path" {
  description = "Kubeconfig Path"
  type        = string
  default     = "~/.kube/config"
}

variable "trust-manager-namespace" {
  description = "Trust Manager Namespace"
  type        = string
  default     = "cert-manager"
}

variable "helm-name" {
  description = "Helm Release Name"
  type        = string
  default     = "trust-manager"
}

variable "helm-chart-name" {
  description = "Helm Chart Name"
  type        = string
  default     = "trust-manager"
}

variable "helm-chart-repo" {
  description = "Helm Chart Repo"
  type        = string
  default     = "https://charts.jetstack.io/"
}

variable "helm-chart-version" {
  description = "Helm Chart Version"
  type        = string
  default     = "0.12.0"
}

variable "helm-custom-values" {
  description = "Use Helm Custom Values"
  type        = bool
  default     = false
}

variable "helm-custom-values-path" {
  description = "Helm Custom Values Path"
  type        = string
  default     = ""

  validation {
    condition     = !(var.helm-custom-values && var.helm-custom-values-path == "")
    error_message = "helm-custom-values-path must not be null when helm-custom-values is true."
  }
}

variable "selfsigned-issuer" {
  description = "Use Selfsigned Clusterissuer with Random Generate CA"
  type        = bool
  default     = false
}

variable "custom-bundle" {
  description = "Install Custom Bundle"
  type        = bool
  default     = false
}

variable "custom-bundle-name" {
  description = "Custom Bundle Name"
  type        = string
  default     = ""

  validation {
    condition     = !(var.custom-bundle && var.custom-bundle-name == "")
    error_message = "custom-bundle-name not be null when custom-bundle is true."
  }
}

variable "pem-certificate" {
  description = "PEM Certificate"
  type        = string
  default     = ""

  validation {
    condition     = !(var.custom-bundle && var.pem-certificate == "")
    error_message = "pem-certificate not be null when custom-bundle is true."
  }
}
