####################################
# AWS Provider
####################################
provider "aws" {
  region = var.aws_region
}

####################################
# Get Latest Amazon Linux 2023 AMI
####################################
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

####################################
# Security Group (SSH + Outbound)
####################################
resource "aws_security_group" "devops_sg" {
  name        = "devops-sg-2"
  description = "Allow SSH access and outbound traffic"

  # 🔹 INBOUND: SSH (22)
  ingress {
    description = "SSH from anywhere (GitHub Actions)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   # ⚠️ Dev/Test only
  }

  # 🔹 OUTBOUND: Allow all
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-security-group"
  }
}

####################################
# EC2 Instance
####################################
resource "aws_instance" "devops_ec2" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  key_name               = aws_key_pair.github_key.key_name
  vpc_security_group_ids = [aws_security_group.devops_sg.id]

  user_data = file("${path.module}/userdata.sh")

  tags = {
    Name = "devops-github-actions-ec2"
  }
}
