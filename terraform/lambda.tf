data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_code/tmdb_fetcher.py"
  output_path = "${path.module}/lambda_package/lambda_function.zip"
}

resource "aws_lambda_function" "tmdb_fetcher" {
  filename      = data.archive_file.lambda_zip.output_path
  function_name = "tmdb_fetcher"
  handler       = "tmdb_fetcher.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_role.arn
  timeout       = 60
  publish       = true

  environment {
    variables = {
      TMDB_SECRET_NAME  = aws_secretsmanager_secret.tmdb_api_key.name
      MOVIE_DATA_BUCKET = aws_s3_bucket.movie_data.bucket
      NEPTUNE_ENDPOINT  = aws_neptune_cluster.neptune_cluster.endpoint
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_policy_attachment
  ]
}

resource "aws_cloudwatch_event_rule" "lambda_schedule" {
  name                = "tmdb_fetcher_schedule"
  schedule_expression = "rate(1 day)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.lambda_schedule.name
  target_id = "tmdb_fetcher"
  arn       = aws_lambda_function.tmdb_fetcher.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tmdb_fetcher.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_schedule.arn
}