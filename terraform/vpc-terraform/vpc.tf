
# main.tf

#######
# VPC
#######

module "vpc" {
  name                 = "smaran-test"
  source               = "git::git@github.com:terraform-aws-modules/terraform-aws-vpc.git?ref=v1.66.0"
  enable_dns_hostnames = "true"
  cidr                 = "${var.cidr}"
  private_subnets      = "${var.private_subnets}"
  public_subnets       = "${var.public_subnets}"
  azs                  = "${var.azs}"
  enable_nat_gateway = true
}
