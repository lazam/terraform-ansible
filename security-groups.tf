resource "aws_security_group" "ssh_access" {
    name = "ssh_access"
    description = "Allow inbound acccess to server"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
         from_port = 0
         to_port = 0
         protocol = "-1"
         cidr_blocks = ["0.0.0.0/0"]
    }

}
