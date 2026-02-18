resource "aws_key_pair" "mykp" {
  key_name   = "github-ec2-key"
  public_key = var.public_key
}
