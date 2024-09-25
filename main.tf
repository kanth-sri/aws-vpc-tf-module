#Creating a VPC
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = merge(var.common_tags,
  var.vpc_tags,
  {
    Name = local.resource_name
  }
  )
}
#Ingernet gateway creation
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

 tags = merge(var.common_tags,
  {
    Name = local.resource_name
  }
  )
}
#creating two public subnets in two AZ's
resource "aws_subnet" "public" {
  count = length(var.ipv4_public_cidr_blocks)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.ipv4_public_cidr_blocks[count.index]
  availability_zone = local.AZ_names[count.index]
  map_public_ip_on_launch = true
  tags = merge(var.common_tags,
  var.subnet_tags,
  {
    Name = "${local.resource_name}-public-${local.AZ_names[count.index]}"
  }
  )
}
#creating two private subnets in two AZ's
resource "aws_subnet" "private" {
  count = length(var.privatesubnet_ipv4_cidr_blocks)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.privatesubnet_ipv4_cidr_blocks[count.index]
  availability_zone = local.AZ_names[count.index]
  tags = merge(var.common_tags,
  {
    Name = "${local.resource_name}-private-${local.AZ_names[count.index]}"
  }
  )
}
#creating two database subnets in two AZ's
resource "aws_subnet" "database" {
  count = length(var.dbsubnet_ipv4_cidr_blocks)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.dbsubnet_ipv4_cidr_blocks[count.index]
  availability_zone = local.AZ_names[count.index]
  tags = merge(var.common_tags,
  {
    Name = "${local.resource_name}-database-${local.AZ_names[count.index]}"
  }
  )
}
#creating database subnet group
resource "aws_db_subnet_group" "default" {
  name       = local.resource_name
  subnet_ids = aws_subnet.database[*].id

  tags = {
    Name = "${local.resource_name}-dbgroup"
  }
}
#elastic ip
resource "aws_eip" "nat" {
  domain   = "vpc"
}
#creating natgateway in public subnet in 1a-AZ
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name =  "${local.resource_name}-natgw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}
#creating public route table and routes
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${local.resource_name}-public"
    }
  )
}
#creating private route table and routes
resource "aws_route_table" "private_nat" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${local.resource_name}-private"
    }
  )
}
#creating DB route table and routes
resource "aws_route_table" "DB_nat" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${local.resource_name}-DB"
    }
  )
}
#Associating public subents to public route table
resource "aws_route_table_association" "public" {
  count = length(var.ipv4_public_cidr_blocks)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
#Associating private subents to private route table
resource "aws_route_table_association" "private" {
  count = length(var.privatesubnet_ipv4_cidr_blocks)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_nat.id
}
#Associating DB subents to DB route table
resource "aws_route_table_association" "DB" {
  count = length(var.dbsubnet_ipv4_cidr_blocks)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.DB_nat.id
}