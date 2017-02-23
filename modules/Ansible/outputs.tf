output "ansible_server" {
  value = ["${aws_instance.ansible_server.*.private_ip}"]
}
