data "aws_ami" "ami" {
  most_recent = true
  name_regex  = "centos8-ansible"
  owners      = ["self"]
}

data "aws_caller_identity" "account" {}

data "aws_route53_zone" "domain" {
  name = var.dns_domain
}