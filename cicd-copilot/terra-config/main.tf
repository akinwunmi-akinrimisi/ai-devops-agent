provider "aws" {
  region = "us-east-1"
}

variable "openrouter_api_key" {
  description = "OpenRouter API Key"
  type        = string
  sensitive   = true
}

resource "aws_secretsmanager_secret" "openrouter_api_key" {
  name        = "openrouter-api-key-copilot"
  description = "OpenRouter API key for cicd-ai-copilot"
}

resource "aws_secretsmanager_secret_version" "openrouter_api_key_value" {
  secret_id = aws_secretsmanager_secret.openrouter_api_key.id
  secret_string = jsonencode({
    OPENROUTER_API_KEY = var.openrouter_api_key
  })
}

resource "aws_lambda_function" "cicd-ai-copilot" {
  function_name    = "cicd-ai-copilot"
  filename         = "lambda.zip"
  source_code_hash = filebase64sha256("lambda.zip")
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.11"
  role             = aws_iam_role.lambda_role.arn
  timeout          = 60

  depends_on = [
    aws_secretsmanager_secret_version.openrouter_api_key_value,
    aws_iam_role_policy_attachment.lambda_secrets_attach,
    aws_iam_role_policy_attachment.basic_logs
  ]
}
