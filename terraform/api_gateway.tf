resource "aws_apigatewayv2_api" "movie_api" {
  name          = "movie-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST", "OPTIONS"]
    allow_headers = ["Content-Type", "Authorization"]
    max_age       = 300
  }
}

resource "aws_apigatewayv2_authorizer" "cognito_authorizer" {
  api_id           = aws_apigatewayv2_api.movie_api.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = "cognito-authorizer"

  jwt_configuration {
    audience = [aws_cognito_user_pool_client.app_client.id]
    issuer   = "https://cognito-idp.${var.region}.amazonaws.com/${aws_cognito_user_pool.user_pool.id}"
  }
}

resource "aws_apigatewayv2_integration" "movies_integration" {
  api_id                 = aws_apigatewayv2_api.movie_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.tmdb_fetcher.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "movies_get" {
  api_id             = aws_apigatewayv2_api.movie_api.id
  route_key          = "GET /movies"
  target             = "integrations/${aws_apigatewayv2_integration.movies_integration.id}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.cognito_authorizer.id
}

resource "aws_apigatewayv2_route" "movies_post" {
  api_id             = aws_apigatewayv2_api.movie_api.id
  route_key          = "POST /movies"
  target             = "integrations/${aws_apigatewayv2_integration.movies_integration.id}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.cognito_authorizer.id
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.movie_api.id
  name        = "$default"
  auto_deploy = true
}