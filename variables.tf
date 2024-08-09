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
  default     = "0.11.0"
}

variable "helm-custom-values" {
  description = "Use Helm Custom Values"
  type        = bool
  default     = false
}

variable "helm-custom-values-path" {
  description = "Helm Custom Values Path"
  type        = string
  default     = "values.yaml"
}

variable "selfsigned-clusterissuer" {
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
}

variable "pem-certificate" {
  description = "PEM Certificate"
  type        = string
  default     = ""
}
