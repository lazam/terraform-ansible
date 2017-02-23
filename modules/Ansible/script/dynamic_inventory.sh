#!/bin/bash

ansib_dir="/etc/ansible"

apt-add-repository ppa:ansible/ansible -y
apt-get update
apt-get install ansible python-boto -y
sleep 30
wget -O $ansib_dir/ec2.py https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.py
sleep 30
wget -O $ansib_dir/ec2.ini https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.ini
chmod 777 $ansib_dir/ec2.py
mkdir -p $ansib_dir/roles/{common,web,db}
