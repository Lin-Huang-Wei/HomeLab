resource "tls_private_key" "rsa_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_private_key" "ed25519_private_key" {
  algorithm = "ED25519"
  rsa_bits  = 4096
}