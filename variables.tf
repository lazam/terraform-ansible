variable "access_key" {}
variable "secret_key" {}

/* SSH Key Pair */
variable "key_name" {}
variable "key_path" {}

/* Region specific setup */

variable "region" {
    default = {
        "primary" = "us-east-1"
        "backup"  = "us-west-2"
  }
}

variable "insttype" {
    default = {
        utility = "t2.micro"
        client = "t2.micro"
  }
}

variable "ami" {
    default = {
        "us-east-1" = "ami-fce3c696" #Ubuntu AMI
        "us-west-1" = "ami-06116566" #Ubuntu AMI
  }
}
