output "certificate_arn" {
  value = "${aws_acm_certificate_validation.web_site_certificate_validation.0.certificate_arn}"
}
