resource "aws_instance" "ansible_controller" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = true
  tags                        = var.tags

  user_data = <<-EOF
#!/bin/bash
set -e
dnf -y update
dnf -y install ansible-core git

mkdir -p /opt/ansible
cd /opt/ansible

cat > inventory.ini <<'INV'
[all]
TARGET_IP ansible_user=ec2-user
INV

cat > playbook.yml <<'PLY'
- hosts: all
  gather_facts: false
  tasks:
    - name: Ping
      ansible.builtin.ping:
PLY

ansible -i inventory.ini -m ping all || true
ansible-playbook -i inventory.ini playbook.yml || true
EOF
}
