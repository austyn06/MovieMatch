resource "random_string" "suffix" {
  length  = 6
  upper   = false
  lower   = true
  numeric  = true
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

  auto_verified_attributes = ["email"]

  email_verification_message = "Your verification code is {####}"
  email_verification_subject = "Please Verify Your Email"

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }
}

resource "aws_cognito_user_pool_client" "app_client" {
  name            = "example-app-client-${random_string.suffix.result}"
  user_pool_id    = aws_cognito_user_pool.user_pool.id
  generate_secret = false

  allowed_oauth_flows  = ["code"]
  allowed_oauth_scopes = ["email", "openid", "profile"]
  callback_urls        = [local.amplify_app_url]
  logout_urls          = [local.amplify_app_url]

  allowed_oauth_flows_user_pool_client = true
  supported_identity_providers         = ["COGNITO"]
}

resource "aws_cognito_user_pool_domain" "user_pool_domain" {
  domain       = "swenteam7domain-${random_string.suffix.result}"
  user_pool_id = aws_cognito_user_pool.user_pool.id
}
