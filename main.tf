resource "aws_instance" "main" {
    ami = "${lookup(var.ami, var.region.primary)}"
    instance_type = "${var.insttype.utility}"
    tags {
        Name = "Ansible-Server"
    }

    key_name = "${var.key_name}"
    
    /* Delete EBS on termination */
    root_block_device {
        delete_on_termination = true
    } 

    /* security group info */
    security_groups = ["${aws_security_group.ssh_access.name}"]

    /* SSH Conenction */
    connection = {
        user = "ubuntu"
        key_file = "${var.key_path}"
        agent = "false"
    }
    
    provisioner "file" {
        source = "files/"
        destination = "/tmp"
    }

     provisioner "file" {
        source = "playbook/"
        destination = "/tmp"
    }


      provisioner "file" {
        source = "${var.key_path}"
        destination = "/home/ubuntu/.ssh/SSHkey"
    }


    /* Install and configure Ansible */

    provisioner "remote-exec" {
        inline = [
            "sudo apt-get update",
            "sudo apt-get install ansible python-pip -y",
            "sudo pip install boto",
            "cd /etc/ansible/ ; sudo wget -O ec2.py https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.py",
            "cd /etc/ansible/ ; sudo wget -O ec2.ini https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.ini",
            "sudo chmod 777 /etc/ansible/ec2.py",
            "sudo mkdir /etc/ansible/playbooks && sudo mkdir /etc/ansible/roles",
            "sudo rm -rf /etc/ansible/ansible.cfg && sudo mv /tmp/ansible.cfg /etc/ansible/",
            "mv /tmp/config ~/.ssh/config && chmod 600 ~/.ssh/config && chmod 400 ~/.ssh/SSHkey",
            "sudo mv /tmp/*.yaml /etc/ansible/playbooks/",

        ]
    }

}
