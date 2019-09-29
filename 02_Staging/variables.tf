variable "account_prefix" {
    description = "Used as prefix for S3 bucket creations"
    default = "jerryhire8test1"
}

variable "application_name" {
    description = "Name of the application"
    default = "personalWebsiteBackendStaging"
}

variable "domain_name" {
    description = "Name of the domain"
    default = "yuriiulianets.dev"
}

variable "subdomain_name" {
    description = "Name of the subdomain"
    default = "api-staging"
}

variable "gateway_path_part" {
    description = "Gateway suffix"
    default = "webSiteBackend"
}

variable "lambda_entry_point" {
  description = "Entry point for lambda"
  default = "personalWebsiteBackend::personalWebsiteBackend.RequestHandler::HandleRequest"
}

variable "download_source_default_file_name" {
    description = "Name of the file to download"
}

variable "github_location" {
  description = "Location of sources on Github"
  default = "https://github.com/YuriU/personalWebsiteBackend.git"
}

variable "github_location_branch" {
  description = "Github branch"
  default = "dev"
}

variable "github_access_token" {
  description = "Github access token"
}
