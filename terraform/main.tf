terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 3.0"
        }
    }
}

provider "aws" {
    region = var.aws_region
}

resource "aws_instance" "movie-recommendation-system" {
    ami = ""
    instance_type = "t2.micro"
    key_name = "group-keypair"
    tags = {
        Name = "movie-recommendation-system"
    }
}

resource "aws_amplify_app" "amplify-app" {
    name = "movie-recommendation-system"
    repository = "https://github.com/SWEN-514-FALL-2024/term-project-team7.git"

    build_spec = <<-EOF
        version: 0.1
        frontend:
        phases:
            preBuild:
            commands:
                - npm install
            build:
            commands:
                - npm run build
        artifacts:
            baseDirectory: dist
            files:
            - '**/*'
        cache:
            paths:
            - node_modules/**/*
    EOF

    custom_rule {
        source = "/<*>"
        target = "/index.html"
        status = 200
    }
}

resource "aws_amplify_branch" "main" {
    app_id = aws_amplify_app.amplify-app.id
    branch_name = "main"
}

resource "aws_secretsmanager_secret" "tmdb_api_key" {
    name = "tmdb_api_key"
    description = "API key for The Movie Database"
}

resource "aws_secretsmanager_secret_version" "tmdb_api_key_version" {
    secret_id = aws_secretsmanager_secret.tmdb_api_key.id
    secret_string = var.tmdb_api_key
}