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
