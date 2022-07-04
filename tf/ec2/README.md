<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.14.0 |
| <a name="requirement_cloudinit"></a> [cloudinit](#requirement\_cloudinit) | 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.14.0 |
| <a name="provider_cloudinit"></a> [cloudinit](#provider\_cloudinit) | 2.2.0 |
| <a name="provider_http"></a> [http](#provider\_http) | 2.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.web](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/instance) | resource |
| [aws_security_group.web_server](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/security_group) | resource |
| [aws_security_group_rule.http_allow](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ssh_allow](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/resources/security_group_rule) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/data-sources/ami) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/4.14.0/docs/data-sources/vpc) | data source |
| [cloudinit_config.server_config](https://registry.terraform.io/providers/hashicorp/cloudinit/2.2.0/docs/data-sources/config) | data source |
| [http_http.myip](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_key_pair_name"></a> [key\_pair\_name](#input\_key\_pair\_name) | n/a | `string` | `"NEP-MAC"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_WEB_ADDRESS"></a> [WEB\_ADDRESS](#output\_WEB\_ADDRESS) | n/a |
<!-- END_TF_DOCS -->