# VPC variables

variable "name" {}

variable "keypair" {}

variable "key_path" {}

variable "vpc_region" {
  type = "map"

  default = {
    primary = "us-east-1"
    backup  = "us-west-2"
  }
}

variable "ami" {
  type = "map"

  default = {
    us-east-1 = "ami-6edd3078"
    us-west-2 = "ami-7c803d1c"
  }
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "private_sg" {
  type = "string"
}

variable "rds_sg" {
  type = "string"
}

variable "bastion_ip" {
  type = "list"
}

variable "private_subnets" {
  type = "list"
}

variable "instance_type" {
  type = "string"
  default = "t2.micro"
}

variable "count" {
  type = "string"
  default = 1
}

variable "ansible_inventory" {
  description = "1 if dynamic inventory is true"

  type = "map"

  default = {
    dynamic_inventory = 1
    static_inventory  = 0
  }
}
