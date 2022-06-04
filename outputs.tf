output "endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "oidc" {
  value = aws_eks_cluster.this.identity[0].oidc[0].issuer
}
