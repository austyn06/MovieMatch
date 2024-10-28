resource "aws_amplify_app" "amplify_app" {
  name         = "movie-recommendation-system"
  repository   = var.repository

  access_token = var.github_token
  enable_branch_auto_build = true


  build_spec = <<-YAML
    version: 0.1
    frontend:
      phases:
        preBuild:
          commands:
            - cd movie-recommendation
            - npm ci --include=dev
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: ./movie-recommendation/dist
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  YAML

  custom_rule {
    source = "/<*>"
    target = "/index.html"
    status = 200
  }

  environment_variables = {
    TMDB_API_KEY = var.tmdb_api_key
  }
}

resource "aws_amplify_branch" "main" {
  app_id            = aws_amplify_app.amplify_app.id
  branch_name       = var.branch_name
  enable_auto_build = true
}
