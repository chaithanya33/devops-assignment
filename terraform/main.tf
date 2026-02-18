provider "aws" {
  region = var.aws_region
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_security_group" "devops_sg" {
}
resource "aws_instance" "devops_ec2" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  key_name = aws_key_pair.github_key.key_name
  vpc_security_group_ids = [aws_security_group.devops_sg.id]

  user_data = file("${path.module}/userdata.sh")

  tags = {
    Name = "devops-github-actions-ec2"
  }
}
