module "vpc" {
  source = "./modules/VPC"

  name = "ansible"

  vpc_region        = "${var.vpc_region}"
  allowed_ip        = "${var.allowed_ip}"
  cidr              = "${var.vpc_cidr}"
  public_subnets    = ["${var.public_subnets}"]
  private_subnets   = ["${var.private_subnets}"]
  rds_subnets       = ["${var.rds_subnets}"]
  availability_zone = ["${split(",", lookup(var.availability_zone, var.vpc_region["primary"]))}"]

  bastion_count     = "${var.bastion["count"]}"
  instance_type     = "${var.bastion["instance_type"]}"
  bastion_keypair   = "${var.key_name}"
  bastion_key       = "${var.key_path}"
}

module "Ansible" {
  source = "./modules/Ansible"

  name   = "ansibleServer"

  vpc_region        = "${var.vpc_region}"
  private_subnets   = "${module.vpc.private_subnets}"
  private_sg        = "${module.vpc.private_security_group_id}"
  rds_sg            = "${module.vpc.RDS_security_group_id}"
  bastion_ip        = "${module.vpc.bastion_host_ip}"
  count             = "${var.ansible_server["count"]}"
  instance_type     = "${var.ansible_server["instance_type"]}"
  keypair           = "${var.key_name}"
  key_path          = "${var.key_path}"

}

module "s3-bucket" {
  source = "./modules/S3"

  name   = "TFstate"

  vpc_region  = "${var.vpc_region}"
  s3 = "${var.s3}"
}

data "terraform_remote_state" "tf-state" {
    backend = "s3"
    config {
        bucket = "${var.s3["bucket_name"]}"
        key = "terraform.tfstate"
        region = "us-east-1"
    }
}
