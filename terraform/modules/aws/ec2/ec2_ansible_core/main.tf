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

            # Esperar red antes de instalar / clonar
            until ping -c1 github.com &>/dev/null; do
              sleep 5
            done

            # Actualizar sistema
            yum update -y

            # Instalar dependencias base
            yum install -y git python3 python3-pip amazon-ssm-agent

            # Habilitar y arrancar SSM Agent
            systemctl enable amazon-ssm-agent
            systemctl start amazon-ssm-agent

            # Instalar ansible-core desde pip (última versión estable)
            pip3 install --upgrade pip
            pip3 install ansible-core

            # Instalar colección AWS y dependencias Python
            ansible-galaxy collection install amazon.aws
            pip3 install boto3 botocore
            export PATH=$PATH:/usr/local/bin

            # Clonar repositorio
            cd /home/ec2-user
            git clone ${var.repo_url}
            cd IAC-terraform-and-ansible

            # Ejecutar playbook
            ansible-playbook -i ${var.inventory_rel_path} ansible/playbooks/aws/deploy.yaml
            EOF

  tags = var.tags_ansible_core
}
