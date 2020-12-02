#
# RDS - outputs.tf
#
###############################################################################
output "database_address" {
  value = "${aws_db_instance.default.address}"
}

output "database_port" {
  value = "${aws_db_instance.default.port}"
}

output "database_security_group_name" {
  value = "${aws_security_group.postgres.name}"
}

output "database_security_group_id" {
  value = "${aws_security_group.postgres.id}"
}

