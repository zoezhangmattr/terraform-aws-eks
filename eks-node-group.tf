resource "aws_eks_node_group" "node-group" {
  for_each        = var.node_groups
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = each.value["name"]
  node_role_arn   = aws_iam_role.worker-node-role[0].arn
  subnet_ids      = var.node_group_subnets

  scaling_config {
    desired_size = each.value["desired"]
    max_size     = each.value["max"]
    min_size     = each.value["min"]
  }
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  #   ami_type = AL2_x86_64, AL2_x86_64_GPU, AL2_ARM_64
  instance_types = each.value["instance_types"]

  capacity_type = each.value["capacity_type"]

  disk_size = each.value["disk_size"] # gb

  labels = each.value["labels"]
  dynamic "taint" {
    for_each = each.value["taints"]
    content {

      key    = taint.value["key"]
      value  = taint.value["value"]
      effect = taint.value["effect"]
    }
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.node-group-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node-group-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node-group-AmazonEC2ContainerRegistryReadOnly,
  ]
}

data "aws_iam_policy_document" "worker-assume-role-policy" {
  count = length(var.node_groups) > 0 ? 1 : 0
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "worker-node-role" {
  count = length(var.node_groups) > 0 ? 1 : 0
  name  = format("%s-work-node-role", var.cluster_name)

  assume_role_policy = data.aws_iam_policy_document.worker-assume-role-policy[count.index].json
}
resource "aws_iam_role_policy_attachment" "node-group-AmazonEKSWorkerNodePolicy" {
  count      = length(var.node_groups) > 0 ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.worker-node-role[count.index].name
}
resource "aws_iam_role_policy_attachment" "node-group-AmazonEKS_CNI_Policy" {
  count      = length(var.node_groups) > 0 ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.worker-node-role[count.index].name
}
resource "aws_iam_role_policy_attachment" "node-group-AmazonEC2ContainerRegistryReadOnly" {
  count      = length(var.node_groups) > 0 ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.worker-node-role[count.index].name
}
