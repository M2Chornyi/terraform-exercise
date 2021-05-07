data "aws_vpc" "default" {
  default = true
}
resource "aws_lb" "web" {
  name               = "web"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnets
  tags               = var.tags
}
resource "aws_lb_target_group" "web" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
  health_check {
    protocol = "HTTP"
    path = "/index.html"
  }
}

resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web.arn
  port = 8080
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

resource "aws_lb_target_group_attachment" "default" {
  for_each = toset(var.target_ids)
  target_group_arn = aws_lb_target_group.web.arn
  target_id = each.key
}

variable "security_groups" {type = list(string)}
variable "subnets" {type = list(string)}
variable "target_ids" {}
variable "tags" {}