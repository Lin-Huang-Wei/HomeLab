output "rsa_private_key" {
    description = "Show the ssh rsa private key."
    value       = tls_private_key.rsa_private_key.private_key_pem
    sensitive   = true
}

output "ed25519_private_key" {
    description = "Show the ssh ed25519 private key."
    value       = tls_private_key.ed25519_private_key.private_key_pem
    sensitive   = true
}