terraform {
  backend {
    encrypt = true
    bucket  = ""
    region  = "us-west-2"
    key     = "indent/terraform.tfstate"
  }
}

module "idt-okta-webhook" {
  source                = "git::https://github.com/indentapis/integrations//terraform/modules/indent_runtime_aws_lambda"
  name                  = "idt-okta-webhook"
  indent_webhook_secret = var.indent_webhook_secret
  artifact = {
    artifactBucket = "indent-artifacts-us-west-2"
    functionKey    = "webhooks/aws/lambda/okta-v0.0.1-canary-function.zip"
    depsKey        = "webhooks/aws/lambda/okta-v0.0.1-canary-deps.zip"
  }
  env = {
    OKTA_DOMAIN       = var.okta_domain
    OKTA_TOKEN        = var.okta_token
    OKTA_SLACK_APP_ID = var.okta_slack_app_id
    OKTA_CLIENT_ID    = var.okta_client_id
    OKTA_PRIVATE_KEY  = var.okta_private_key
  }
}

variable "aws_region" {
  type    = string
  default = ""
}

variable "aws_profile" {
  type    = string
  default = ""
}

variable "indent_webhook_secret" {
  type      = string
  sensitive = true
}

variable "OKTA_DOMAIN" {
  type      = string
  default   = ""
  sensitive = true
}

variable "OKTA_TOKEN" {
  type      = string
  default   = ""
  sensitive = true
}

variable "OKTA_SLACK_APP_ID" {
  type      = string
  default   = ""
  sensitive = true
}

variable "OKTA_CLIENT_ID" {
  type      = string
  default   = ""
  sensitive = true
}

variable "OKTA_PRIVATE_KEY" {
  type      = string
  default   = ""
  sensitive = true
}

output "idt-okta-webhook-url" {
  value       = "module.idt-okta-webhook.function_url"
  description = "The URL of the deployed Lambda"
}

