resource "aws_vpc_peering_connection" "example" {
  peer_vpc_id                     = vpc-03da39a4f5ea08dab
  vpc_id                          = aws_vpc.kubernetes_vpc.id
  auto_accept                     = false
  allow_remote_vpc_dns_resolution = true
  allow_classic_link_to_remote_vpc = false
}
