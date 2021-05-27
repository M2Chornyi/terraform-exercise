terraform {
  required_version = "~> 0.15.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "terraform-backend-tf03172021"
    key = "terraform/stack01"
    region = "us-east-1"
  }
}
provider "aws" {
  region = "us-east-1"
}
data "aws_ami" "windows_2016" {
  most_recent = true
  filter {
    name   = "name"
    values = ["Windows_Server-2016-English-Full-Base-2021*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon"] # Canonical
}
data "aws_ami" "linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.20210427.0-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon"] # Canonical
}
data "aws_vpc" "default" {
  default = true
}
data "aws_subnet_ids" "default"{
  vpc_id = data.aws_vpc.default.id
}

module "AWS_VPC" {
  source = "./modules/aws/vpc/security_group"
  tags = {}
}

module "AWS_EC2_windows" {
  source = "./modules/aws/ec2/instance"
  instance_names = ["web1","web2"]
  instance_type = "t2.micro"
  image_id = data.aws_ami.windows_2016.id
  key_name = "m2c.class3"
  security_groups = [module.AWS_VPC.security_group_id]
  tags = {}
  depends_on = [module.AWS_VPC.security_group_id]
  user_data = templatefile("./modules/aws/ec2/instance/user_data/linux.sh",{} )
}
module "AWS_EC2_linux" {
  source = "./modules/aws/ec2/instance"
  instance_names = ["green","dot","rocks"]
  instance_type = "t2.micro"
  image_id = data.aws_ami.linux.id
  key_name = "m2c.class3"
  security_groups = [module.AWS_VPC.security_group_id]
  tags = {}
  depends_on = [module.AWS_VPC.security_group_id]
  user_data = templatefile("./modules/aws/ec2/instance/user_data/linux.sh",{} )
}
module "AWS_EC2_elb" {
  source = "./modules/aws/ec2/elb"
  security_groups = [module.AWS_VPC.security_group_id]
  tags = {}
  instances = concat (
    tolist([ for instance in module.AWS_EC2_windows.instances: instance.id]),
    tolist([ for instance in module.AWS_EC2_linux.instances: instance.id])
  )
  }

output "security_group" {
  value = module.AWS_VPC.security_group_id
}
