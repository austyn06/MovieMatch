resource "aws_lambda_function" "tmdb_fetcher" {
    function_name = "tmdb_fetcher"
    handler = "index.handler"
    runtime = "nodejs14.x"
    role = aws_iam_policy.lambda_policy.arn

    environment {
        variables = {
            TMDB_API_KEY = aws_secretsmanager_secret.tmdb_api_key.id
        }
    }
}