data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "default" {
  name        = var.name
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port        = var.from_port
    to_port          = var.to_port
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 3389
    to_port          = 3389
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = merge( var.tags, { Name = var.name } )
}
variable "name" { default = "web" }
variable "tags" {}
variable "from_port" { default = 80 }
variable "to_port" { default = 80 }


output "security_group_id" {
  value = aws_security_group.default.id
}