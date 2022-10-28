terraform {
  backend "s3" {
    encrypt = true
    bucket  = ""
    region  = "us-west-2"
    key     = "indent/terraform.tfstate"
  }
}

# Configure the Okta Provider
provider "okta" {
  org_name  = var.okta_prefix
  base_url  = "okta.com"
  api_token = var.okta_token
}

# Indent + Okta Integration

# Details: https://github.com/indentapis/integrations/tree/f0cea0e363f8950c7a217d186df6c377ed52e9d7/packages/stable/indent-integration-okta
# Last Change: https://github.com/indentapis/integrations/commit/f0cea0e363f8950c7a217d186df6c377ed52e9d7

module "idt-okta-webhook" {
  source                = "git::https://github.com/indentapis/integrations//terraform/modules/indent_runtime_aws_lambda"
  name                  = "idt-okta-webhook"
  indent_webhook_secret = var.indent_webhook_secret
  artifact = {
    bucket       = "indent-artifacts-us-west-2"
    function_key = "webhooks/aws/lambda/okta-f0cea0e363f8950c7a217d186df6c377ed52e9d7-function.zip"
    deps_key     = "webhooks/aws/lambda/okta-f0cea0e363f8950c7a217d186df6c377ed52e9d7-deps.zip"
  }
  env = {
    OKTA_DOMAIN       = "${var.okta_prefix}.okta.com"
    # OKTA_TOKEN        = var.okta_token
    OKTA_SLACK_APP_ID = var.okta_slack_app_id
    OKTA_CLIENT_ID    = okta_app_oauth.indent.id
    OKTA_PRIVATE_KEY  = file("./private.pem")
  }
}

resource "okta_app_oauth" "indent" {
  label                      = "indent_integration"
  type                       = "service"
  token_endpoint_auth_method = "private_key_jwt"
  grant_types                = ["client_credentials"]
  response_types             = ["token"]
  pkce_required              = true

  jwks {
    kty = "RSA"
    kid = "SIGNING_KEY"
    e   = "AQAB"
    n   = var.okta_jwk_n
  }
}

resource "okta_app_oauth_api_scope" "indent-scopes" {
  app_id = okta_app_oauth.indent.id
  issuer = "https://${var.okta_prefix}.okta.com"
  scopes = ["okta.groups.manage", "okta.users.manage"]
}
