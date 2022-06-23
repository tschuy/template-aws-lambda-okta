terraform {
  backend "s3" {
    encrypt = true
    bucket  = ""
    region  = "us-west-2"
    key     = "indent/terraform.tfstate"
  }

}

# Indent + Okta Integration

# Details: https://github.com/indentapis/integrations/tree/a939937164de9a5a4cba72b71f70c9966b5f53d5/packages/stable/indent-integration-okta
# Last Change: https://github.com/indentapis/integrations/commit/a939937164de9a5a4cba72b71f70c9966b5f53d5

module "idt-okta-webhook" {
  source                = "git::https://github.com/indentapis/integrations//terraform/modules/indent_runtime_aws_lambda"
  name                  = "idt-okta-webhook"
  indent_webhook_secret = var.indent_webhook_secret
  artifact = {
    bucket       = "indent-artifacts-us-west-2"
    function_key = "webhooks/aws/lambda/okta-a939937164de9a5a4cba72b71f70c9966b5f53d5-function.zip"
    deps_key     = "webhooks/aws/lambda/okta-a939937164de9a5a4cba72b71f70c9966b5f53d5-deps.zip"
  }
  env = {
    OKTA_DOMAIN       = var.okta_domain
    OKTA_TOKEN        = var.okta_token
    OKTA_SLACK_APP_ID = var.okta_slack_app_id
    OKTA_CLIENT_ID    = var.okta_client_id
    OKTA_PRIVATE_KEY  = var.okta_private_key
  }
}

