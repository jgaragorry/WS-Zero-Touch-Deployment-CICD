terraform {
  backend "s3" {
    bucket       = "aws-cicd-w4-state-533267117128"
    key          = "cicd/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
