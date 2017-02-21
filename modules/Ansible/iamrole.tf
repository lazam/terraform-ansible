resource "aws_iam_role_policy" "passrole_policy" {
	name = "passrole_policy"
	role = "${aws_iam_role.acs_iam.name}"
	policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "NotAction": "iam:*",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "iam:PassRole",
      "Resource": "arn:aws:iam::aws:policy/PowerUserAccess"
    }
  ]
}
EOF
}

resource "aws_iam_role" "acs_iam" {
	name = "ansible_server_iam"
	assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ansible_profile" {
  name = "ansible_profile"
	roles = ["${aws_iam_role.acs_iam.name}"]
}
