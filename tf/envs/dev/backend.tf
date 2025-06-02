terraform {
  backend "s3" {
    bucket       = "terraform-state-20251421"
    key          = "dev/terraform.tfstate"
    region       = "us-east-2"
    encrypt      = true
    use_lockfile = true
  }
}
