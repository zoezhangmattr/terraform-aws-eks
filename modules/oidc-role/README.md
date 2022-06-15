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
