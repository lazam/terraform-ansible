resource "aws_instance" "ansible_server" {

  count                  = "${var.count}"
  key_name               = "${var.keypair}"
  instance_type          = "${var.instance_type}"
  ami                    = "${lookup(var.ami, var.vpc_region["primary"])}"
  subnet_id              = "${element(var.private_subnets, count.index)}"
  vpc_security_group_ids = ["${var.private_sg}"]
  iam_instance_profile   = "${aws_iam_instance_profile.ansible_profile.name}"

  root_block_device {
    delete_on_termination = "true"
    volume_size            = "10"
  }

  provisioner "local-exec" {
  command = "sleep 90"
  }

  tags {
    Name = "Ansible-Server"
  }

}
