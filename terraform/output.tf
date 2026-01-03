output "amplify_app_url" {
  value =  local.amplify_app_url
}

output "user_pool_id" {
  value = aws_cognito_user_pool.user_pool.id
} 

output "user_pool_client_id" {
  value = aws_cognito_user_pool_client.app_client.id
}

output "user_pool_domain" {
  value = aws_cognito_user_pool_domain.user_pool_domain.domain
}

output "VITE_AWS_REGION" {
  value = var.region
}

output "VITE_USER_POOL_ID" {
  value = aws_cognito_user_pool.user_pool.id
}

output "VITE_USER_POOL_CLIENT_ID" {
  value = aws_cognito_user_pool_client.app_client.id
}

output "VITE_COGNITO_DOMAIN" {
  value = aws_cognito_user_pool_domain.user_pool_domain.domain
}

output "VITE_AMPLIFY_APP_URL" {
  value = local.amplify_app_url
}

output "VITE_API_GATEWAY_URL" {
  value = aws_api_gateway_stage.prod.invoke_url
}