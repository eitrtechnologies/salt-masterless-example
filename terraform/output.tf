
output "salt_minion_public_ip" {
  value = aws_instance.salt_minion.public_ip
}
