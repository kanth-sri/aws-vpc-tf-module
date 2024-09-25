data "aws_availability_zones" "AZ" {
  state = "available"
}
data "aws_vpc" "default" {
  default = true
}