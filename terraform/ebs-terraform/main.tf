##################################################
## AWS config
##################################################
provider "aws" {
  profile = "${var.aws_profile}"
  region = "${var.aws_region}"
}

##################################################
## IAM Roles and profiles
##################################################
resource "aws_iam_instance_profile" "beanstalk_service" {
  name = "${var.service_name}-${var.env}-beanstalk-service-user"
  role = "${aws_iam_role.beanstalk_service.name}"
}
resource "aws_iam_instance_profile" "beanstalk_ec2" {
  name = "${var.service_name}-${var.env}-beanstalk-ec2-user"
  role = "${aws_iam_role.beanstalk_ec2.name}"
}
resource "aws_iam_role" "beanstalk_service" {
  name = "${var.service_name}-${var.env}-beanstalk-service-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "elasticbeanstalk.amazonaws.com"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "elasticbeanstalk"
        }
      }
    }
  ]
}
EOF
}
resource "aws_iam_role" "beanstalk_ec2" {
  name = "${var.service_name}-${var.env}-beanstalk-ec2-role"
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
resource "aws_iam_policy_attachment" "beanstalk_service" {
  name = "${var.service_name}-${var.env}-elastic-beanstalk-service"
  roles = ["${aws_iam_role.beanstalk_service.id}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}
resource "aws_iam_policy_attachment" "beanstalk_service_health" {
  name = "${var.service_name}-${var.env}-elastic-beanstalk-service-health"
  roles = ["${aws_iam_role.beanstalk_service.id}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}
resource "aws_iam_policy_attachment" "beanstalk_ec2_web" {
  name = "${var.service_name}-${var.env}-elastic-beanstalk-ec2-web"
  roles = ["${aws_iam_role.beanstalk_ec2.id}"]
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

data "aws_elastic_beanstalk_solution_stack" "multi_docker" {
  most_recent = true

  name_regex = "^64bit Amazon Linux (.*) Multi-container Docker (.*)$"
}


resource "aws_elastic_beanstalk_application" "tftest" {
  name        = "${var.service_name}-${var.env}"
  description = "tf-test-desc"
}

##################################################
## Elastic Beanstalk
##################################################
resource "aws_elastic_beanstalk_environment" "eb_env" {
  name                = "${var.service_name}-${var.env}"
  application         = aws_elastic_beanstalk_application.tftest.name

solution_stack_name = data.aws_elastic_beanstalk_solution_stack.multi_docker.name
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = "${var.ssh_key_name}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "${aws_iam_instance_profile.beanstalk_ec2.name}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = "${aws_iam_role.beanstalk_service.name}"
  }

  # Configure your environment to launch resources in a custom VPC
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "${var.vpc_id}"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${var.vpc_subnets}"
  }
    setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }
    setting {
    namespace = "aws:autoscaling:asg"
    name      = "Cooldown"
    value     = "360"
  }
      setting {
    namespace = "aws:autoscaling:asg"
    name      = "Availability Zones"
    value     = "Any"
  }
      setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }


          setting {
    namespace = "aws:elasticbeanstalk:managedactions"
    name      = "PreferredStartTime"
    value     = "Tue:18:00"
  }
}
