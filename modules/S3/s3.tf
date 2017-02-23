resource "aws_s3_bucket" "tf-state-s3" {
    bucket = "${var.s3["bucket_name"]}"
    acl = "private"
    versioning {
        enabled = "${var.s3["versioning"]}"
    }

    lifecycle_rule {
        prefix = ""
        enabled = "${var.s3["lifecycle"]}"

        transition {
            days = "${var.s3["trans_days"]}"
            storage_class = "STANDARD_IA"
        }

        expiration {
            days = "${var.s3["expire_days"]}"
        }
    }

    tags {
        Name = "terraform-state-bucket-test"
    }
}
