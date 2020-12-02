data "aws_vpc" "deafult" {
  id = "${var.vpc_id}"
}

resource "aws_security_group" "postgres" {
  name        = "${var.cluster_name}-${var.environment}-postgres-sg"
  description = "Allow inbound traffic to postgres"
  vpc_id      = "${var.vpc_id}"

  tags = {
    Name        = "ingress_to_postgres_${var.identifier}"
    Environment = "${var.environment}"
  }
}

# Randomize the availability zones to maximizes data durability in failure scenarios
resource "random_shuffle" "rds_azs" {
    input = "${split(",", var.azs)}"
    result_count = "${var.db_replica+1}"
}

resource "aws_security_group_rule" "ingress" {
  description       = "${var.cluster_name}-${var.environment}-ingress-sg"
  type              = "ingress"
  from_port         = "5432"
  to_port           = "5432"
  protocol          = "tcp"
  cidr_blocks       = ["${data.aws_vpc.deafult.cidr_block}"]
  security_group_id = "${aws_security_group.postgres.id}"
}


resource "aws_db_subnet_group" "default" {
  name       = "${var.cluster_name}-${var.environment}-db-subnet-grp"
  # subnet_ids = ["subnet-04d3f1af4e09275ff","subnet-031a38fb6d334f261","subnet-002196a216514ec73"]
  subnet_ids = ["subnet-04d3f1af4e09275ff","subnet-031a38fb6d334f261","subnet-002196a216514ec73"]

  tags = {
    Name        = "${var.cluster_name}-${var.environment}-db-subnet-grp"
    Environment = "${var.environment}"
    Terraform   = true
  }
}

resource "aws_db_parameter_group" "db_param_group" {
  name   = "${var.cluster_name}-${var.environment}-db-param-grp"
  family = "${var.db_param_family}"

  tags = {
    Name        = "${var.cluster_name}-${var.environment}-db-subnet-grp"
    Environment = "${var.environment}"
    Terraform   = true
  }
}




# RDS Instance Setup with encrypted storage
resource "aws_db_instance" "default" {
  identifier = "${var.cluster_name}-${var.environment}"
  final_snapshot_identifier = "${var.cluster_name}-${var.environment}-final-snapshot"
  name       = "${var.db_name}"
  port     = "5432"
  username = "${var.username}"
  password = "${var.password}"
  multi_az          = "${var.multi_az}"
  engine            = "${var.db_engine}"
  engine_version    = "${var.engine_version}"
  instance_class    = "${var.instance_class}"
  allocated_storage = "${var.allocated_storage}"
  storage_encrypted = "${var.storage_encrypted}"
  allow_major_version_upgrade = "false"
  auto_minor_version_upgrade  = "false"
  apply_immediately           = "false"
  maintenance_window      = "${var.maintenance_window}"
  backup_window           = "${var.db_backup_window}"
  backup_retention_period = "${var.db_backup_retention}"
  publicly_accessible = "${var.publicly_accessible}"
  monitoring_interval                   = "${var.monitoring_interval}"
  monitoring_role_arn                   = "${var.monitoring_role_arn}"
  performance_insights_enabled          = "${var.performance_insights_enabled}"
  performance_insights_retention_period = "${var.performance_insights_retention_period}"
  deletion_protection = "${var.deletion_protection}"
  # DB parameter group
  parameter_group_name      = "${aws_db_parameter_group.db_param_group.name}"
  db_subnet_group_name      = "${aws_db_subnet_group.default.name}"
  # snapshot name upon DB deletion
  skip_final_snapshot       = "${var.skip_final_snapshot}"
  snapshot_identifier       = "${var.snapshot_id}"
  # security group
  vpc_security_group_ids = ["${aws_security_group.postgres.id}"]
  copy_tags_to_snapshot     = "${var.copy_tags_to_snapshot}"
  tags = {
    Role       = "${var.role}"
    Environment = "${var.environment}"
    Team = "${var.team}"
    App = "${var.cluster_name}"
  }

}
