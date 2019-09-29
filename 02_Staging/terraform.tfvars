account_prefix = "jerryhire8test1"

application_name = "personalWebsiteBackendStaging"

# The full uri will be  https://api-staging.yuriiulianets.dev/webSiteBackend
domain_name = "yuriiulianets.dev"
subdomain_name = "api-staging"
gateway_path_part = "webSiteBackend"

lambda_entry_point = "personalWebsiteBackend::personalWebsiteBackend.RequestHandler::HandleRequest"


# Source for CI/CD
github_location = "https://github.com/YuriU/personalWebsiteBackend.git"
github_location_branch = "dev"