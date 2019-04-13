provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  region = "us-east-2"
}

data "aws_availability_zones" "all" {}

resource "aws_security_group" "nodes" {
  name = "nodes"
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    security_groups = ["${aws_security_group.elb.id}"]
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
              nohup busybox httpd -f -p 8080 &
              EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name = "asg"
  launch_configuration = "${aws_launch_configuration.lc.id}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  min_size = 3
  max_size = 5
  load_balancers = ["${aws_elb.lb.name}"]
  health_check_type = "ELB"
  tag {
    key = "Name"
    value = "node"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "elb" {
  name = "elb"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "lb" {
  name = "lb"
  security_groups = ["${aws_security_group.elb.id}"]
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 10
    target = "HTTP:8080/"
  }
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "8080"
    instance_protocol = "http"
  }
}