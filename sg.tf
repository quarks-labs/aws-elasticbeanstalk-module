resource "aws_security_group" "this" {
  name        = lower("${var.name}-${random_string.sufix.result}")
  description = lower("${var.name}-${random_string.sufix.result}")
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "this" {
  for_each = { for idx, role in [
    {
      type        = "egress",
      description = "Allow all egress",
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "ingress",
      description = "Allow all egress",
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }] : idx => role }

  type              = try(each.value.type, "egress")
  description       = try(each.value.description, "Allow all egress traffic")
  from_port         = try(each.value.from_port, 0)
  to_port           = try(each.value.to_port, 0)
  protocol          = try(each.value.protocol, "-1")
  cidr_blocks       = try(each.value.cidr_blocks, (each.value.self ? [] : ["0.0.0.0/0"]))
  security_group_id = join("", aws_security_group.this[*].id)
}
