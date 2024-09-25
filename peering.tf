resource "aws_vpc_peering_connection" "peer" {
  count = var.is_peering_required ? 1 : 0
  peer_vpc_id   = data.aws_vpc.default.id #acceptor id
  vpc_id        = aws_vpc.main.id #requester id
  auto_accept   = true

  tags = merge(
    var.common_tags,
    {
        Name = "${local.resource_name}-peer-default"
    }
  )
}
resource "aws_route" "public_peer" {
  count = var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer[count.index].id
}
resource "aws_route" "private_peer" {
  count = var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.private_nat.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer[count.index].id
}
resource "aws_route" "db_peer" {
  count = var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.DB_nat.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer[count.index].id
}
resource "aws_route" "default_peer" {
  count = var.is_peering_required ? 1 : 0
  route_table_id            = data.aws_vpc.default.main_route_table_id
  destination_cidr_block    = var.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer[count.index].id
}
