locals {
  environment = "${basename(get_terragrunt_dir())}"
  aws_region  = "eu-central-1"
  domain_name = "test.com"
}
