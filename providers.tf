provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.vpc_region["primary"]}"
  profile    = "${var.aws_profile}"
}
