# AWS Elastic BeanStalk Module

Terraform module which creates ELB.

## Usage

```hcl

locals {
  region              = "us-east-2"
  name                = "quarks-labs"
  cidr                = "10.3.0.0/16"
  solution_stack_name = "64bit Amazon Linux 2023 v4.3.4 running Docker "
  private_subnets     = ["10.3.32.0/19", "10.3.96.0/19"]
  public_subnets      = ["10.3.64.0/19", "10.3.128.0/19"]
}


###########################################################
#                          VPC                            #
###########################################################

module "vpc" {
  source                               = "terraform-aws-modules/vpc/aws"
  version                              = "~> 5.0.0"
  name                                 = local.name
  cidr                                 = local.cidr
  azs                                  = ["${local.region}a", "${local.region}b"]
  private_subnets                      = local.private_subnets
  public_subnets                       = local.public_subnets
  enable_nat_gateway                   = true
  single_nat_gateway                   = true
  enable_dns_hostnames                 = true
  enable_flow_log                      = true
  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true
}

###########################################################
#              ELASTIC BEANSTALK MODULE                   #
###########################################################


module "elastic_beanstalk" {
  source                 = "git::git@github.com:quarks-labs/banclima-iac.git"
  name                   = local.name
  solution_stack_name    = local.solution_stack_name
  region                 = local.region
  vpc_id                 = module.vpc.default_vpc_id
  azs                    = module.vpc.azs
  private_subnets        = module.vpc.private_subnets
  public_subnets         = module.vpc.public_subnets
  wait_for_ready_timeout = "40min"
  cert_manager           = []
  custom_settings = [{

    namespace = "aws:rds:dbinstance"
    name      = "DBAllocatedStorage"
    value     = "30"
    },
    {
      namespace = "aws:rds:dbinstance"
      name      = "DBDeletionPolicy"
      value     = "Delete"
    },
    {
      namespace = "aws:rds:dbinstance"
      name      = "MultiAZDatabase"
      value     = "true"
    },
    {
      namespace = "aws:rds:dbinstance"
      name      = "DBEngineVersion"
      value     = "16"
    },
    {
      namespace = "aws:rds:dbinstance"
      name      = "DBEngine"
      value     = "postgres"
    },
    {
      namespace = "aws:rds:dbinstance"
      name      = "DBInstanceClass"
      value     = "db.t4g.small"
    },
    {
      namespace = "aws:rds:dbinstance"
      name      = "DBPassword"
      value     = "b4nclim4p4ss"
    },
    {
      namespace = "aws:rds:dbinstance"
      name      = "DBUser"
      value     = "ebroot"
    },
    {
      namespace = "aws:rds:dbinstance"
      name      = "HasCoupledDatabase"
      value     = "true"
    }
  ]
}

```


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_elastic_beanstalk_application.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elastic_beanstalk_application) | resource |
| [aws_elastic_beanstalk_environment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elastic_beanstalk_environment) | resource |
| [aws_iam_instance_profile.profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy_attachment.attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_policy_attachment.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |        
| [aws_iam_role.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |    
| [aws_iam_role_policy.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [random_string.sufix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |    
| [aws_iam_policy_document.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.extended](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azs"></a> [azs](#input\_azs) | n/a | `list(string)` | n/a | yes |
| <a name="input_cert_manager"></a> [cert\_manager](#input\_cert\_manager) | n/a | <pre>list(object({<br>    domain_name       = string<br>    validation_method = string<br>    tags              = map(string)<br>  }))</pre> | n/a | yes |
| <a name="input_custom_settings"></a> [custom\_settings](#input\_custom\_settings) | n/a | <pre>list(object({<br>    resource  = optional(string)<br>    namespace = string<br>    name      = string<br>    value     = string<br>  }))</pre> | n/a | yes | 
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | n/a | `list(string)` | n/a | yes |       
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | n/a | `list(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_solution_stack_name"></a> [solution\_stack\_name](#input\_solution\_stack\_name) | n/a | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | n/a | yes |
| <a name="input_wait_for_ready_timeout"></a> [wait\_for\_ready\_timeout](#input\_wait\_for\_ready\_timeout) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | n/a |
| <a name="output_endpoint_url"></a> [endpoint\_url](#output\_endpoint\_url) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |