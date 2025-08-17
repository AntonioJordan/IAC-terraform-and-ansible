resource "aws_iam_role" "ansible_core_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Políticas mínimas:
# - SSM Session Manager (acceso remoto seguro sin SSH público)
# - S3 (descarga playbooks, roles, etc.)
# - KMS (desencriptar secretos si usas aws_kms_ciphertext)
resource "aws_iam_role_policy" "ansible_core_policy" {
  name = "${var.role_name}-policy"
  role = aws_iam_role.ansible_core_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "kms:Decrypt"
        ]
        Resource = var.kms_key_arn
      }
    ]
  })
}

# Adjunta la policy oficial de SSM, necesaria para que la instancia se registre en Session Manager
resource "aws_iam_role_policy_attachment" "ansible_core_ssm" {
  role       = aws_iam_role.ansible_core_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance profile para vincular el rol a la instancia EC2
resource "aws_iam_instance_profile" "ansible_core_profile" {
  name = var.instance_profile_name
  role = aws_iam_role.ansible_core_role.name
}
