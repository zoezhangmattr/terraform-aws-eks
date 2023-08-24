# terraform-aws-eks
## overview
a light terraform module to create eks cluster as a playground to move forward and have some fun to play around.

## usage
see example
```tf
module "test" {
  source      = "git@github.com:zoezhangmattr/terraform-aws-vpc.git"
  name_prefix = "test"
  vpc_cidr    = "10.17.0.0/20"
  natgateway  = ["a", "b", "c"]
  public_subnets = {
    a = "10.17.0.0/23"
    b = "10.17.2.0/23"
    c = "10.17.4.0/23"
  }
  extra_public_subnet_tags = {
    "kubernetes.io/cluster/test" = "shared"
  }
  extra_private_subnet_tags = {
    "kubernetes.io/cluster/test" = "shared"
  }
  private_subnets = {
    a = "10.17.6.0/23"
    b = "10.17.8.0/23"
    c = "10.17.10.0/23"
  }
}

module "eks-test" {
  source                = "../"
  eks_version           = "1.25"
  enable_public_access  = true
  enable_private_access = true
  cluster_name          = "test"
  cluster_subnets = concat(
    [for k, v in module.test.public-subnet-ids : v],
    [for k, v in module.test.private-subnet-ids : v]
  )
  vpc_id             = module.test.vpc-id

  # add a node group
  node_group_subnets = [for k, v in module.test.public-subnet-ids : v]
  node_groups = {
    "group1" = {
      name           = "group1"
      desired        = 2
      min            = 1
      max            = 4
      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
      disk_size      = "20"
      taints         = {}
      labels         = {}
    }
  }
  # add a fargate profile
  fargate_profiles = {
    "poc" = {
      name           = "poc"
      selector = {
        "first" = {
          namespace = "poc"
          labels = {}
        }
      }
    }
  }
  fargate_subnets = [for k, v in module.test.private-subnet-ids : v]
}

```
## input
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_name | eks cluster name | `string` | "" | yes |
| eks_version | eks cluster version | `string` | "1.22" | yes |
| enable_private_access | Whether the Amazon EKS private API server endpoint is enabled | `bool` | false | no |
| enable_public_access | Whether the Amazon EKS public API server endpoint is enabled | `bool` | true | false |
| public_access_cidrs | Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled | `list` | ["0.0.0.0/0"] | no |
| fargate_profiles | a map of fargate profile config | `map` | {} | false |
| node_groups | a map of node groups config | `map` | {} | yes |
| cluster_subnets | a list of subnet ids for eks cluster | `list` | [] | yes |
| vpc_id | the vpc id of eks cluster | `string` | none | yes |
| extra_security_groups | a list of security group id add to cluster | `list` | [] | no |
| node_group_subnets | a list of subnet ids for node group | `list` | [] | yes |
| fargate_subnets | a list of subnet ids for fargate profile | `list` | [] | no |
| cluster_service_ipv4_cidr | The CIDR block to assign Kubernetes service IP addresses from | `string` | "192.168.0.0/16" | no |
| vpc_cni_addon_version | vpc cni addon version | `string` | "v1.10.1-eksbuild.1" | no |
| kube_proxy_addon_version | kube-proxy addon version | `string` | "v1.22.6-eksbuild.1" | no |
| coredns_addon_version | coredns addon version | `string` | "v1.8.7-eksbuild.1" | no |

## output
| Name | Description | Type |
|------|-------------|------|
|endpoint|eks cluster api server endpoint|string|
|kubeconfig-certificate-authority-data|eks cluster ca data|string|
|oidc|eks cluster identity issuer url|string|

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=5.14 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >=3.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=5.14 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | >=3.4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.cluster-log-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_eks_addon.coredns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.kube_proxy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.vpc-cni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_fargate_profile.fargate-profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_fargate_profile) | resource |
| [aws_eks_node_group.node-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_iam_openid_connect_provider.eks-identity-provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.cluster-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.fargate-pods-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.vpc-cni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.worker-node-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.cluster-AmazonEKSVPCResourceController](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.fargate-AmazonEKSFargatePodExecutionRolePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node-group-AmazonEC2ContainerRegistryReadOnly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node-group-AmazonEKSWorkerNodePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node-group-AmazonEKS_CNI_Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.vpc-cni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.cluster_egress_internet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_iam_policy_document.eks-assume-role-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.fargate-assume-role-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.vpc_cni_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.worker-assume-role-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [tls_certificate.cluster](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | eks cluster name | `string` | `""` | no |
| <a name="input_cluster_service_ipv4_cidr"></a> [cluster\_service\_ipv4\_cidr](#input\_cluster\_service\_ipv4\_cidr) | The CIDR block to assign Kubernetes service IP addresses from | `string` | `"192.168.0.0/16"` | no |
| <a name="input_cluster_subnets"></a> [cluster\_subnets](#input\_cluster\_subnets) | a list of subnet ids for eks cluster | `list(any)` | `[]` | no |
| <a name="input_coredns_addon_version"></a> [coredns\_addon\_version](#input\_coredns\_addon\_version) | coredns addon version | `string` | `"v1.9.3-eksbuild.5"` | no |
| <a name="input_eks_version"></a> [eks\_version](#input\_eks\_version) | eks cluster version | `string` | `"1.25"` | no |
| <a name="input_enable_private_access"></a> [enable\_private\_access](#input\_enable\_private\_access) | Whether the Amazon EKS private API server endpoint is enabled | `bool` | `false` | no |
| <a name="input_enable_public_access"></a> [enable\_public\_access](#input\_enable\_public\_access) | Whether the Amazon EKS public API server endpoint is enabled | `bool` | `true` | no |
| <a name="input_extra_security_groups"></a> [extra\_security\_groups](#input\_extra\_security\_groups) | a list of security group id add to cluster | `list(any)` | `[]` | no |
| <a name="input_fargate_profiles"></a> [fargate\_profiles](#input\_fargate\_profiles) | a map of fargate profile config | `map(any)` | `{}` | no |
| <a name="input_fargate_subnets"></a> [fargate\_subnets](#input\_fargate\_subnets) | a list of subnet ids for fargate profile | `list(any)` | `[]` | no |
| <a name="input_kube_proxy_addon_version"></a> [kube\_proxy\_addon\_version](#input\_kube\_proxy\_addon\_version) | kube-proxy addon version | `string` | `"v1.25.6-eksbuild.1"` | no |
| <a name="input_node_group_subnets"></a> [node\_group\_subnets](#input\_node\_group\_subnets) | a list of subnet ids for node group | `list(any)` | `[]` | no |
| <a name="input_node_groups"></a> [node\_groups](#input\_node\_groups) | a map of node groups config | `map(any)` | `{}` | no |
| <a name="input_public_access_cidrs"></a> [public\_access\_cidrs](#input\_public\_access\_cidrs) | Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled | `list(any)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_vpc_cni_addon_version"></a> [vpc\_cni\_addon\_version](#input\_vpc\_cni\_addon\_version) | vpc cni addon version | `string` | `"v1.13.4-eksbuild.1"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | the vpc id of eks cluster | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | n/a |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | n/a |
| <a name="output_kubeconfig-certificate-authority-data"></a> [kubeconfig-certificate-authority-data](#output\_kubeconfig-certificate-authority-data) | n/a |
| <a name="output_oidc"></a> [oidc](#output\_oidc) | n/a |
<!-- END_TF_DOCS -->