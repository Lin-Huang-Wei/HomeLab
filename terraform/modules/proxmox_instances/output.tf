output "instances_private_key" {
  value     = tls_private_key.ed25519_private_key.private_key_openssh
  sensitive = true
}

output "instances_public_key" {
  value     = tls_private_key.ed25519_private_key.public_key_openssh
  sensitive = true
}