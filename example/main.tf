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
  vpc_id = module.test.vpc-id

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
      name = "poc"
      selector = {
        "first" = {
          namespace = "poc"
          labels    = {}
        }
      }
    }
  }
  fargate_subnets = [for k, v in module.test.private-subnet-ids : v]
}


output "endpoint" {
  value = module.eks-test.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = module.eks-test.kubeconfig-certificate-authority-data
}

output "oidc" {
  value = module.eks-test.oidc
}
