output "bucket_name" {
  value = aws_s3_bucket.movie_data.bucket
}

output "amplify_app_url" {
  value = "https://${aws_amplify_branch.main.branch_name}.${aws_amplify_app.amplify_app.default_domain}"
}