resource "aws_iam_role" "ansible_core" {
  name               = "ansible-core-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_instance_profile" "ansible_core" {
  name = "ansible-core-ec2-profile"
  role = aws_iam_role.ansible_core.name
}

resource "aws_iam_policy" "kms_decrypt" {
  name   = "ansible-core-kms-decrypt"
  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["kms:Decrypt"],
      Resource = var.kms_key_arn
    }]
  })
}

resource "aws_iam_role_policy_attachment" "kms_attach" {
  role       = aws_iam_role.ansible_core.name
  policy_arn = aws_iam_policy.kms_decrypt.arn
}
