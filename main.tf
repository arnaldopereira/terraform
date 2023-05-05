terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

resource "aws_vpc" "my_generic_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Generic VPC"
  }
}

resource "aws_subnet" "generic_public_subnet" {
  vpc_id     = aws_vpc.my_generic_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Generic public subnet"
  }
}

resource "aws_internet_gateway" "generic_gw" {
  vpc_id = aws_vpc.my_generic_vpc.id

  tags = {
    Name = "Genric instance gw"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_generic_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.generic_gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.generic_gw.id
  }

  tags = {
    Name = "Public route table"
  }
}

resource "aws_route_table_association" "public_1_rt_a" {
  subnet_id      = aws_subnet.generic_public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_security_group" "web_sg" {
  name   = "HTTP and SSH"
  vpc_id = aws_vpc.my_generic_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "HTTP and SSH opened"
  }
}

// When using RSA (not recommended), you'll have to also provide the `rsa_bits`
// argument. ED25519 doesn't require it.
resource "tls_private_key" "fs_key" {
  algorithm = var.key_algorithm
}

// Set key pair on AWS and save the private key on disk. This code works on Linux and
// MacOS, you'll have to adapt it if you plan to run it on Windows -- specifically the
// `local-exec` command.
resource "aws_key_pair" "key_pair" {
  key_name   = var.key_pair_name
  public_key = trimspace(tls_private_key.fs_key.public_key_openssh)

  provisioner "local-exec" {
    command = "echo '${tls_private_key.fs_key.private_key_openssh}' > ./${var.key_pair_name}.pem && chmod 400 ./${var.key_pair_name}.pem"
  }
}

// Create the instance on the newly created subnet, with the key pair attached to it.
// To connect to the instance, use the command `ssh -i generic_key_pair.pem ubuntu@ip-address`
// That is, if you didn't change the key name or the instance AMI in the variables.tf file.
resource "aws_instance" "generic_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.key_pair.key_name

  subnet_id                   = aws_subnet.generic_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = var.instance_name
  }
}
