# Indent + AWS Lambda and Okta

This repository contains an integration between Okta and [Indent](https://indent.com). Once deployed, you will be able to use this integration with Indent to:

- PullUpdate
- ApplyUpdate

## Quicklinks

- [Indent Documentation Index](https://indent.com/docs)
- [Indent Support](https://support.indent.com)

## Configuration

Before you deploy these webhooks for the first time, [create an S3 bucket](https://docs.aws.amazon.com/AmazonS3/latest/userguide/create-bucket-overview.html) to store Terraform state, add your credentials as [GitHub Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets), then update the bucket in `main.tf` once you're done.

<details><summary><strong>1. Configuring the S3 bucket</strong></summary>
<p>

- [Go to AWS S3](https://s3.console.aws.amazon.com/s3/buckets) and select an existing bucket or create a new one.
- Select the settings given your environment:
  - Name — easily identifiable name for the bucket (example = indent-deploy-state-123)
  - Region — where you plan to deploy the Lambda (default = us-west-2)
  - Bucket versioning — if you want to have revisions of past deployments (default = disabled)
  - Default encryption — server-side encryption for deployment files (default = Enable)

</p>
</details>

<details><summary><strong>2. Configuring AWS credentials</strong></summary>
<p>

- [Go to AWS IAM → New User](https://console.aws.amazon.com/iam/home#/users$new?step=details) and create a new user for deploys, e.g. `indent-terraform-deployer`
- Configure the service account access:
  - Credential type — select **Access key - Programmatic access**
  - Permissions — select **Attach existing policies directly** and select `AdministratorAccess`
- Add the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` as GitHub Secrets to this repo

</p>
</details>

<details><summary><strong>3. Connecting to Okta</strong></summary>

- [Go to Okta > Security > API > Tokens](https://help.okta.com/en-us/Content/Topics/Security/API.htm#create-okta-api-token) and create a new API Token, then give the token a descriptive name like `Indent Auto Approvals`
- Add this as `OKTA_TOKEN` as a GitHub Secret
- Copy your Okta Domain URL and add this as `OKTA_DOMAIN` as a GitHub Secret

</details>

<details><summary><strong>4. Connecting to Indent</strong></summary>

- If you're setting up as part of a catalog flow, you should be presented a **Webhook Secret** or [go to your Indent space and create a webhook](https://indent.com/spaces?next=/manage/spaces/[space]/webhooks/new)
- Add this as `INDENT_WEBHOOK_SECRET` as a GitHub Secret

</details>

<details><summary><strong>5. Deploy</strong></summary>

- Enter the bucket you created in `main.tf` in the `backend` configuration
- This will automatically kick off a deploy, or you can [manually trigger from GitHub Actions](./actions/workflows/terraform.yml)

</details>

### Actions secrets

Visit <a href="https://indent.com/docs/webhooks/deploy/okta-groups#create-a-new-repository" target="_blank">this link</a> to our documentation for information on setting up GitHub Secrets in this repository.

## Deployment

This repository auto-deploys to AWS Lambda when you push or merge PRs to the `main` branch. You can manually redeploy the webhooks by re-running the [latest GitHub Action job](https://docs.github.com/en/actions/managing-workflow-runs/re-running-workflows-and-jobs).
