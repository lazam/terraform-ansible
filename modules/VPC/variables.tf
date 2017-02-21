# VPC variables

variable "vpc_region" {
  type = "map"

  default = {
    primary = "us-east-1"
    backup  = "us-west-2"
  }
}

variable "name" {}

variable "cidr"  {}

variable "allowed_ip"  {
  type = "list"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "public_subnets" {
  description = "List of public subnets"
  default = []
}

variable "private_subnets" {
  description = "List of private subnets"
  default = []
}

variable "rds_subnets" {
  description = "List of RDS subnets"
  default = []
}

variable "availability_zone" {
  description = "List of AZs"
  default = []
}


# Bastion Variables

variable "instance_type" {
  type = "string"
  default = "t2.micro"
}

variable "bastion_count" {
  type = "string"
  default = 1
}

variable "bastion_ami" {
  type = "map"

  default = {
    us-east-1 = "ami-6edd3078"
    us-west-2 = "ami-7c803d1c"
  }
}

variable "bastion_keypair" {}

variable "bastion_key" {}
