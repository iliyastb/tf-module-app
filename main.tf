resource "aws_launch_template" "main" {
  name = "${var.component}-${var.env}"
  image_id = data.aws_ami.ami.id
  instance_type = var.instance_type

#  iam_instance_profile {
#    name = "test"
#  }

  instance_market_options {
    market_type = "spot"
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.tags, { Name = "${var.component}-${var.env}" }
    )
  }

#  user_data = filebase64("${path.module}/example.sh")
}