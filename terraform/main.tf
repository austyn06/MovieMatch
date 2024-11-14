terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# locals {
#   amplify_app_url = "https://${aws_amplify_branch.main.branch_name}.${aws_amplify_app.amplify_app.default_domain}"
# }

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