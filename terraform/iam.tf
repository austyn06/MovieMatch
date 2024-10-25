resource "aws_iam_role" "lambda_role" {
    name = "tmdb_lambda_role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect    = "Allow"
            Principal = {
                Service = "lambda.amazonaws.com"
            }
            Action = "sts:AssumeRole"
        }]
    })
}


resource "aws_iam_policy" "lambda_policy" {
    name = "lambda_policy"
    description = "Policy for the lambda function"
    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect   = "Allow"
                Action   = "secretsmanager:GetSecretValue"
                Resource = aws_secretsmanager_secret.tmdb_api_key.arn
            },
            {
                Effect = "Allow",
                Action = [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ],
                Resource = "*"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = aws_iam_policy.lambda_policy.arn
}