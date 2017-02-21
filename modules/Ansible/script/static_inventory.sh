#!/bin/bash

ansib_dir="/etc/ansible"

apt-add-repository ppa:ansible/ansible -y
apt-get update
apt-get install ansible -y
mkdir -p $ansib_dir/inventories/{prod,stage,dev}
mkdir -p $ansib_dir/roles/{common,web,db}
