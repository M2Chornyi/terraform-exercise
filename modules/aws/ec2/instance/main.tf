resource "aws_instance" "web" {
  for_each               = toset( var.instance_names )
  ami                    = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  tags                   = merge(var.tags,{ Name = each.key })
  vpc_security_group_ids = var.security_groups
  user_data              = var.user_data
}

variable "server_type" {
  default = "web"
}
variable "instance_names" {
  default = ["web1"]
}
variable "image_id" {
  default = "ami-0bbfeb6eccdd084e1"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "key_name" {
  default = "m2c.class3"
}
variable "security_groups" {type = list(string)}
variable "tags" {
  default = {}
}
variable "user_data" {
  default = ""
}
output "instances" {
  value = aws_instance.web
}
