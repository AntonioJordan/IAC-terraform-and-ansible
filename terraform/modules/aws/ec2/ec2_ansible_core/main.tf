resource "aws_instance" "ansible_controller" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  iam_instance_profile        = var.iam_instance_profile  # perfil con ssm:StartSession, ec2:Describe*, logs:Describe*
  key_name                    = var.key_name
  associate_public_ip_address = true
  tags                        = var.tags_ansible_core

  user_data = <<'EOF'
#!/bin/bash
set -euxo pipefail

REGION="${REGION_OVERRIDE:-__REGION__}"
REGION="${REGION//__REGION__/__REGION__}" # noop if sed replaces below
export AWS_DEFAULT_REGION="${REGION}"

# Detect pkg mgr
if command -v dnf >/dev/null 2>&1; then PM=dnf; elif command -v yum >/dev/null 2>&1; then PM=yum; elif command -v apt-get >/dev/null 2>&1; then PM=apt; else PM=unknown; fi

# Base deps
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

# Session Manager Plugin (controller requirement)
ARCH="$(uname -m)"
if [ "$PM" = "apt" ]; then
  case "$ARCH" in
    x86_64|amd64)  URL="http://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" ;;
    aarch64|arm64) URL="http://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_arm64/session-manager-plugin.deb" ;;
    *)             URL="http://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" ;;
  esac
  curl -fsSL "$URL" -o /tmp/session-manager-plugin.deb
  dpkg -i /tmp/session-manager-plugin.deb || apt-get -y -f install
else
  case "$ARCH" in
    x86_64|amd64)  URL="http://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_amd64/session-manager-plugin.rpm" ;;
    aarch64|arm64) URL="http://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_arm64/session-manager-plugin.rpm" ;;
    *)             URL="http://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_amd64/session-manager-plugin.rpm" ;;
  esac
  curl -fsSL "$URL" -o /tmp/session-manager-plugin.rpm
  rpm -Uvh --replacepkgs /tmp/session-manager-plugin.rpm || true
fi
session-manager-plugin --version

# Checkout de tu repo
mkdir -p /opt/ansible
cd /opt/ansible
if [ ! -d IAC-terraform-and-ansible ]; then
  git clone https://github.com/AntonioJordan/IAC-terraform-and-ansible.git
fi
cd IAC-terraform-and-ansible

# Colecciones necesarias
cat > requirements.yml <<'YML'
collections:
  - name: amazon.aws
  - name: community.aws
YML
ansible-galaxy collection install -r requirements.yml

# ansible.cfg apuntando a tu inventario dinámico EC2
cat > ansible.cfg <<'CFG'
[defaults]
inventory = ./ansible/inventories/aws/dev/aws_ec2.yaml
host_key_checking = False
interpreter_python = auto_silent
retry_files_enabled = False

[inventory]
enable_plugins = amazon.aws.aws_ec2
CFG

# Variables globales para conexión SSM
mkdir -p ansible/group_vars
cat > ansible/group_vars/all.yml <<YML
ansible_connection: aws_ssm
ansible_region: ${AWS_DEFAULT_REGION}
YML

# Calentar inventario y ejecutar
ansible-inventory --graph
if [ -f ansible/playbooks/site.yml ]; then
  ansible-playbook ansible/playbooks/site.yml
elif [ -f ansible/playbook.yml ]; then
  ansible-playbook ansible/playbook.yml
else
  ansible -m ping all
fi
EOF

  # Sustituir región en user_data sin here-doc runtime hacks
  provisioner "local-exec" {
    when    = create
    command = "true"
  }
}
