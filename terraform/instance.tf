
resource "aws_instance" "salt_minion" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  key_name  = aws_key_pair.salt_minion_example.key_name
  user_data = <<EOF
#!/bin/bash
curl -L "https://raw.githubusercontent.com/eitrtechnologies/salt-masterless-example/main/bootstrap/install.sh" | sudo bash
EOF

  tags = {
    Name = "salt-minion-example-${random_string.key_pair_suffix.result}"
  }
}
