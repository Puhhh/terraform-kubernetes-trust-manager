resource "helm_release" "trust-manager" {
  create_namespace = var.trust-manager-namespace == "cert-manager" ? false : true
  namespace        = var.trust-manager-namespace
  name             = var.helm-name
  chart            = var.helm-chart-name
  repository       = var.helm-chart-repo
  version          = var.helm-chart-version

  values = var.helm-custom-values ? [file(var.helm-custom-values-path)] : []
}

resource "kubernetes_manifest" "selfsigned-issuer" {
  count = var.selfsigned-issuer == true ? 1 : 0

  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "ClusterIssuer"
    "metadata" = {
      "name" = "selfsigned-issuer"
    }
    "spec" = {
      "selfSigned" = {}
    }
  }
}

resource "kubernetes_manifest" "selfsigned-ca" {
  count = var.selfsigned-issuer == true ? 1 : 0

  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "Certificate"
    "metadata" = {
      "name"      = "selfsigned-ca"
      "namespace" = helm_release.trust-manager.namespace
    }
    "spec" = {
      "commonName" = "selfsigned-ca"
      "isCA"       = true
      "issuerRef" = {
        "group" = "cert-manager.io"
        "kind"  = "ClusterIssuer"
        "name"  = "selfsigned-issuer"
      }
      "privateKey" = {
        "algorithm" = "ECDSA"
        "size"      = 256
      }
      "secretName" = "selfsigned-secret"
      "subject" = {
        "organizations" = [
          "kubernetes",
        ]
      }
    }
  }
}

resource "kubernetes_manifest" "ca-issuer" {
  count = var.selfsigned-issuer == true ? 1 : 0

  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "ClusterIssuer"
    "metadata" = {
      "name" = "ca-issuer"
    }
    "spec" = {
      "ca" = {
        "secretName" = "selfsigned-secret"
      }
    }
  }
}

resource "kubectl_manifest" "selfsigned-ca-bundle" {
  depends_on = [helm_release.trust-manager, kubernetes_manifest.selfsigned-ca]

  count = var.selfsigned-issuer == true ? 1 : 0

  yaml_body = <<YAML
  apiVersion: trust.cert-manager.io/v1alpha1
  kind: Bundle
  metadata:
    name: selfsigned-ca-bundle
  spec:
    sources:
      - useDefaultCAs: false
      - secret:
          name: "selfsigned-secret"
          key: "tls.crt"
    target:
      configMap:
        key: "selfsigned-ca-bundle.pem"
  YAML
}


resource "kubectl_manifest" "custom-bundle" {
  depends_on = [helm_release.trust-manager]

  count = var.custom-bundle == true ? 1 : 0

  yaml_body = <<YAML
  apiVersion: trust.cert-manager.io/v1alpha1
  kind: Bundle
  metadata:
    name: ${var.custom-bundle-name} 
  spec:
    sources:
      - useDefaultCAs: false
      - inLine: |
          ${indent(10, var.pem-certificate)}
    target:
      configMap:
        key: "${var.custom-bundle-name}.pem"
  YAML
}
