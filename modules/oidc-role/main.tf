data "aws_eks_cluster" "this" {
  name = var.cluster_name
}
data "aws_caller_identity" "this" {

}
locals {
  oidc = replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")
}
data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${local.oidc}:sub"
      values   = ["system:serviceaccount:${var.namespace}:${var.service_account_name}"]
    }

    principals {
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:oidc-provider/${local.oidc}"]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "this" {
  assume_role_policy = data.aws_iam_policy_document.assume.json
  name               = var.role_name
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = length(var.policy) != null ? 1 : 0
  policy_arn = aws_iam_policy.policy[count.index].arn
  role       = aws_iam_role.this.name
}

resource "aws_iam_policy" "policy" {
  count       = length(var.policy) != null ? 1 : 0
  name        = "${var.role_name}-policy"
  description = "${var.role_name} policy"
  policy      = var.policy
}
