resource "aws_vpc_peering_connection" "VPC-peering" {
  peer_vpc_id = "vpc-03da39a4f5ea08dab"
  vpc_id      = aws_vpc.kubernetes_vpc.id
  auto_accept = false
}
