resource "aws_instance" "ansible_controller" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = var.iam_instance_profile
  key_name               = var.key_name
  associate_public_ip_address = true
  tags                   = var.tags_ansible_core

  user_data = <<-EOF
#!/bin/bash
set -euxo pipefail
export AWS_DEFAULT_REGION="${var.region}"

# Paquetes base
if command -v dnf >/dev/null 2>&1; then PM=dnf; elif command -v yum >/dev/null 2>&1; then PM=yum; else PM=apt; fi
if [ "$PM" = "apt" ]; then
  apt-get update -y
  DEBIAN_FRONTEND=noninteractive apt-get install -y python3 python3-pip git curl unzip awscli
else
  $PM -y update || true
  $PM -y install python3 python3-pip git curl unzip awscli || true
fi

# Ansible + boto
python3 -m pip install --upgrade pip
python3 -m pip install --upgrade ansible-core boto3 botocore

# SSM plugin
ARCH="$(uname -m)"
if [ "$PM" = "apt" ]; then
  case "$ARCH" in x86_64|amd64) U="http://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" ;; aarch64|arm64) U="http://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_arm64/session-manager-plugin.deb" ;; *) U="http://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" ;; esac
  curl -fsSL "$U" -o /tmp/ssm.deb && dpkg -i /tmp/ssm.deb || apt-get -y -f install
else
  case "$ARCH" in x86_64|amd64) U="http://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_amd64/session-manager-plugin.rpm" ;; aarch64|arm64) U="http://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_arm64/session-manager-plugin.rpm" ;; *) U="http://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_amd64/session-manager-plugin.rpm" ;; esac
  curl -fsSL "$U" -o /tmp/ssm.rpm && rpm -Uvh --replacepkgs /tmp/ssm.rpm || true
fi

# Repo
mkdir -p /opt/ansible && cd /opt/ansible
test -d IAC-terraform-and-ansible || git clone "${var.repo_url}"
cd IAC-terraform-and-ansible

# Ansible cfg + colecciones + SSM connection
cat > ansible.cfg <<CFG
[defaults]
inventory = ./${var.inventory_rel_path}
host_key_checking = False
interpreter_python = auto_silent
retry_files_enabled = False
[inventory]
enable_plugins = amazon.aws.aws_ec2
CFG

cat > requirements.yml <<YML
collections:
  - name: amazon.aws
  - name: community.aws
YML
ansible-galaxy collection install -r requirements.yml

mkdir -p ansible/group_vars
cat > ansible/group_vars/all.yml <<YML
ansible_connection: aws_ssm
ansible_region: ${var.region}
YML

# KMS (opcional)
BLOB="$(printf "%s" "${var.ansible_secret_blob}")"
if [ -n "$BLOB" ]; then
  echo "$BLOB" | base64 -d >/tmp/blob.bin
  SECRET=$(aws kms decrypt --region ${var.region} --ciphertext-blob fileb:///tmp/blob.bin --query Plaintext --output text | base64 -d)
  printf "%s" "$SECRET" > /root/.ansible_secret
fi

# Prueba
ansible-inventory --graph || true
ansible -m ping all || true
EOF
}
