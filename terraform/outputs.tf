output "instances_private_key" {
  value       = module.instances.instances_private_key
  sensitive   = true
  description = "The private key assigned to the virtual machine."
  depends_on = [
    module.instances
  ]
}

output "instances_public_key" {
  value       = module.instances.instances_public_key
  sensitive   = true
  description = "The private key assigned to the virtual machine."
  depends_on = [
    module.instances
  ]
}