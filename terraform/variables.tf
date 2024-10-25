variable "aws_region" {
    description = "The AWS region to deploy resources"
    type = string
    default = "us-east-1"
}

variable "tmdb_api_key" {
    type = string
    description = "The API key for The Movie Database"
    default = "805e414f9ae84a75b0cf3d95476e199a"
}