

# Cognito User Pool
resource "aws_cognito_user_pool" "user_pool" {
  name = "example-user-pool"

  # Policies for password requirements
  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  # Optional email configuration
  auto_verified_attributes = ["email"]

  # Verification message templates
  email_verification_message = "Your verification code is {####}"
  email_verification_subject = "Please Verify Your Email"
  
  # Account recovery settings
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }
}

# Cognito User Pool Client
resource "aws_cognito_user_pool_client" "app_client" {
  name            = "example-app-client"
  user_pool_id    = aws_cognito_user_pool.user_pool.id
  generate_secret = false

  # Enable sign-in and sign-up flows
  allowed_oauth_flows                   = ["code"]
  allowed_oauth_scopes                  = ["email", "openid", "profile"]
  callback_urls                         = ["https://${aws_amplify_app.amplify_app.id}.amplifyapp.com/"]
  logout_urls                           = ["https://${aws_amplify_app.amplify_app.id}.amplifyapp.com/"]

  # Enable authorization code grant flow for authentication
  allowed_oauth_flows_user_pool_client  = true
  supported_identity_providers          = ["COGNITO"]
}

# Cognito User Pool Domain
resource "aws_cognito_user_pool_domain" "user_pool_domain" {
  domain       = "swenteam7domain" 
  user_pool_id = aws_cognito_user_pool.user_pool.id
}
