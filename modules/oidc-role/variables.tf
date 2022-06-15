variable "cluster_name" {
  description = "eks cluster name"
  type        = string
}
variable "role_name" {
  description = "iam role name"
  type        = string
}
variable "namespace" {
  description = "kubernetes namespace"
  type        = string
}
variable "service_account_name" {
  description = "kubernetes service account name"
  type        = string
}
variable "policy" {
  description = "iam policy document, a json string, to attach to iam role"
  type        = any
  default     = null
}
