resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = var.iam_instance_profile
  key_name               = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install ansible2 -y

              cd /home/ec2-user
              git clone ${var.repo_url}
              cd IAC-terraform-and-ansible
              ansible-playbook -i ${var.inventory_rel_path} ansible/playbooks/aws/deploy.yaml
              EOF

  tags = var.tags_ansible_core
}
