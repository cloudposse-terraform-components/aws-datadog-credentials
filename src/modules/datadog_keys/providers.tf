provider "aws" {
  region = module.datadog_configuration.outputs.region
  alias  = "dd_api_keys"

  # Profile is deprecated in favor of terraform_role_arn. When profiles are not in use, terraform_profile_name is null.
  profile = module.iam_roles.terraform_profile_name

  dynamic "assume_role" {
    # module.iam_roles.terraform_role_arn may be null, in which case do not assume a role.
    for_each = compact([module.iam_roles.terraform_role_arn])
    content {
      role_arn = assume_role.value
    }
  }
}

module "iam_roles" {
  source  = "github.com/cloudposse-terraform-components/aws-account-map//src/modules/iam-roles?ref=v1.535.4"
  context = module.this.context
}
