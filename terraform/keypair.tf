resource "aws_key_pair" "mykp" {
  key_name = "terraform-keypair"
public_key = file("C:/Users/ADMIN/.ssh/terraform-key.pub")
}
