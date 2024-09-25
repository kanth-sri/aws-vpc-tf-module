locals {
  resource_name = "${var.project}-${var.environmnet}"
  AZ_names = data.aws_availability_zones.AZ.names
}