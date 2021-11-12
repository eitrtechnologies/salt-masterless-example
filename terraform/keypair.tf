
resource "random_string" "key_pair_suffix" {
  length  = 4
  lower   = false
  number  = true
  special = false
  upper   = true
}

resource "tls_private_key" "salt_minion" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "salt_minion_example" {
  key_name   = "salt-minion-example-${random_string.key_pair_suffix.result}"
  public_key = tls_private_key.salt_minion.public_key_openssh
}

resource "local_file" "pem_file" {
  filename             = "./keys/salt-minion-example-${random_string.key_pair_suffix.result}.pem"
  file_permission      = "600"
  directory_permission = "700"
  sensitive_content    = tls_private_key.salt_minion.private_key_pem
}
