resource "aws_launch_template" "main" {
  name = "${var.component}-${var.env}"
  image_id = data.aws_ami.ami.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.main.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.main.name
  }

  instance_market_options {
    market_type = "spot"
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.tags, { Name = "${var.component}-${var.env}" }
    )
  }

  user_data = base64encode(templatefile("${path.module}/userdata.sh", {
    component = var.component
    env = var.env
  } ))
}

resource "aws_autoscaling_group" "main" {
  name = "${var.component}-${var.env}"
  desired_capacity   = var.desired_capacity
  max_size           = var.max_size
  min_size           = var.min_size
  vpc_zone_identifier = var.subnets

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    propagate_at_launch = false
    value               = "${var.component}-${var.env}"
  }
}

resource "aws_security_group" "main" {
  name        = "${var.component}-${var.env}"
  description = "${var.component}-${var.env}"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags, { Name = "${var.component}-${var.env}" }
  )
}

resource "aws_vpc_security_group_ingress_rule" "ingress1" {
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = var.bastion_cidr
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "ingress2" {
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = var.allow_app_to
  from_port         = var.port
  ip_protocol       = "tcp"
  to_port           = var.port
}

resource "aws_vpc_security_group_egress_rule" "egress" {
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
