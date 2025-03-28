#Bloque de config 
terraform {
  backend "s3" {
    bucket         = "bucket-de-tf"
    region         = "us-east-1"
    encrypt = false
    # encrypt = true
    # kms_key_id = "arn:aws:kms:us-east-1:650251708051:key/953aac6b-e3b5-4892-bc53-ef2ffc2a1ca7"  # ARN de tu clave KMS
  }
}
