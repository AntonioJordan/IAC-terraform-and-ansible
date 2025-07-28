terraform {
  backend "s3" {
    bucket  = "toni-bootstrap-tfstate-us-west-2"   # nombre real del bucket creado
    key     = "dev/terraform.tfstate"              # ruta lógica del state
    region  = "us-west-2"
    encrypt = true
  }
}
