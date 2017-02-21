variable "aws_profile" {}

variable "access_key" {}

variable "secret_key" {}

variable "key_name" {}

variable "key_path" {}

variable "allowed_ip" {
  type        = "list"
  description = "Your IP"
}

variable "vpc_region" {
  type = "map"

  default = {
    primary = "us-east-1"
    backup  = "us-west-2"
  }
}

variable "vpc_cidr" {
    description = "AWS VP CIDR"
    default  = "10.1.0.0/16"
}

variable "availability_zone" {
    type = "map"

  default = {
    us-east-1 = "us-east-1b,us-east-1d,us-east-1e"
    us-west-2 = "us-west-2d,us-west-2b,us-west-2c"
  }
}

variable "public_subnets" {
    type = "list"

    default = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
}

variable "private_subnets" {
    type = "list"

    default = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]
}

variable "rds_subnets" {
    type = "list"

    default = ["10.1.7.0/24", "10.1.8.0/24", "10.1.9.0/24"]
}



variable "bastion" {
  type = "map"

  default = {
    instance_type = "t2.micro"
    count         = 1
  }
}

variable "ansible_server" {
  type = "map"

  default = {
    instance_type     = "t2.micro"
    count             = 1
  }
}
