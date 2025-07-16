data "aws_ami" "ami" {
  most_recent = true
  name_regex  = "centos-8-with-ansible"
  owners      = ["self"]

  filter {
    name   = "centos8"
    values = ["centos-*"]
  }
}

data "aws_caller_identity" "account" {}

data "aws_route53_zone" "domain" {
  name = var.dns_domain
}