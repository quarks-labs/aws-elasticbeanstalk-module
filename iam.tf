locals {
  application_name = lower("${var.name}-${random_string.sufix.result}")
  partition        = join("", data.aws_partition.current[*].partition)
}

data "aws_partition" "current" {
  count = 1
}

resource "random_string" "sufix" {
  length  = 3
  special = false
}

data "aws_iam_policy_document" "ec2" {

  statement {
    sid = ""

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    effect = "Allow"
  }

  statement {
    sid = ""

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ssm.amazonaws.com"]
    }

    effect = "Allow"
  }
}


data "aws_iam_policy_document" "service" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["elasticbeanstalk.amazonaws.com"]
    }

    effect = "Allow"
  }
}


data "aws_iam_policy_document" "default" {

  statement {
    actions = [
      "elasticloadbalancing:DescribeInstanceHealth",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeTargetHealth",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:GetConsoleOutput",
      "ec2:AssociateAddress",
      "ec2:DescribeAddresses",
      "ec2:DescribeSecurityGroups",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeScalingActivities",
      "autoscaling:DescribeNotificationConfigurations",
    ]

    resources = ["*"]

    effect = "Allow"
  }

  statement {
    sid = "AllowOperations"

    actions = [
      "autoscaling:AttachInstances",
      "autoscaling:CreateAutoScalingGroup",
      "autoscaling:CreateLaunchConfiguration",
      "autoscaling:DeleteLaunchConfiguration",
      "autoscaling:DeleteAutoScalingGroup",
      "autoscaling:DeleteScheduledAction",
      "autoscaling:DescribeAccountLimits",
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeLoadBalancers",
      "autoscaling:DescribeNotificationConfigurations",
      "autoscaling:DescribeScalingActivities",
      "autoscaling:DescribeScheduledActions",
      "autoscaling:DetachInstances",
      "autoscaling:PutScheduledUpdateGroupAction",
      "autoscaling:ResumeProcesses",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:SetInstanceProtection",
      "autoscaling:SuspendProcesses",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:UpdateAutoScalingGroup",
      "cloudwatch:PutMetricAlarm",
      "ec2:AssociateAddress",
      "ec2:AllocateAddress",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateSecurityGroup",
      "ec2:DeleteSecurityGroup",
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeAddresses",
      "ec2:DescribeImages",
      "ec2:DescribeInstances",
      "ec2:DescribeKeyPairs",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSnapshots",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcs",
      "ec2:DisassociateAddress",
      "ec2:ReleaseAddress",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:TerminateInstances",
      "ecs:CreateCluster",
      "ecs:DeleteCluster",
      "ecs:DescribeClusters",
      "ecs:RegisterTaskDefinition",
      "elasticbeanstalk:*",
      "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
      "elasticloadbalancing:ConfigureHealthCheck",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DescribeInstanceHealth",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:DeregisterTargets",
      "iam:ListRoles",
      "logs:CreateLogGroup",
      "logs:PutRetentionPolicy",
      "rds:DescribeDBEngineVersions",
      "rds:DescribeDBInstances",
      "rds:DescribeOrderableDBInstanceOptions",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:ListBucket",
      "sns:CreateTopic",
      "sns:GetTopicAttributes",
      "sns:ListSubscriptionsByTopic",
      "sns:Subscribe",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "codebuild:CreateProject",
      "codebuild:DeleteProject",
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
    ]

    resources = ["*"]

    effect = "Allow"
  }

  statement {
    sid = "AllowPassRole"

    actions = [
      "iam:PassRole"
    ]

    resources = [
      join("", aws_iam_role.ec2[*].arn),
      join("", aws_iam_role.service[*].arn)
    ]

    effect = "Allow"
  }

  statement {
    sid = "AllowS3OperationsOnElasticBeanstalkBuckets"

    actions = [
      "s3:*"
    ]

    resources = [
      "arn:${local.partition}:s3:::*"
    ]

    effect = "Allow"
  }

  statement {
    sid = "AllowDeleteCloudwatchLogGroups"

    actions = [
      "logs:DeleteLogGroup"
    ]

    resources = [
      "arn:${local.partition}:logs:*:*:log-group:/aws/elasticbeanstalk*"
    ]

    effect = "Allow"
  }

  statement {
    sid = "AllowCloudformationOperationsOnElasticBeanstalkStacks"

    actions = [
      "cloudformation:*"
    ]

    resources = [
      "arn:${local.partition}:cloudformation:*:*:stack/awseb-*",
      "arn:${local.partition}:cloudformation:*:*:stack/eb-*"
    ]

    effect = "Allow"
  }
}

data "aws_iam_policy_document" "extended" {
  source_policy_documents   = [join("", data.aws_iam_policy_document.default[*].json)]
  override_policy_documents = []
}

resource "aws_iam_role" "ec2" {
  name               = "${local.application_name}-role-ec2"
  assume_role_policy = join("", data.aws_iam_policy_document.ec2[*].json)
}

resource "aws_iam_role" "service" {
  name               = "${local.application_name}-role-service"
  assume_role_policy = join("", data.aws_iam_policy_document.service[*].json)
}

resource "aws_iam_role_policy" "default" {
  name   = "${local.application_name}-role-default"
  role   = join("", aws_iam_role.ec2[*].id)
  policy = join("", data.aws_iam_policy_document.extended[*].json)
}

resource "aws_iam_instance_profile" "profile" {
  name       = "${local.application_name}-profile-ec2"
  role       = join("", aws_iam_role.ec2[*].id)
  depends_on = [aws_iam_role.ec2]
}

resource "aws_iam_policy_attachment" "attachment" {
  for_each = try({ for idx, role in [
    "arn:${local.partition}:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker",
    "arn:${local.partition}:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker",
    "arn:${local.partition}:iam::aws:policy/AWSElasticBeanstalkWebTier",
    "arn:${local.partition}:iam::aws:policy/AWSElasticBeanstalkWorkerTier",
    "arn:${local.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:${local.partition}:iam::aws:policy/service-role/AmazonSSMAutomationRole",
    "arn:${local.partition}:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ] : idx => role }, {})

  name = join("", aws_iam_role.ec2[*].name, "-", idx)

  policy_arn = each.value

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_iam_instance_profile.profile, aws_iam_role.ec2]
}

resource "aws_iam_policy_attachment" "service" {

  for_each = try({ for idx, role in [
    "arn:${local.partition}:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth",
    "arn:${local.partition}:iam::aws:policy/AWSElasticBeanstalkManagedUpdatesCustomerRolePolicy"
  ] : idx => role }, {})

  name = join("", aws_iam_role.ec2[*].name, "-", idx)
  policy_arn = each.value
  depends_on = [aws_iam_instance_profile.profile, aws_iam_role.ec2]
}
