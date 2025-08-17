terraform {
  backend "s3" {
    bucket  = "toni-bootstrap-tfstate-us-east-1"   # nombre real del bucket creado
    key     = "dev/terraform.tfstate"              # ruta lógica del state
    region  = "us-east-1"
    encrypt = true
  }
}
