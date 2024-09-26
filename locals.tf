locals {
  resource_name = "${var.project}-${var.environment}"
  AZ_names = data.aws_availability_zones.AZ.names
}