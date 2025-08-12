resource "aws_kms_ciphertext" "ansible_secret" {
  key_id    = var.kms_key_id
  plaintext = var.ansible_secret
}

resource "aws_instance" "ansible_controller" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = var.iam_instance_profile
  tags                   = var.tags
  associate_public_ip_address = true

  user_data = <<-EOF
#!/bin/bash
set -e
dnf -y update
dnf -y install ansible-core git awscli

echo "${aws_kms_ciphertext.ansible_secret.ciphertext_blob}" | base64 -d > /tmp/blob.bin
SECRET=$(aws kms decrypt --region ${var.region} \
 --ciphertext-blob fileb:///tmp/blob.bin \
 --query Plaintext --output text | base64 -d)

mkdir -p /opt/ansible
cd /opt/ansible

cat > inventory.ini <<'INV'
[all]
TARGET_IP ansible_user=ec2-user ansible_password=$SECRET
INV

cat > playbook.yml <<'PLY'
- hosts: all
  gather_facts: false
  tasks:
    - name: Ping
      ansible.builtin.ping:
PLY

ansible-playbook -i inventory.ini playbook.yml || true
EOF
}
