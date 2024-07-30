###########################################################
#              SETTINGS PARAMETERS EB                     #
###########################################################

locals {
  settings = concat([
    {
      resource  = "AWSEBSecurityGroup"
      namespace = "aws:ec2:vpc"
      name      = "VPCId"
      value     = var.vpc_id
    },
    {
      namespace = "aws:ec2:vpc"
      name      = "ELBSubnets"
      value     = join(",", sort(compact(concat(var.private_subnets))))
    },
    {
      namespace = "aws:ec2:vpc"
      name      = "Subnets"
      value     = join(",", sort(compact(concat(var.private_subnets, var.public_subnets))))
    },
    {
      namespace = "aws:autoscaling:launchconfiguration"
      name      = "SecurityGroups"
      value     = join(",", sort(compact(concat([aws_security_group.this.id]))))
      resource  = ""
    },
    {
      namespace = "aws:elbv2:loadbalancer"
      name      = "SecurityGroups"
      value     = join(",", sort(compact(concat([aws_security_group.this.id]))))
      resource  = ""
    },
    {
      namespace = "aws:autoscaling:launchconfiguration"
      name      = "IamInstanceProfile"
      value     = aws_iam_instance_profile.profile[*].name
      resource  = ""
    },
    {
      namespace = "aws:elasticbeanstalk:environment"
      name      = "ServiceRole"
      value     = aws_iam_role.service[*].name
    },
    {
      namespace = "aws:elasticbeanstalk:managedactions"
      name      = "ServiceRoleForManagedUpdates"
      value     = aws_iam_role.service[*].name
    },
    {
      resource  = "AWSEBLoadBalancerSecurityGroup"
      namespace = "aws:ec2:vpc"
      name      = "vPCId"
      value     = var.vpc_id
    },
    {
      resource  = "AWSEBAutoScalingGroup"
      namespace = "aws:autoscaling:asg"
      name      = "Availability Zones"
      value     = "Any 2"
    },
    {
      resource  = "AWSEBAutoScalingGroup"
      namespace = "aws:autoscaling:asg"
      name      = "Cooldown"
      value     = "360"
    },
    {
      resource  = "AWSEBAutoScalingGroup"
      namespace = "aws:autoscaling:asg"
      name      = "EnableCapacityRebalancing"
      value     = "false"
    },
    {
      resource  = "AWSEBAutoScalingGroup"
      namespace = "aws:autoscaling:asg"
      name      = "MaxSize"
      value     = "4"
    },
    {
      resource  = "AWSEBAutoScalingGroup"
      namespace = "aws:autoscaling:asg"
      name      = "MinSize"
      value     = "1"
    },
    {
      resource  = "AWSEBAutoScalingLaunchConfiguration"
      namespace = "aws:autoscaling:launchconfiguration"
      name      = "BlockDeviceMappings"
    },
    {
      namespace = "aws:autoscaling:launchconfiguration"
      name      = "DisableIMDSv1"
      value     = "true"
    },
    {
      namespace = "aws:autoscaling:launchconfiguration"
      name      = "InstanceType"
      value     = "t3.micro"
    },
    {
      resource  = "AWSEBAutoScalingLaunchConfiguration"
      namespace = "aws:autoscaling:launchconfiguration"
      name      = "MonitoringInterval"
      value     = "5 minute"
    },
    {
      namespace = "aws:autoscaling:launchconfiguration"
      name      = "SSHSourceRestriction"
      value     = "tcp,22,22,0.0.0.0/0"
    },
    {
      resource  = "AWSEBCloudwatchAlarmLow"
      namespace = "aws:autoscaling:trigger"
      name      = "BreachDuration"
      value     = "5"
    },
    {
      resource  = "AWSEBCloudwatchAlarmLow"
      namespace = "aws:autoscaling:trigger"
      name      = "EvaluationPeriods"
      value     = "1"
    },
    {
      resource  = "AWSEBAutoScalingScaleDownPolicy"
      namespace = "aws:autoscaling:trigger"
      name      = "LowerBreachScaleIncrement"
      value     = "-1"
    },
    {
      resource  = "AWSEBCloudwatchAlarmLow"
      namespace = "aws:autoscaling:trigger"
      name      = "LowerThreshold"
      value     = "2000000"
    },
    {
      resource  = "AWSEBCloudwatchAlarmLow"
      namespace = "aws:autoscaling:trigger"
      name      = "MeasureName"
      value     = "networkOut"
    },
    {
      resource  = "AWSEBCloudwatchAlarmLow"
      namespace = "aws:autoscaling:trigger"
      name      = "Period"
      value     = "5"
    },
    {
      resource  = "AWSEBCloudwatchAlarmLow"
      namespace = "aws:autoscaling:trigger"
      name      = "Statistic"
      value     = "Average"
    },
    {
      resource  = "AWSEBCloudwatchAlarmLow"
      namespace = "aws:autoscaling:trigger"
      name      = "Unit"
      value     = "Bytes"
    },
    {
      resource  = "AWSEBAutoScalingScaleUpPolicy"
      namespace = "aws:autoscaling:trigger"
      name      = "UpperBreachScaleIncrement"
      value     = "1"
    },
    {
      resource  = "AWSEBCloudwatchAlarmHigh"
      namespace = "aws:autoscaling:trigger"
      name      = "UpperThreshold"
      value     = "6000000"
    },
    {
      resource  = "AWSEBAutoScalingGroup"
      namespace = "aws:autoscaling:updatepolicy:rollingupdate"
      name      = "MaxBatchSize"
    },
    {
      resource  = "AWSEBAutoScalingGroup"
      namespace = "aws:autoscaling:updatepolicy:rollingupdate"
      name      = "MinInstancesInService"
    },
    {
      resource  = "AWSEBAutoScalingGroup"
      namespace = "aws:autoscaling:updatepolicy:rollingupdate"
      name      = "PauseTime"
    },
    {
      resource  = "AWSEBAutoScalingGroup"
      namespace = "aws:autoscaling:updatepolicy:rollingupdate"
      name      = "rollingUpdateEnabled"
      value     = "false"
    },
    {
      resource  = "AWSEBAutoScalingGroup"
      namespace = "aws:autoscaling:updatepolicy:rollingupdate"
      name      = "rollingUpdateType"
      value     = "Time"
    },
    {
      resource  = "AWSEBAutoScalingGroup"
      namespace = "aws:autoscaling:updatepolicy:rollingupdate"
      name      = "Timeout"
      value     = "PT30M"
    },
    {
      namespace = "aws:cloudformation:template:parameter"
      name      = "InstancePort"
      value     = "80"
    },
    {
      namespace = "aws:cloudformation:template:parameter"
      name      = "InstanceTypeFamily"
      value     = "t3"
    },
    {
      namespace = "aws:ec2:instances"
      name      = "EnableSpot"
      value     = "false"
    },
    {
      namespace = "aws:ec2:instances"
      name      = "InstanceTypes"
      value     = "t3.medium, t3.micro"
    },
    {
      namespace = "aws:ec2:instances"
      name      = "SpotFleetOnDemandAboveBasePercentage"
      value     = "70"
    },
    {
      namespace = "aws:ec2:instances"
      name      = "SpotFleetOnDemandBase"
      value     = "0"
    },
    {
      namespace = "aws:ec2:instances"
      name      = "SupportedArchitectures"
      value     = "x86_64"
    },
    {
      resource  = "AWSEBAutoScalingLaunchConfiguration"
      namespace = "aws:ec2:vpc"
      name      = "AssociatePublicIpAddress"
      value     = "True"
    },
    {
      namespace = "aws:ec2:vpc"
      name      = "ELBScheme"
      value     = "public"
    },
    {
      namespace = "aws:elasticbeanstalk:application"
      name      = "Application Healthcheck URL"
      value     = "/health"
    },
    {
      namespace = "aws:elasticbeanstalk:cloudwatch:logs"
      name      = "DeleteOnTerminate"
      value     = "false"
    },
    {
      namespace = "aws:elasticbeanstalk:cloudwatch:logs"
      name      = "retentionInDays"
      value     = "7"
    },
    {
      namespace = "aws:elasticbeanstalk:cloudwatch:logs"
      name      = "StreamLogs"
      value     = "false"
    },
    {
      namespace = "aws:elasticbeanstalk:container:python"
      name      = "NumProcesses"
      value     = "3"
    },
    {
      namespace = "aws:elasticbeanstalk:container:python"
      name      = "NumThreads"
      value     = "15"
    },
    {
      namespace = "aws:elasticbeanstalk:environment"
      name      = "EnvironmentType"
      value     = "LoadBalanced"
    },
    {
      namespace = "aws:elasticbeanstalk:environment"
      name      = "LoadBalancerIsShared"
      value     = "false"
    },
    {
      namespace = "aws:elasticbeanstalk:environment"
      name      = "LoadBalancerType"
      value     = "application"
    },
    {
      namespace = "aws:elasticbeanstalk:hostmanager"
      name      = "LogPublicationControl"
      value     = "false"
    },
    {
      namespace = "aws:elasticbeanstalk:hostmanager"
      name      = "SystemLogsEnabled"
      value     = "false"
    },
    {
      namespace = "aws:elasticbeanstalk:hostmanager"
      name      = "SystemLogsPublicationControl"
      value     = "false"
    },
    {
      namespace = "aws:elasticbeanstalk:sns:topics"
      name      = "Notification Endpoint"
    },
    {
      namespace = "aws:elasticbeanstalk:sns:topics"
      name      = "Notification Protocol"
      value     = "Email"
    },
    {
      namespace = "aws:elasticbeanstalk:cloudwatch:logs:health"
      name      = "HealthStreamingEnabled"
      value     = "false"
    },
    {
      namespace = "aws:elasticbeanstalk:command"
      name      = "BatchSize"
      value     = "30"
    },
    {
      namespace = "aws:elasticbeanstalk:command"
      name      = "BatchSizeType"
      value     = "Percentage"
    },
    {
      namespace = "aws:elasticbeanstalk:command"
      name      = "DeploymentPolicy"
      value     = "AllAtOnce"
    },
    {
      namespace = "aws:elasticbeanstalk:command"
      name      = "IgnoreHealthCheck"
      value     = "false"
    },
    {
      namespace = "aws:elasticbeanstalk:command"
      name      = "Timeout"
      value     = "1800"
    },
  ], var.custom_settings)

  settings_resource    = { for idx, setting in local.settings : idx => setting if contains(keys(setting), "resource") }
  settings_no_resource = { for idx, setting in local.settings : idx => setting if !contains(keys(setting), "resource") }
}


###########################################################
#              ELASTIC BEANSTALK APPLICATION              #
###########################################################

resource "aws_elastic_beanstalk_application" "this" {
  name        = local.application_name
  description = local.application_name
}

###########################################################
#              ELASTIC BEANSTALK ENVIRONMENT              #
###########################################################

resource "aws_elastic_beanstalk_environment" "this" {
  name                   = local.application_name
  description            = local.application_name
  application            = aws_elastic_beanstalk_application.this.name
  solution_stack_name    = try(var.solution_stack_name, "64bit Amazon Linux 2023 v4.3.4 running Docker ")
  wait_for_ready_timeout = try(var.wait_for_ready_timeout, "40m")

  dynamic "setting" {
    for_each = try(local.settings_no_resource, {})
    content {
      namespace = tostring(setting.value.namespace)
      name      = tostring(setting.value.name)
      value     = tostring(setting.value.value)
    }
  }

  dynamic "setting" {
    for_each = try(local.settings_resource, {})
    content {
      namespace = tostring(setting.value.namespace)
      name      = tostring(setting.value.name)
      value     = tostring(setting.value.value)
      resource  = tostring(setting.value.value)
    }
  }

  depends_on = []
}
