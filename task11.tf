provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  region = "us-east-2"
}

resource "aws_default_vpc" "main" {}

resource "aws_default_subnet" "2a" {
  availability_zone = "us-east-2a"
}
resource "aws_default_subnet" "2b" {
  availability_zone = "us-east-2b"
}

resource "aws_security_group" "lb" {
  name = "lb"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "nodes" {
  name = "nodes"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = ["${aws_security_group.lb.id}"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "lc" {
  name = "lc"
  image_id = "${lookup(var.amis,var.region)}"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.nodes.id}"]
  key_name = "${var.key_name}"
  user_data = <<-EOF
              #!/bin/bash
              echo "$(hostname -f)" > index.html
              nohup busybox httpd -f -p 80 &
              EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name = "asg"
  launch_configuration = "${aws_launch_configuration.lc.id}"
  vpc_zone_identifier = ["${aws_default_subnet.2a.id}","${aws_default_subnet.2b.id}"]
  target_group_arns = ["${aws_lb_target_group.frontend.id}"]
  min_size = 2
  max_size = 3
  health_check_grace_period = 30
  health_check_type = "ELB"
  force_delete = true
}

resource "aws_lb" "frontend" {
  name = "frontend"
  internal = false
  load_balancer_type = "application"
  security_groups = ["${aws_security_group.lb.id}"]
  subnets = ["${aws_default_subnet.2a.id}","${aws_default_subnet.2b.id}"]
}

resource "aws_lb_target_group" "frontend" {
  name = "frontend"
  port = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id = "${aws_default_vpc.main.id}"
}

resource "aws_lb_listener" "frontend" {
  load_balancer_arn = "${aws_lb.frontend.arn}"
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = "${aws_lb_target_group.frontend.arn}"
  }
}