resource "null_resource" "inventory_creation" {
  depends_on = [
    aws_instance.kubernetes_master,
    aws_instance.kubernetes_node1,
    aws_instance.kubernetes_node2
  ]

  provisioner "local-exec" {
    command = <<-EOT
      sudo -S sh -c 'cat <<EOF > /etc/ansible/hosts
      kubernetes-master ansible_host=${aws_instance.kubernetes_master.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=/root/poc.keypair.pem ansible_ssh_extra_args="-o StrictHostKeyChecking=accept-new"
      kubernetes-node1 ansible_host=${aws_instance.kubernetes_node1.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=/root/poc.keypair.pem ansible_ssh_extra_args="-o StrictHostKeyChecking=accept-new"
      kubernetes-node2 ansible_host=${aws_instance.kubernetes_node2.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=/root/poc.keypair.pem ansible_ssh_extra_args="-o StrictHostKeyChecking=accept-new"
      EOF'
    EOT
  }
}
