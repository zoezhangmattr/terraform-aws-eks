variable "eks_version" {
  type        = string
  default     = "1.22"
  description = "eks cluster version"
}
variable "enable_private_access" {
  type        = bool
  default     = false
  description = "Whether the Amazon EKS private API server endpoint is enabled"
}
variable "enable_public_access" {
  type        = bool
  default     = true
  description = "Whether the Amazon EKS public API server endpoint is enabled"
}
variable "public_access_cidrs" {
  type        = list(any)
  default     = ["0.0.0.0/0"]
  description = "Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled"
}
variable "cluster_name" {
  type        = string
  default     = ""
  description = "eks cluster name"
}

variable "fargate_profiles" {
  type        = map(any)
  default     = {}
  description = "a map of fargate profile config"
}

variable "node_groups" {
  type        = map(any)
  default     = {}
  description = "a map of node groups config"
}

variable "cluster_subnets" {
  type        = list(any)
  default     = []
  description = "a list of subnet ids for eks cluster"
}

variable "vpc_id" {
  type        = string
  description = "the vpc id of eks cluster"
}
variable "extra_security_groups" {
  type        = list(any)
  default     = []
  description = "a list of security group id add to cluster"
}

variable "node_group_subnets" {
  type        = list(any)
  default     = []
  description = "a list of subnet ids for node group"
}

variable "fargate_subnets" {
  type        = list(any)
  default     = []
  description = "a list of subnet ids for fargate profile"
}

variable "cluster_service_ipv4_cidr" {
  type        = string
  description = "The CIDR block to assign Kubernetes service IP addresses from"
  default     = "192.168.0.0/16"
}

variable "vpc_cni_addon_version" {
  type        = string
  description = "vpc cni addon version"
  default     = "v1.10.1-eksbuild.1"
}

variable "kube_proxy_addon_version" {
  type        = string
  description = "kube-proxy addon version"
  default     = "v1.22.6-eksbuild.1"
}

variable "coredns_addon_version" {
  type        = string
  description = "coredns addon version"
  default     = "v1.8.7-eksbuild.1"
}
