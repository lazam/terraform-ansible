variable "name" {}

variable "vpc_region" {
  type = "map"

  default = {
    primary = "us-east-1"
    backup  = "us-west-2"
  }
}

variable "s3" {
   type = "map"

   default = {
       bucket_name = "terraform-state-bucket-test"
       versioning  = true
       trans_days  = 90
       expire_days = 180
       lifecycle   = true
   }
}
