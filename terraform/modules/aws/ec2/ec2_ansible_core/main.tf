resource "aws_instance" "ansible_core" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = var.iam_instance_profile
  key_name               = var.key_name

  associate_public_ip_address = false # Subnet privada

  tags = merge(var.tags_ansible_core, {
    Name = "${var.tags_ansible_core["Name"]}-ansible-core"
  })

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras enable ansible2
              yum install -y ansible git
              cd /opt
              git clone ${var.repo_url} ansible-repo
              cd ansible-repo/${var.inventory_rel_path}
              # Placeholder: podrías ejecutar un playbook inicial si quieres
              EOF
}
