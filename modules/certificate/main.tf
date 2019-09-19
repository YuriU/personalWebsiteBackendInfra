
resource "aws_acm_certificate" "web_site_certificate" {
  domain_name       = "${var.subdomain_name}.${var.domain_name}"
  validation_method = "DNS"

  subject_alternative_names = ["${var.subdomain_name}.${var.domain_name}"] 

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "web_site_zone" {
  name         = "${var.domain_name}"
  private_zone = false
}

resource "aws_route53_record" "cert_validation" {
  name     = "${aws_acm_certificate.web_site_certificate.domain_validation_options.0.resource_record_name}"
  type     = "${aws_acm_certificate.web_site_certificate.domain_validation_options.0.resource_record_type}"
  zone_id  = "${data.aws_route53_zone.web_site_zone.zone_id}"
  records  = ["${aws_acm_certificate.web_site_certificate.domain_validation_options.0.resource_record_value}"]
  ttl      = 300
}

resource "aws_acm_certificate_validation" "web_site_certificate_validation" {
  certificate_arn         = "${aws_acm_certificate.web_site_certificate.arn}"
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}