#Bloque de config 
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    region         = "us-east-1"
    encrypt        = true
  }
}
