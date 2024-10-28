terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# resource "aws_instance" "movie_recommendation_system" {
#     ami = ""
#     instance_type = "t2.micro"
#     key_name = "group-keypair"
#     tags = {
#         Name = "movie-recommendation-system"
#     }
# }

resource "aws_secretsmanager_secret" "github_token" {
  name        = "github_token"
  description = "GitHub token for Amplify"
}

resource "aws_secretsmanager_secret_version" "github_token_version" {
  secret_id     = aws_secretsmanager_secret.github_token.id
  secret_string = var.github_token
}

resource "aws_secretsmanager_secret" "tmdb_api_key" {
  name        = "tmdb_api_key"
  description = "API key for The Movie Database"
}

resource "aws_secretsmanager_secret_version" "tmdb_api_key_version" {
  secret_id     = aws_secretsmanager_secret.tmdb_api_key.id
  secret_string = var.tmdb_api_key
}