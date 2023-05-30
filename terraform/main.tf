module "instances" {
  source    = "./modules/proxmox_instances"
  instances = local.instances
}