data "aws_acm_certificate" "web_site_certificate" {
  domain   = "${var.subdomain_name}.${var.domain_name}"
  statuses = ["ISSUED"]
}

resource "aws_api_gateway_domain_name" "gateway_domain" {
  regional_certificate_arn  = "${data.aws_acm_certificate.web_site_certificate.arn}"
  domain_name               = "${var.subdomain_name}.${var.domain_name}"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

data "aws_route53_zone" "web_site_zone" {
  name         = "${var.domain_name}"
  private_zone = false
}

resource "aws_route53_record" "gateway_record" {
  name    = "${aws_api_gateway_domain_name.gateway_domain.domain_name}"
  type    = "A"
  zone_id = "${data.aws_route53_zone.web_site_zone.id}"

  alias {
    evaluate_target_health = true
    name                   = "${aws_api_gateway_domain_name.gateway_domain.regional_domain_name}"
    zone_id                = "${aws_api_gateway_domain_name.gateway_domain.regional_zone_id}"
  }
}


resource "aws_api_gateway_base_path_mapping" "root_mapping" {
  api_id      = "${var.api_gateway_id}"
  stage_name  = "${var.api_deployment_stage}"
  domain_name = "${aws_api_gateway_domain_name.gateway_domain.domain_name}"
}