output "amplify-app-url" {
  value = aws_amplify_app.amplify-app.default_domain
  description = "The URL of the Amplify app"
}