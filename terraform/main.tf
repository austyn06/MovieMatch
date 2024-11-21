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
  
resource "aws_secretsmanager_secret" "github_token" {
  name                    = "github_token"
  description             = "GitHub token for Amplify"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "github_token_version" {
  secret_id     = aws_secretsmanager_secret.github_token.id
  secret_string = var.github_token
}

resource "aws_secretsmanager_secret" "tmdb_api_key" {
  name                    = "tmdb_api_key"
  description             = "API key for The Movie Database"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "tmdb_api_key_version" {
  secret_id     = aws_secretsmanager_secret.tmdb_api_key.id
  secret_string = var.tmdb_api_key
}

resource "local_file" "envfile" {
  filename = "${path.module}/../.env"
  content  = templatefile("${path.module}/envfile.tpl", {
    VITE_AWS_REGION           = var.aws_region
    VITE_USER_POOL_ID         = aws_cognito_user_pool.user_pool.id
    VITE_USER_POOL_CLIENT_ID  = aws_cognito_user_pool_client.app_client.id
    VITE_COGNITO_DOMAIN       = aws_cognito_user_pool_domain.user_pool_domain.domain
    VITE_AMPLIFY_APP_URL      = local.amplify_app_url
    VITE_API_GATEWAY_URL      = aws_api_gateway_deployment.deployment.invoke_url
    VITE_TMDB_API_KEY         = var.tmdb_api_key
  })
}