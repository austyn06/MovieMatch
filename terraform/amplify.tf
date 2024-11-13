resource "aws_amplify_app" "amplify_app" {
  name       = "movie-recommendation-system"
  repository = var.repository

  access_token             = var.github_token
  enable_branch_auto_build = true


  build_spec = <<-YAML
    version: 0.1
    frontend:
      phases:
        preBuild:
          commands:
            - npm ci
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
      environment:
        variables:
          VITE_AWS_REGION: $AWS_REGION
          VITE_AMPLIFY_APP_URL: $AMPLIFY_APP_URL
          VITE_API_GATEWAY_URL: $API_GATEWAY_URL
          VITE_TMDB_API_KEY: $TMDB_API_KEY
  YAML

  custom_rule {
    source = "</*>"
    target = "/index.html"
    status = 200
  }

  environment_variables = {
    VITE_AWS_REGION = var.aws_region
    # VITE_USER_POOL_ID        = aws_cognito_user_pool.user_pool.id
    # VITE_USER_POOL_CLIENT_ID = aws_cognito_user_pool_client.user_pool_client.id
    # VITE_COGNITO_DOMAIN      = var.cognito_domain
    VITE_AMPLIFY_APP_URL = local.amplify_app_url
    VITE_API_GATEWAY_URL = aws_api_gateway_deployment.deployment.invoke_url
    VITE_TMDB_API_KEY    = var.tmdb_api_key
  }
}

resource "aws_amplify_branch" "main" {
  app_id            = aws_amplify_app.amplify_app.id
  branch_name       = var.branch_name
  enable_auto_build = true
}

resource "null_resource" "trigger_amplify_deployment" {
  depends_on = [aws_amplify_branch.main]

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "aws amplify start-job --app-id ${aws_amplify_app.amplify_app.id} --branch-name ${aws_amplify_branch.main.branch_name} --job-type RELEASE"
  }
}
