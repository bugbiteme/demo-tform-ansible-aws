provider "aws" {
  region = "us-east-2"
}

variable "namespace" {
  type    = string
  default = "Ansible Demo Environment"
}

// Generate the SSH keypair that we’ll use to configure the EC2 instance. 
// After that, write the private key to a local file and upload the public key to AWS

resource "tls_private_key" "key" {
  algorithm = "RSA"
}

resource "local_file" "private_key" {
  filename          = "${path.module}/ec2-key.pem"
  sensitive_content = tls_private_key.key.private_key_pem
  file_permission   = "0400"
}


resource "aws_key_pair" "key_pair" {
  key_name   = local_file.private_key.filename
  public_key = tls_private_key.key.public_key_openssh
}


// Create a security group with access to port 22 and port 80 open to serve HTTP traffic

data "aws_vpc" "default" {
  default = true
}


resource "aws_security_group" "allow_ssh" {
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.namespace
  }
}



// Configure the EC2 instance itself
// Create aws_ami filter to pick up the ami available in your region
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "ec2_instance" {
  ami                         = data.aws_ami.amazon-linux-2.id
  associate_public_ip_address = true
  count                       = 3
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  key_name                    = aws_key_pair.key_pair.key_name

  tags = {
    Name = "${var.namespace} ${count.index}"
  }

}

// generate inventory file
resource "local_file" "inventory" {
  filename = "./hosts-dev"
  content  = <<EOF
    # hosts-dev

    [loadbalancers]
    lb1 ansible_host=${aws_instance.ec2_instance[0].public_ip}

    [webservers]
    app1 ansible_host=${aws_instance.ec2_instance[1].public_ip}
    app2 ansible_host=${aws_instance.ec2_instance[2].public_ip}

    [local]
    control ansible_connection=local
    EOF
}

// Output the public_ip and the Ansible command to connect to ec2 instance

output "ec2_instance_ip" {
  description = "IP address of the EC2 instance"
  value       = aws_instance.ec2_instance.*.public_ip
}

output "load_balancer" {
  description = "Copy/Paste/Enter - You are in the matrix"
  value       = "ssh -i ec2-key.pem ec2-user@${aws_instance.ec2_instance[0].public_dns}"
}
output "web_host_1" {
  description = "Copy/Paste/Enter - You are in the matrix"
  value       = "ssh -i ec2-key.pem ec2-user@${aws_instance.ec2_instance[1].public_dns}"
}
output "web_host_2" {
  description = "Copy/Paste/Enter - You are in the matrix"
  value       = "ssh -i ec2-key.pem ec2-user@${aws_instance.ec2_instance[2].public_dns}"
}

output "website_lb" {
  description = "can access once Ansible has done its job"
  value       = "http://${aws_instance.ec2_instance[0].public_dns}"
}

output "website_test_lb" {
  description = "can access once Ansible has done its job"
  value       = "http://${aws_instance.ec2_instance[0].public_dns}/info.php"
}
