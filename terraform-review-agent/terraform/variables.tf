variable "project_name" {
  type        = string
  default     = "mario-game"
  description = "Name of the project"
}

variable "openrouter_api_key" {
  description = "OpenRouter API Key"
  type        = string
  sensitive   = true
}
