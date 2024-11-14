output "amplify_app_url" {
  value =  "https://${aws_amplify_branch.main.branch_name}.${aws_amplify_app.amplify_app.default_domain}/"
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