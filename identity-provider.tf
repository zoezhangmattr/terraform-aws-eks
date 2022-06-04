
# use tls provider to get thumbprint
data "tls_certificate" "cluster" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}
resource "aws_iam_openid_connect_provider" "eks-identity-provider" {
  depends_on = [
    aws_eks_cluster.this
  ]
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = concat([data.tls_certificate.cluster.certificates.0.sha1_fingerprint], [])
  url             = aws_eks_cluster.this.identity.0.oidc.0.issuer
}
