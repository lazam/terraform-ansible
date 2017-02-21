resource "aws_instance" "bastion" {

  count                  = "${var.bastion_count}"
  key_name               = "${var.bastion_keypair}"
  instance_type          = "${var.instance_type}"
  ami                    = "${lookup(var.bastion_ami, var.vpc_region["primary"])}"
  subnet_id              = "${element(aws_subnet.public.*.id, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.public.id}"]

  root_block_device {
    delete_on_termination = "true"
    volume_size            = "10"
  }

  tags {
    Name = "Bastion-Host"
  }
}
