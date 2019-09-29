variable "account_prefix" {
    description = "Used as prefix for S3 bucket creations"
}

variable "application_name" {
    description = "Name of the application"
}

variable "domain_name" {
    description = "Name of the domain"
    default = "yuriiulianets.dev"
}

variable "subdomain_name" {
    description = "Name of the subdomain"
}

variable "gateway_path_part" {
    description = "Gateway suffix"
}

variable "lambda_entry_point" {
  description = "Entry point for lambda"
}

variable "download_source_default_file_name" {
    description = "Name of the file to download"
}

variable "github_location" {
  description = "Location of sources on Github"
}

variable "github_location_branch" {
  description = "Github branch"
}

variable "github_access_token" {
  description = "Github access token"
}
