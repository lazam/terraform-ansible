output "private_subnets" {
  value = ["${aws_subnet.private.*.id}"]
}

output "public_subnets" {
  value = ["${aws_subnet.public.*.id}"]
}

output "rds_subnets" {
  value = ["${aws_subnet.rds.*.id}"]
}

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "public_security_group_id" {
  value = "${aws_security_group.public.id}"
}

output "private_security_group_id" {
  value = "${aws_security_group.private.id}"
}

output "RDS_security_group_id" {
  value = "${aws_security_group.RDS.id}"
}

output "bastion_host_ip" {
  value = ["${aws_instance.bastion.*.public_ip}"]
}
