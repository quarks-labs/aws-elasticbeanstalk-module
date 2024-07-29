variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "cert_manager" {
  type = list(object({
    domain_name       = string
    validation_method = string
    tags              = map(string)
  }))
}

variable "custom_settings" {
  type = list(object({
    resource  = optional(string)
    namespace = string
    name      = string
    value     = string
  }))
}

variable "wait_for_ready_timeout" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "solution_stack_name" {
  type = string
}
