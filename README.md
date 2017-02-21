# Terraform deployment for Ansible in AWS

##Overview

It containts Terraform code to provision a new VPC and an Ansible server with either Dynamic or Static inventory.

### Requirements

1. [Terraform](https://www.terraform.io/downloads.html) (version 0.8 or later)
1. AWS account with allowed permissions to deploy services

## Configuration

1. Cloned the repository using `git clone https://github.com/lazam/terraform-ansible`
2. Create a new non-version file named  ```terraform.tfvars``` with the following details:
```
access_key      = "yourAWSAccessKey"
secret_key      = "yourAWSSecretKey"
aws_profile     = "default"
key_name        = "yourKeyPair"
key_path        = "pathtoKeyPair"
allowed_ip         = ["0.0.0.0/0"]   # your workstation IP, 0.0.0.0/0 if anywhere
```

For other configuration. Please see ```variables.tf``` for a list of variables and their default values.

## Deployment Scenarios

### Ansible with Dynamic Inventory

Ansible will use a [Dynamic Invetory](http://docs.ansible.com/ansible/intro_dynamic_inventory.html#example-aws-ec2-external-inventory-script) for this setup. Please see configuration below for using dynamic inventory:

```variable "ansible_inventory" {
  description = "1 if dynamic inventory is true"

  type = "map"

  default = {
    dynamic_inventory = 1
    static_inventory  = 0
  }
}
```

When using dynamic inventory, you still need to manually export two environment variables:

```
export AWS_ACCESS_KEY_ID='AK123'
export AWS_SECRET_ACCESS_KEY='abc123'
```


### Ansible with Static Inventory
Ansible will use the normal static inventory so each hosts need to be declared in /etc/ansible/host.
Please see configuration below for using static inventory:
```variable "ansible_inventory" {
  description = "1 if static inventory is true"

  type = "map"

  default = {
    dynamic_inventory = 1
    static_inventory  = 0
  }
}
```

For hosts declaration, I sugges to follow the best practice of layout [here](http://docs.ansible.com/ansible/playbooks_best_practices.html#directory-layout)
