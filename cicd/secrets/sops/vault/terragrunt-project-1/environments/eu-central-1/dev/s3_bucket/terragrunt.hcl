include "root" {
  path = find_in_parent_folders()
}

locals {
  environment_config = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  environment        = local.environment_config.locals.environment
  region             = local.environment_config.locals.aws_region
  domain_name        = local.environment_config.locals.domain_name

  facebook_id = yamldecode(sops_decrypt_file("${get_parent_terragrunt_dir()}/${local.region}/${local.environment}/secrets/facebook_creds.yaml")).client_id
  facebook_secret = yamldecode(sops_decrypt_file("${get_parent_terragrunt_dir()}/${local.region}/${local.environment}/secrets/facebook_creds.yaml")).client_secret

}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-s3-bucket.git//.?ref=v3.15.1"
}


inputs = {

  bucket = "${local.environment}-cards-${local.facebook_id}-${local.facebook_secret}"
  # acl = "private"

  versioning = {
    status     = true
    mfa_delete = false
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule = [
    {
      id                                     = "NonCurrentVersions"
      enabled                                = true
      abort_incomplete_multipart_upload_days = 7

      noncurrent_version_expiration = {
        days = 30
      }
    }
  ]

  # tags = {
  #   path = get_terragrunt_dir()
  #   parent = get_parent_terragrunt_dir()
  #   original = get_original_terragrunt_dir()

  # }

}