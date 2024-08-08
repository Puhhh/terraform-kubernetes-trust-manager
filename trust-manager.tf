resource "helm_release" "trust-manager" {
  create_namespace = var.trust-manager-namespace == "cert-manager" ? false : true
  namespace        = var.trust-manager-namespace
  name             = var.helm-name
  chart            = var.helm-chart-name
  repository       = var.helm-chart-repo
  version          = var.helm-chart-version

  values = var.helm-custom-values ? [file("${var.helm-custom-values-path}")] : []
}

resource "kubectl_manifest" "selfsigned-clusterissuer" {
  depends_on = [helm_release.trust-manager]

  count = var.selfsigned-clusterissuer == true ? 1 : 0

  yaml_body = <<YAML
  apiVersion: cert-manager.io/v1
  kind: ClusterIssuer
  metadata:
    name: selfsigned-cluster-issuer
  spec:
    selfSigned: {}
  YAML
}

resource "kubectl_manifest" "trust-manager-ca" {
  depends_on = [kubectl_manifest.selfsigned-clusterissuer]

  count = var.selfsigned-clusterissuer == true ? 1 : 0

  yaml_body = <<YAML
  apiVersion: cert-manager.io/v1
  kind: Certificate
  metadata:
    name: trust-manager-ca
    namespace: ${helm_release.trust-manager.namespace}
  spec:
    isCA: true
    commonName: trust-manager-ca
    secretName: trust-manager-ca-secret
    privateKey:
      algorithm: ECDSA
      size: 256
    issuerRef:
      name: selfsigned-cluster-issuer
      kind: ClusterIssuer
      group: cert-manager.io
  YAML
}

resource "kubectl_manifest" "selfsigned-ca-bundle" {
  depends_on = [kubectl_manifest.selfsigned-clusterissuer]

  count = var.selfsigned-clusterissuer == true ? 1 : 0

  yaml_body = <<YAML
  apiVersion: trust.cert-manager.io/v1alpha1
  kind: Bundle
  metadata:
    name: selfsigned-ca-bundle
  spec:
    sources:
      - useDefaultCAs: false
      - secret:
          name: "trust-manager-ca-secret"
          key: "tls.crt"
    target:
      configMap:
        key: "trust-bundle.pem"
  YAML
}
