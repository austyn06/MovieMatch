resource "random_string" "suffix" {
  length  = 6
  upper   = false
  lower   = true
  numeric = true
  special = false
}

resource "aws_cognito_user_pool" "user_pool" {
  name = "example-user-pool-${random_string.suffix.result}"

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  mfa_configuration = "OFF"

  # Disable all verification requirements
  username_attributes      = ["email"]
  auto_verified_attributes = []

  # Skip email verification
  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  # Add this to automatically confirm users without verification
  lambda_config {
    pre_sign_up = aws_lambda_function.auto_confirm_user.arn
  }
}

resource "aws_cognito_user_pool_client" "app_client" {
  name            = "example-app-client-${random_string.suffix.result}"
  user_pool_id    = aws_cognito_user_pool.user_pool.id
  generate_secret = false

  # Add these settings to skip verification
  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]

  # Disable any verification requirements
  prevent_user_existence_errors = "ENABLED"

  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
  callback_urls                        = [local.amplify_app_url]
  logout_urls                          = [local.amplify_app_url]
  allowed_oauth_flows_user_pool_client = true
  supported_identity_providers         = ["COGNITO"]
}

resource "aws_cognito_user_pool_domain" "user_pool_domain" {
  domain       = "swenteam7domain-${random_string.suffix.result}"
  user_pool_id = aws_cognito_user_pool.user_pool.id
}

# Add a Lambda function to auto-confirm users
resource "aws_lambda_function" "auto_confirm_user" {
  filename      = "auto_confirm.zip"
  function_name = "auto-confirm-user"
  role          = aws_iam_role.cognito_lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
}