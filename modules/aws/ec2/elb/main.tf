data "aws_vpc" "default" {
  default = true
}
data "aws_availability_zones" "default" {
  state = "available"
}

resource "aws_elb" "default" {
  name = "web"
  availability_zones = data.aws_availability_zones.default.names

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 8080
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
  instances                   = var.instances
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400


  tags = merge( var.tags, { } )
  }

variable "security_groups" {type = list(string)}
variable "instances" {type = list(string)}
//variable "target_ids" {}
variable "tags" {}
