resource "aws_key_pair" "mykp" {
  key_name   = "terraform-keypair"
  public_key = file("${path.module}/terraform-key.pub")
}
