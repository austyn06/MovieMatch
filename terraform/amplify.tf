resource "aws_amplify_app" "amplify_app" {
  name                     = "movie-recommendation-system"
  repository               = var.repository
  access_token             = var.access_token
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
  YAML

  custom_rule {
    source = "</*>"
    target = "/index.html"
    status = "404-200"
  }

  custom_rule {
    source = "</^[^.]+$|\\.(?!(css|gif|ico|jpg|js|png|txt|svg|woff|woff2|ttf|map|json|webp|html|xml|webmanifest|mp4)$)([^.]+$)/>"
    target = "/index.html"
    status = "200"
  }
}

resource "aws_amplify_branch" "main" {
  app_id            = aws_amplify_app.amplify_app.id
  branch_name       = var.branch_name
  enable_auto_build = true

  environment_variables = {
    VITE_AWS_REGION          = var.region
    VITE_USER_POOL_ID        = aws_cognito_user_pool.user_pool.id
    VITE_USER_POOL_CLIENT_ID = aws_cognito_user_pool_client.app_client.id
    VITE_COGNITO_DOMAIN      = aws_cognito_user_pool_domain.user_pool_domain.domain
    VITE_AMPLIFY_APP_URL     = local.amplify_app_url
    VITE_API_GATEWAY_URL     = aws_apigatewayv2_stage.default.invoke_url
  }
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