locals {
  region              = "us-east-2"
  name                = "quarks-labs"
  cidr                 = "10.3.0.0/16"
  wait_for_ready_timeout             =  "40min"
  solution_stack_name = "64bit Amazon Linux 2023 v4.3.4 running Docker "
  private_subnets     = ["10.3.32.0/19", "10.3.96.0/19"]
  public_subnets      = ["10.3.64.0/19", "10.3.128.0/19"]
  enable_nat_gateway                   = true
  single_nat_gateway                   = true
  enable_dns_hostnames                 = true
  enable_flow_log                      = true
  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true
}


###########################################################
#                          VPC                            #
###########################################################

module "vpc" {
  source                               = "git::git@github.com:quarks-labs/gcp-container-cluster-module.git"
  name                                 = local.name
  cidr                                 = local.cidr
  azs                                  = ["${local.region}a", "${local.region}b"]
  private_subnets                      = local.private_subnets
  public_subnets                       = local.public_subnets
  enable_nat_gateway                   = local.enable_nat_gateway
  single_nat_gateway                   = local.single_nat_gateway
  enable_dns_hostnames                 = local.enable_dns_hostnames
  enable_flow_log                      = local.enable_flow_log
  create_flow_log_cloudwatch_iam_role  = local.create_flow_log_cloudwatch_iam_role
  create_flow_log_cloudwatch_log_group = local.create_flow_log_cloudwatch_log_group
}

###########################################################
#              ELASTIC BEANSTALK MODULE                   #
###########################################################


module "elastic_beanstalk" {
  source                 = "git::git@github.com:quarks-labs/aws-elasticbeanstalk-module.git"
  name                   = local.name
  solution_stack_name    = local.solution_stack_name
  region                 = local.region
  wait_for_ready_timeout = local.wait_for_ready_timeout
  vpc_id                 = module.vpc.default_vpc_id
  azs                    = module.vpc.azs
  private_subnets        = module.vpc.private_subnets
  public_subnets         = module.vpc.public_subnets
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
      value     = "el4sticdbpass"
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
