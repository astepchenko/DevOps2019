output "lb_dns_name" {
  value = "${aws_lb.frontend.dns_name}"
}