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

            # Instalar dependencias base y toolchain para compilar Python
            yum install -y git gcc gcc-c++ make wget tar \
              openssl-devel bzip2 bzip2-devel libffi-devel zlib-devel amazon-ssm-agent

            # Habilitar y arrancar SSM Agent
            systemctl enable amazon-ssm-agent
            systemctl start amazon-ssm-agent

            # Compilar e instalar Python 3.9
            cd /usr/src
            wget https://www.python.org/ftp/python/3.9.16/Python-3.9.16.tgz
            tar xzf Python-3.9.16.tgz
            cd Python-3.9.16
            ./configure --enable-optimizations
            make altinstall

            # Instalar ansible-core y dependencias en Python 3.9
            /usr/local/bin/python3.9 -m ensurepip
            /usr/local/bin/python3.9 -m pip install --upgrade pip
            /usr/local/bin/python3.9 -m pip install "ansible-core>=2.14,<2.17" boto3 botocore

            # Añadir /usr/local/bin al PATH
            echo 'export PATH=/usr/local/bin:$PATH' >> /etc/profile
            export PATH=/usr/local/bin:$PATH

            # Instalar colección AWS
            /usr/local/bin/ansible-galaxy collection install amazon.aws

            # Clonar repositorio
            cd /home/ec2-user
            git clone ${var.repo_url}
            cd IAC-terraform-and-ansible

            # Ejecutar playbook
            /usr/local/bin/ansible-playbook -i ${var.inventory_rel_path} ansible/playbooks/aws/deploy.yaml
            EOF

  tags = var.tags_ansible_core
}
