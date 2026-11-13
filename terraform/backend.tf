
terraform {
  backend "s3" {
    key          = "java-aws-devops-challenge/terraform.tfstate"
    region       = "us-east-2"
    encrypt      = true
    use_lockfile = true
  }
}
