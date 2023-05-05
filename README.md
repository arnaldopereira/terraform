# Simple EC2

Configuration in this directory shows how to create an EC2 instance, with:

- An ED25519 SSH key pair, fully provisioned through terraform.
- VPC, along with what's necessary with it: a subnet, internet gateway, routing table and security group with SSH and HTTP ports opened.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

This example should run successfully without any change to it's code and create the file `generic_key_pair.pem`, which is the SSH private key which you'll use to access the newly created instance with the command:

```
ssh -i generic_key_pair.pem ubuntu@instance-ip-address
```

You'd have to replace `instance-ip-address` with the instance's actual IP address. If you've missed the IP address from the output of `terraform apply` command, you can always get it again from running `terraform show`.

When you don't need the resources anymore, delete them with `terraform destroy`.

## Providers

AWS.
