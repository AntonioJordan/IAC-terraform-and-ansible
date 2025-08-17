resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = var.iam_instance_profile
  key_name               = var.key_name

user_data = <<-EOF
            #!/bin/bash
            set -eux

            # Actualizar sistema
            sudo yum update -y

            # Instalar dependencias base
            sudo yum install -y git python3 python3-pip amazon-ssm-agent

            # Habilitar y arrancar SSM Agent
            sudo systemctl enable amazon-ssm-agent
            sudo systemctl start amazon-ssm-agent

            # Instalar ansible-core desde pip (última versión estable)
            sudo pip3 install --upgrade pip
            sudo pip3 install ansible-core

            # Instalar colección AWS y dependencias Python
            sudo ansible-galaxy collection install amazon.aws
            sudo pip3 install boto3 botocore

            # Clonar tu repositorio
            cd /home/ec2-user
            sudo git clone ${var.repo_url}
            cd IAC-terraform-and-ansible

            # Ejecutar playbook
            sudo ansible-playbook -i ${var.inventory_rel_path} ansible/playbooks/aws/deploy.yaml
            EOF

  tags = var.tags_ansible_core
}
