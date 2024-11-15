resource "aws_api_gateway_rest_api" "movie_api" {
  name = "movie-api"
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.movie_api.id
  stage_name  = "prod"

  depends_on = [
    aws_api_gateway_integration.movies_integration
  ]
}

resource "aws_api_gateway_authorizer" "cognito_authorizer" {
  name            = "cognito-authorizer"
  rest_api_id     = aws_api_gateway_rest_api.movie_api.id
  type            = "COGNITO_USER_POOLS"
  provider_arns   = [aws_cognito_user_pool.user_pool.arn]
  identity_source = "method.request.header.Authorization"
}

# These resources trigger the lambda function
resource "aws_api_gateway_resource" "movies_resource" {
  rest_api_id = aws_api_gateway_rest_api.movie_api.id
  parent_id   = aws_api_gateway_rest_api.movie_api.root_resource_id
  path_part   = "movies"
}

resource "aws_api_gateway_method" "movies_get_method" {
  rest_api_id   = aws_api_gateway_rest_api.movie_api.id
  resource_id   = aws_api_gateway_resource.movies_resource.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

resource "aws_api_gateway_integration" "movies_integration" {
  rest_api_id             = aws_api_gateway_rest_api.movie_api.id
  resource_id             = aws_api_gateway_resource.movies_resource.id
  http_method             = aws_api_gateway_method.movies_get_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.tmdb_fetcher.invoke_arn
}

resource "aws_api_gateway_method_response" "movies_get_method_response" {
  rest_api_id = aws_api_gateway_rest_api.movie_api.id
  resource_id = aws_api_gateway_resource.movies_resource.id
  http_method = aws_api_gateway_method.movies_get_method.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration_response" "movies_get_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.movie_api.id
  resource_id = aws_api_gateway_resource.movies_resource.id
  http_method = aws_api_gateway_method.movies_get_method.http_method
  status_code = aws_api_gateway_method_response.movies_get_method_response.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
  }

  depends_on = [aws_api_gateway_integration.movies_integration]
}

# These resources are for the feedback from the lambda function
resource "aws_api_gateway_resource" "movies_feedback_resource" {
  rest_api_id = aws_api_gateway_rest_api.movie_api.id
  parent_id   = aws_api_gateway_resource.movies_resource.id
  path_part   = "feedback"
}

resource "aws_api_gateway_method" "movies_feedback_post_method" {
  rest_api_id   = aws_api_gateway_rest_api.movie_api.id
  resource_id   = aws_api_gateway_resource.movies_feedback_resource.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

resource "aws_api_gateway_integration" "movies_feedback_integration" {
  rest_api_id             = aws_api_gateway_rest_api.movie_api.id
  resource_id             = aws_api_gateway_resource.movies_feedback_resource.id
  http_method             = aws_api_gateway_method.movies_feedback_post_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.tmdb_fetcher.invoke_arn
}

resource "aws_api_gateway_method_response" "movies_feedback_post_method_response" {
  rest_api_id = aws_api_gateway_rest_api.movie_api.id
  resource_id = aws_api_gateway_resource.movies_feedback_resource.id
  http_method = aws_api_gateway_method.movies_feedback_post_method.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration_response" "movies_feedback_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.movie_api.id
  resource_id = aws_api_gateway_resource.movies_feedback_resource.id
  http_method = aws_api_gateway_method.movies_feedback_post_method.http_method
  status_code = aws_api_gateway_method_response.movies_feedback_post_method_response.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'"
  }

  depends_on = [aws_api_gateway_integration.movies_feedback_integration]
}
