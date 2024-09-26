# AWS VPC Custome Module

This module is going to create the following resources. for HA we are going to get first 2 AZ.

* VPC
* Internet Gateway associated with VPC
* 2 Public Subnets
* 2 Private Subnets
* 2 Database Subnets
* Database subnet group
* EIP
* NAT Gateway
* Public Route table
* Private Route table
* Database Route table
* Routes
* Route table associations with subnets
* Peering with default VPC(if Required)
* Peering routes in acceptor and requestor route tables
# Inputs
* project_name (Mandatory): User must supply their project name.
* environment (Mandatory): User must supply their environment name.
* vpc_cidr (Mandatory): User must supply their VPC CIDR.
* common_tags (Optional): Default is empty. User can supply tags in map(string) format.
* vpc_tags (Optional): Default is empty. User can supply tags in map(string) format.
* ipv4_public_cidr_blocks (Mandatory): User must supply only 2 valid public subnet CIDR.
* subnet_tags (Optional): Default is empty. User can supply tags in map(string) format.
* privatesubnet_ipv4_cidr_blocks (Mandatory): User must supply only 2 valid private subnet CIDR.
* dbsubnet_ipv4_cidr_blocks (Mandatory): User must supply only 2 valid database subnet CIDR.
* is_peering_required (Optional): defaults to false

# OUTPUTS

* vpc_id : vpc id created
* public_subnet_ids : list of 2 public subnet ids
* private_subnet_ids : list of 2 private subnet ids
* db_subnet_ids : list of 2 db subnet ids