output "amplify_app__url" {
  value       = "https://${aws_amplify_branch.main.branch_name}.${aws_amplify_app.amplify_app.default_domain}"
  description = "The URL of the Amplify app"
}
