resource "aws_secretsmanager_secret" "openrouter_api_key" {
  name        = "openrouter-api-key-review"
  description = "OpenRouter API key for Terraform AI Review Agent"
}

resource "aws_secretsmanager_secret_version" "openrouter_api_key_value" {
  secret_id = aws_secretsmanager_secret.openrouter_api_key.id
  secret_string = jsonencode({
    OPENROUTER_API_KEY = var.openrouter_api_key
  })
}
