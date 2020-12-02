#############
# Variables
############

variable "region" { default = "us-east-1" }



variable "cidr" { default = "10.0.0.0/16" }

variable "private_subnets" {
  default = ["10.0.96.0/19", "10.0.128.0/18", "10.0.192.0/18"]
  type = "list"
}

variable "public_subnets" {
  default = ["10.0.32.0/19", "10.0.0.0/19", "10.0.64.0/19"]
  type = "list"
}

variable "azs" {
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
  type = "list"
}
