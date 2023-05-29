provider "aws" {
  region = "us-east-1"
}

# Create VPC
resource "aws_vpc" "kubernetes_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "kubernetes-vpc"
  }
}

# Create Subnet
resource "aws_subnet" "kubernetes_subnet" {
  vpc_id     = aws_vpc.kubernetes_vpc.id
  cidr_block = "10.0.1.0/24" 
  availability_zone = "us-east-1a" 

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

# Create Security Group for Kubernetes nodes
resource "aws_security_group" "kubernetes_sg" {
  vpc_id = aws_vpc.kubernetes_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "kubernetes-security-group"
  }
}


# Create EC2 Instances for Kubernetes master and worker nodes
resource "aws_instance" "kubernetes_master" {
  ami           = "ami-007855ac798b5175e"  # Replace with your desired AMI ID
  instance_type = "t2.medium"  # Replace with your desired instance type
  key_name      = "poc.keypair"  # Replace with your desired SSH key pair name
  subnet_id     = aws_subnet.kubernetes_subnet.id
  vpc_security_group_ids = [aws_security_group.kubernetes_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "kubernetes-master"
  }
}

resource "aws_instance" "kubernetes_node1" {
  ami           = "ami-007855ac798b5175e"  # Replace with your desired AMI ID
  instance_type = "t2.medium"  # Replace with your desired instance type
  key_name      = "poc.keypair"  # Replace with your desired SSH key pair name
  subnet_id     = aws_subnet.kubernetes_subnet.id
  vpc_security_group_ids = [aws_security_group.kubernetes_sg.id]
  associate_public_ip_address = true
  tags = {
    Name = "kubernetes-node1"
  }
}

resource "aws_instance" "kubernetes_node2" {
  ami           = "ami-007855ac798b5175e"  # Replace with your desired AMI ID
  instance_type = "t2.medium"  # Replace with your desired instance type
  key_name      = "poc.keypair"  # Replace with your desired SSH key pair name
  subnet_id     = aws_subnet.kubernetes_subnet.id
  vpc_security_group_ids = [aws_security_group.kubernetes_sg.id]
  associate_public_ip_address = true
  tags = {
    Name = "kubernetes-node2"
  }
}

output "kubernetes_master" {
  value = aws_instance.kubernetes_master.public_ip
}

output "kubernetes_node1" {
  value = aws_instance.kubernetes_node1.public_ip
}

output "kubernetes_node2" {
  value = aws_instance.kubernetes_node2.public_ip
}

resource "null_resource" "inventory_creation" {

    depends_on = [
      aws_instance.kubernetes_master,
      aws_instance.kubernetes_node1,
      aws_instance.kubernetes_node2
    ]

provisioner "local-exec" {
  command = <<EOT
sudo -S sh -c 'cat <<EOF > /etc/ansible/hosts
kubernetes-master ansible_host=${aws_instance.kubernetes_master.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=/root/poc.keypair.pem ansible_ssh_extra_args="-o StrictHostKeyChecking=accept-new"
kubernetes-node1 ansible_host=${aws_instance.kubernetes_node1.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=/root/poc.keypair.pem ansible_ssh_extra_args="-o StrictHostKeyChecking=accept-new"
kubernetes-node2 ansible_host=${aws_instance.kubernetes_node2.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=/root/poc.keypair.pem ansible_ssh_extra_args="-o StrictHostKeyChecking=accept-new"
EOF'
    EOT
  }
}
