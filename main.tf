terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
} 


provider "aws" {
    region = "eu-west-3"

}

#resource "aws_vpc" "myapp-vpc" {
#    cidr_block = var.vpc_cidr_block
#    tags = {
#      Name = "${var.env_prefix}-vpc"
#    }
#}

#module "myapp-subnet" {
#  source = "./modules/subnet"
#  subnet_cidr_block = var.subnet_cidr_block
#  avail_zone = var.avail_zone
#  env_prefix = var.env_prefix
#  vpc_id = aws_vpc.myapp-vpc.id
#  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
  
#}
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = var.vpc_cidr_block

  azs             = [var.avail_zone]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = [var.subnet_cidr_block]

  public_subnet_tags = {
    Name =  "${var.env_prefix}-vpc"
  }

#  enable_nat_gateway = true
#  enable_vpn_gateway = true

  tags = {
    Name = "${var.env_prefix}-vpc"
    
  }
}

module "myapp-server" {
  source = "./modules/webserver"
  vpc_id = module.vpc.vpc_id
  my_ip = var.my_ip
  image_name = var.image_name
  public_key_location = var.public_key_location
  instance_type = var.instance_type
  subnet_id = module.vpc.public_subnets[0]
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix

}

#resource "aws_route_table_association" "a-rtb-subnet" {
#  subnet_id = aws_subnet.myapp-subnet-1.id
#  route_table_id = aws_route_table.myapp-route-table.id  
#}

