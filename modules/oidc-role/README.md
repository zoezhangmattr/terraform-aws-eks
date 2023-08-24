# terraform-aws-eks oidc-role module
a light module to create eks oidc role

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_name | eks cluster name | `string` | none | yes |
| role_name | iam role name | `string` | none | yes |
| namespace | kubernetes namespace | `string` | none | yes |
| service_account_name | kubernetes service account name | `string` | none | yes |
| policy | iam policy document, a json string, to attach to iam role | `any` | null | no |

## output
| Name | Description | Type |
|------|-------------|------|
|role_arn|iam role arn|string|

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=5.14 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=5.14 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_iam_policy_document.assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | eks cluster name | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | kubernetes namespace | `string` | n/a | yes |
| <a name="input_policy"></a> [policy](#input\_policy) | iam policy document, a json string, to attach to iam role | `any` | `null` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | iam role name | `string` | n/a | yes |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | kubernetes service account name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | n/a |
<!-- END_TF_DOCS -->