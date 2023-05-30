# Create EC2 Instances for Kubernetes master and worker nodes
resource "aws_instance" "kubernetes_master" {
  ami                          = var.ami_id
  instance_type                = var.instance_type
  key_name                     = var.ssh_key_name
  subnet_id                    = aws_subnet.kubernetes_subnet.id
  vpc_security_group_ids       = [aws_security_group.kubernetes_sg.id]
  associate_public_ip_address  = true

  tags = {
    Name = "kubernetes-master"
  }
}

resource "aws_instance" "kubernetes_node1" {
  ami                          = var.ami_id
  instance_type                = var.instance_type
  key_name                     = var.ssh_key_name
  subnet_id                    = aws_subnet.kubernetes_subnet.id
  vpc_security_group_ids       = [aws_security_group.kubernetes_sg.id]
  associate_public_ip_address  = true

  tags = {
    Name = "kubernetes-node1"
  }
}

resource "aws_instance" "kubernetes_node2" {
  ami                          = var.ami_id
  instance_type                = var.instance_type
  key_name                     = var.ssh_key_name
  subnet_id                    = aws_subnet.kubernetes_subnet.id
  vpc_security_group_ids       = [aws_security_group.kubernetes_sg.id]
  associate_public_ip_address  = true

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
