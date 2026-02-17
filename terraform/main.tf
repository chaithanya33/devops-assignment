provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "devops_app" {
  ami           = "ami-019715e0d74f695be"
  instance_type = "t3.small"

  # ✅ Attach keypair from keypair.tf
  key_name = aws_key_pair.mykp.key_name

  tags = {
    Name = "devops-assignment-instance"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install docker -y
              service docker start
              usermod -aG docker ec2-user
              EOF
}

