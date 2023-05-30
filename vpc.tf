# Create VPC
resource "aws_vpc" "kubernetes_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "kubernetes-vpc"
  }
}

# Create Subnet
resource "aws_subnet" "kubernetes_subnet" {
  vpc_id            = aws_vpc.kubernetes_vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.subnet_availability_zone

  tags = {
    Name = "kubernetes-subnet"
  }
}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.kubernetes_vpc.id
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.kubernetes_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example.id
  }
}

resource "aws_route_table_association" "example" {
  subnet_id      = aws_subnet.kubernetes_subnet.id
  route_table_id = aws_route_table.example.id
}
