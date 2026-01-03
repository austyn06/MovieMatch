variable "region" {
  description = "AWS Region where resources will be deployed"
  type = string
}

variable "repository" {
  description = "GitHub Repository URL for the application"
  type = string
}

variable "branch_name" {
  description = "Git Branch to deploy from"
  type = string
}

variable "access_token" {
  description = "GitHub Token for AWS Amplify integration"
  type = string
  sensitive = true
}

variable "tmdb_api_key" {
  description = "TMDB API key for fetching movie data"
  type = string
  sensitive = true
}
