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
  eks_version           = "1.22"
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
