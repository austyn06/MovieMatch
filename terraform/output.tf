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