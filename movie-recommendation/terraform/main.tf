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