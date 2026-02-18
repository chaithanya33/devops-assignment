provider "aws" {
  region = var.aws_region
}

#############################
# Latest Amazon Linux AMI
#############################
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

#############################
# Key Pair
#############################
resource "aws_key_pair" "github_key" {
  key_name   = "github-ec2-key"
  public_key = file(var.public_key_path)
}

#############################
# Security Group
#############################
resource "aws_security_group" "devops_sg" {
  name = "devops-ec2-sg"

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

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#############################
# EC2 Instance
#############################
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

