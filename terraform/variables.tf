variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "repository" {
  description = "github repository"
  type        = string
  default     = "https://github.com/SWEN-514-FALL-2024/term-project-team7"
}

variable "branch_name" {
  description = "repo branch name"
  type        = string
  default     = "main"
}

variable "github_token" {
  description = "github token to connect github repo"
  type        = string
}

variable "tmdb_api_key" {
  type        = string
  description = "api key for TMDB"
  default     = "805e414f9ae84a75b0cf3d95476e199a"
}
