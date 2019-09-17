variable "application_name" {
    description = "Name of the application"
    default = "personalWebsiteBackend"
}

variable "download_source_bucket_name" {
    description = "Name of the bucket with sources"
    default = "jerryhire8test1-source-bucket"
}

variable "download_source_default_file_name" {
    description = "Name of the file to download"
}

variable "lambda_name" {
    description = "Name of the lambda function"
    default = "personalWebsiteBackend"
}

variable "issue_certificate" {
    description = "Whether to issue certuificate"
}

variable "domain_name" {
    description = "Name of the domain"
    default = "yuriiulianets.dev"
}

variable "subdomain_name" {
    description = "Name of the subdomain"
    default = "api"
}