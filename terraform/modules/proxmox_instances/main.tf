resource "tls_private_key" "ed25519_private_key" {
  algorithm = "ED25519"
  rsa_bits  = 4096
}
resource "proxmox_vm_qemu" "instances" {
  depends_on = [
    tls_private_key.ed25519_private_key
  ]

  for_each    = var.instances

  name        = each.value.name
  tags        = each.value.tags
  desc        = each.value.desc
  target_node = each.value.target_node
  pool        = each.value.pool

  # The template name to clone this vm from
  clone         = each.value.clone
  full_clone    = each.value.full_clone
  # force_create	= each.value.force_create

  # If you want to activate the QEMU agent in the VM,
  # please don't forget to install the qemu-guest-agent package before you run.
  # see reference: https://pve.proxmox.com/wiki/Qemu-guest-agent
  agent = each.value.agent

  vmid    = each.value.vmid
  os_type = each.value.os_type
  qemu_os = each.value.qemu_os
  cpu     = each.value.cpu
  cores   = each.value.cores
  sockets = each.value.sockets
  memory  = each.value.memory
  scsihw  = each.value.scsihw

  # Setup the disk
  disk {
    type    = each.value.disk_type
    storage = each.value.disk_storage
    size    = each.value.disk_size
    backup = each.value.disk_backup
  }

  # Setup the network interface and assign
  network {
    model  = each.value.network_model
    bridge = each.value.network_bridge
    firewall = each.value.network_firewall
    tag = each.value.network_tag
  }

  vga {
    type = each.value.vga_type
  }

  ipconfig0  = "ip=${each.value.ip_address}/24,gw=${each.value.gateway}"

  ssh_user   = each.value.ssh_user
  ciuser = each.value.ssh_user
  cipassword = each.value.cloud_init_pass
  sshkeys    = tls_private_key.ed25519_private_key.public_key_openssh
  ssh_private_key = tls_private_key.ed25519_private_key.private_key_openssh
  automatic_reboot = each.value.automatic_reboot
}