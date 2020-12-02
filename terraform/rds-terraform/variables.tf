provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

variable "vpc_id" {
  description = "The id of the VPC in which to put the postgres rds instance"
  default = ""
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of VPC subnet IDs"
  default     = []
}
variable "db_param_family" {
  description = "database family specific to the database engine implementation"
  default     = "postgres11"
}
variable "cidr_blocks" {
  type        = list(string)
  description = "A list of cidr blocks to allow ingress to postgres"
  default     = ["10.0.0.0/8"]
}

variable "identifier" {
  description = "The ID"
  default = ""
}


#
variable "instance_class" {
  description = "The instance class for the postrges hosts"
  default     = "db.t3.micro"
}
#
# # multi-az should be set to false for all non-prod excluding staging environment
variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  default     = true
}
#
variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  default     = 10
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  default     = "true"
}
#
#
# # pwd should never be in terraform. Please enter it manually when deploying from local machine or use encrypted variables within travis/circleci
variable "password" {
 default = "test1234567"
}
#
variable "engine_version" {
  description = "The version of postgres"
  default     = "11.4"
}

variable "major_engine_version" {
  description = "Specifies the major version of postgres that the option group is associated with"
  default     = "11"
}

variable "maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  default     = "Sun:00:00-Sun:03:00"
}

variable "backup_window" {
  default = "03:00-06:00"
}

variable "publicly_accessible" {
  default = true
}
#
variable "snapshot_id" {
  default = ""
}
variable "db_name" { default = "" }

variable "copy_tags_to_snapshot" {
  description = "On delete, copy all Instance tags to the final snapshot (if final_snapshot_identifier is specified)"
  default     = true
}
#
variable "deletion_protection" {
  description = "The database can't be deleted when this value is set to true."
  default     = false
}

# # enabling this incurs cost, please use this as needed for non-prod environments
variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights are enabled"
  default     = true
}

variable "performance_insights_retention_period" {
  description = "The amount of time in days to retain Performance Insights data. Either 7 (7 days) or 731 (2 years)."
  default     = 7
}



# RDS Instance
variable "cluster_name"         { default = "" }
variable "environment"          { default = "" }
variable "time_zone"            { default = "UTC" } # US/Eastern or US/Pacific or UTC
variable "scope"                { default = "private" } # private to build in private subnets
variable "db_replica"           { default = "0" } #tfvars
variable "rep_skip_final_snapshot"          { default = "true" }
variable "username"          {default = "master" } #tfvars
variable "db_engine"            { default = "postgres" } #tfvars
variable "license_model"        { default = "general-public-license" }
variable "db_major_version"     { default = "11" } #tfvars
variable "db_version"           { default = "11.4"} #tfvars
# variable "db_instance"          { } #tvars
variable "db_storage"           { default = "20"} #tfvars
# variable "db_iops"              { } #tfvars
variable "db_storage_type"      { default = "gp2" }
variable "encrypt_storage"      {default = "true" } #tfvars
variable "db_maintenance_window" { default = "Sun:00:00-Sun:03:00" } #tfvars
variable "db_backup_window" { default = "03:00-06:00" } #tfvarsusername
variable "db_backup_retention" { default = "30" } #tfvars
variable "db_multi_az" {default = "true" } #tfvars
variable "apply_immediately" {default = "false" } #tfvars
variable "auto_minor_version_upgrade"   { default = "false" }
variable "monitoring_interval"          { default = "0" }
variable "monitoring_role_arn"          { default = "" }
variable "skip_final_snapshot"          { default = "false" }
variable "azs"          { default = "us-east-1a,us-east-1b,us-east-1c" }
variable "hosted_zone_id" { default = "" } # format /hostedzone/<hosted_zone_id>
variable "ttl" { default = 300 }

# TAGS for RDS instance
variable "role"     { default = "role"}
variable "team"     { default = "team"}
