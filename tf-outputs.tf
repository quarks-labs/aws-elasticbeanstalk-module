output "name" {
    value = aws_elastic_beanstalk_application.this.name
}

output "endpoint_url" {
    value = aws_elastic_beanstalk_environment.this.endpoint_url
}

output "arn" {
    value = aws_elastic_beanstalk_environment.this.arn
}
