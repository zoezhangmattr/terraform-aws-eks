resource "aws_eks_fargate_profile" "fargate-profile" {
  for_each               = var.fargate_profiles
  cluster_name           = aws_eks_cluster.this.name
  fargate_profile_name   = each.value["name"]
  pod_execution_role_arn = aws_iam_role.fargate-pods-role[0].arn
  subnet_ids             = var.fargate_subnets

  dynamic "selector" {
    for_each = each.value["selector"]
    content {
      namespace = selector.value["namespace"]
      labels    = selector.value["labels"]
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.fargate-AmazonEKSFargatePodExecutionRolePolicy,
  ]
}


data "aws_iam_policy_document" "fargate-assume-role-policy" {
  count = length(var.fargate_profiles) > 0 ? 1 : 0
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks-fargate-pods.amazonaws.com"]
    }
  }
}
# eks-fargate-pods.amazonaws.com
resource "aws_iam_role" "fargate-pods-role" {
  count = length(var.fargate_profiles) > 0 ? 1 : 0
  name  = format("%s-fargate-pods-role", var.cluster_name)

  assume_role_policy = data.aws_iam_policy_document.fargate-assume-role-policy[count.index].json
}

resource "aws_iam_role_policy_attachment" "fargate-AmazonEKSFargatePodExecutionRolePolicy" {
  count      = length(var.fargate_profiles) > 0 ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.fargate-pods-role[count.index].name
}
