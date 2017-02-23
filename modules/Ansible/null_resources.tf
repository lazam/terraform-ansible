resource "null_resource" "dynamic_discovery" {

  count = "${1 * var.ansible_inventory["dynamic_inventory"]}"

  connection = {
    host        = "${aws_instance.ansible_server.private_ip}"
    user        = "ubuntu"
    type        = "ssh"
    bastion_host = "${element(var.bastion_ip,0)}"
  }


  provisioner "file" {
    source      = "${path.module}/script/dynamic_inventory.sh"
    destination = "/home/ubuntu/dynamic_inventory.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 30",
      "chmod +x /home/ubuntu/dynamic_inventory.sh",
      "sudo bash -x /home/ubuntu/dynamic_inventory.sh",
    ]
  }
}


resource "null_resource" "static_inventory" {

  count = "${1 * var.ansible_inventory["static_inventory"]}"

  connection = {
    host         = "${aws_instance.ansible_server.private_ip}"
    user         = "ubuntu"
    type         = "ssh"
    bastion_host = "${element(var.bastion_ip,0)}"
  }

  provisioner "file" {
    source     = "${path.module}/script/static_inventory.sh"
    destination = "/home/ubuntu/static_inventory.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 30",
      "chmod +x /home/ubuntu/static_inventory",
      "sudo bash -x /home/ubuntu/static_inventory",
    ]
  }

}
