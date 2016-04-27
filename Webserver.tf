resource "aws_instance" "Webserver" {

    ami = "${lookup(var.ami, var.region.primary)}"
    instance_type = "${var.insttype.utility}"
    tags {
        Name = "webserver"
    }

    key_name = "${var.key_name}"

    /* SSH conenction */
    connection = {
        user = "ubuntu"
        key_file = "${var.key_path}"
        agent = "false"
    }

    /* Delete volume when terminated */
    root_block_device {
        delete_on_termination = true #Delete EBS when destroyed
    }

    /* security group info */
    security_groups = ["${aws_security_group.http_access.name}"]

    /* Provisioners */
    
    provisioner "remote-exec" {
       inline = [
            "sudo apt-get update"
       ]
    }
}
