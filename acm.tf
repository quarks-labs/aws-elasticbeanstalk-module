resource "aws_acm_certificate" "certificate" {
  for_each = { for idx, certificate in var.cert_manager : idx =>  certificate}
  domain_name       = try(each.value.domain, "")
  validation_method = try(each.value.validation_method, "DNS")
  key_algorithm = try(each.value.key_algorithm, "RSA_2048")
  tags = try(each.value.tags, {})
}