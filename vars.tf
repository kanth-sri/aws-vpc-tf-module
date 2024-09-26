variable "vpc_cidr" {
  type = string
}
#optional 
variable "common_tags" {
    default={}
  
}
variable "vpc_tags" {
    default = {}
  
}
variable "project" {
    type = string
}
variable "environment" {
  type = string
}
variable "ipv4_public_cidr_blocks" {
  type = list
  validation {
        condition = length(var.ipv4_public_cidr_blocks) == 2
        error_message = "Please provide 2 valid public subnet CIDR"
    }
}
variable "subnet_tags" {
  default = {}
}
variable "privatesubnet_ipv4_cidr_blocks" {
  type = list
  validation {
        condition = length(var.privatesubnet_ipv4_cidr_blocks) == 2
        error_message = "Please provide 2 valid public subnet CIDR"
    }
}
variable "dbsubnet_ipv4_cidr_blocks" {
  type = list
  validation {
        condition = length(var.dbsubnet_ipv4_cidr_blocks) == 2
        error_message = "Please provide 2 valid public subnet CIDR"
    }
}
variable "is_peering_required" {
  default = false
}