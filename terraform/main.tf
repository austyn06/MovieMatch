terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

locals {
  amplify_app_url = format("https://%s.%s.amplifyapp.com", var.branch_name, aws_amplify_app.amplify_app.id)
}

resource "local_file" "envfile" {
  filename = "${path.module}/../.env"
  content  = templatefile("${path.module}/envfile.tpl", {
    VITE_AWS_REGION           = var.region
    VITE_USER_POOL_ID         = aws_cognito_user_pool.user_pool.id
    VITE_USER_POOL_CLIENT_ID  = aws_cognito_user_pool_client.app_client.id
    VITE_COGNITO_DOMAIN       = aws_cognito_user_pool_domain.user_pool_domain.domain
    VITE_AMPLIFY_APP_URL      = local.amplify_app_url
    VITE_API_GATEWAY_URL      = aws_api_gateway_stage.prod.invoke_url
  })
}