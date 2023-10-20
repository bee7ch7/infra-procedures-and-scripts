locals {
  environment_config = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  environment        = local.environment_config.locals.environment
  region             = local.environment_config.locals.aws_region
  domain_name        = local.environment_config.locals.domain_name
}

remote_state {
  backend = "s3"
  generate = {
    path      = "_backend.tf"
    if_exists = "overwrite"
  }

  config = {
    bucket  = "${local.environment}-tfstates.home-iac"
    key     = "${path_relative_to_include()}/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

inputs = {
  aws_region  = local.region
  environment = local.environment
}

generate "myconfig" {
  path      = "_config.tf"
  if_exists = "overwrite"

  contents = <<EOF
provider "aws" {
    region = "${local.region}"
    default_tags {
        tags = {
            Company     = "Test Inc."
            Terraform   = "True"
            Project     = "home"
            Environment = "${local.environment}"
        }
    }
}

provider "aws" {
    region = "us-east-1"
    alias  = "acm"

    default_tags {
        tags = {
            Company    = "Test Inc."
            Terraform  = "True"
            Project    = "home"
            Environment = "${local.environment}"
        }
    }
}
EOF
}

terraform {
  extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()

    // required_var_files = [
    //   find_in_parent_folders("common.tfvars")
    // ]
  }
}
