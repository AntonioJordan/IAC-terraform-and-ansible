output "ansible_controller_id"         { value = aws_instance.ansible_controller.id }
output "ansible_controller_public_ip"  { value = aws_instance.ansible_controller.public_ip }
output "ansible_controller_private_ip" { value = aws_instance.ansible_controller.private_ip }
output "ansible_controller_public_dns" { value = aws_instance.ansible_controller.public_dns }
output "ansible_controller_az"         { value = aws_instance.ansible_controller.availability_zone }
output "iam_instance_profile_used"     { value = var.iam_instance_profile }
