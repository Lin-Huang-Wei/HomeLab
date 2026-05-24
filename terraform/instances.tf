locals {
  # 1. 基礎預設值 (所有 VM 共用的硬體與雲端配置)
  base_defaults = {
    target_node             = "pve"
    pool                    = ""
    onboot                  = true
    full_clone              = true
    cloudinit_cdrom_storage = "local-lvm"
    agent                   = 0
    os_type                 = "cloud-init"
    qemu_os                 = "l26"
    cpu                     = "host"
    scsihw                  = "virtio-scsi-pci"
    bootdisk                = "scsi0"
    disk_type               = "virtio"
    disk_storage            = "local-lvm"
    disk_backup             = false
    network_model           = "virtio"
    network_bridge          = "vmbr0"
    network_firewall        = false
    network_tag             = 0
    vga_type                = "serial0"
    gateway                 = "192.168.21.254"
    ssh_user                = "root"
    cloud_init_pass         = "novell"
    boot                    = "order=scsi0;ide2"
    automatic_reboot        = true
    enable_data_disk        = false
    data_disks              = []
  }

  # 2. 作業系統特定的預設值
  os_defaults = {
    "ubuntu_noble" = merge(local.base_defaults, {
      tags  = "ubuntu"
      clone = "ubuntu-noble-minimal-tpl"
      desc  = "terraform managed vm"
    })

    "rhel_ootpa" = merge(local.base_defaults, {
      tags  = "redhat"
      clone = "rhel8-ootpa-tpl"
      desc  = "terraform managed vm"
    })

    "rhel_plow" = merge(local.base_defaults, {
      tags  = "redhat"
      clone = "rhel9-plow-tpl"
      desc  = "terraform managed vm"
    })
  }

  # 3. 各台 VM 的個別配置 (只寫不一樣的地方)
  instance_configs = {
    gitlab = {
      os_family        = "ubuntu_noble"
      vmid             = 101
      cores            = 4
      sockets          = 2
      memory           = 24576
      disk_size        = "40"
      ip_address       = "192.168.20.101"
      enable_data_disk = true
      data_disks = [
        {
          size    = "300"
          storage = "pve-data"
        }
      ]
    }

    redmine = {
      os_family        = "ubuntu_noble"
      vmid             = 102
      cores            = 4
      sockets          = 2
      memory           = 4096
      disk_size        = "40"
      ip_address       = "192.168.20.102"
      enable_data_disk = true
      data_disks = [
        {
          size    = "300"
          storage = "pve-data"
        }
      ]
    }

    k8s-master-01 = {
      os_family        = "ubuntu_noble"
      vmid             = 103
      cores            = 2
      sockets          = 2
      memory           = 4096
      disk_size        = "40"
      ip_address       = "192.168.20.103"
      enable_data_disk = false
    }

    k8s-node-01 = {
      os_family        = "ubuntu_noble"
      vmid             = 104
      cores            = 4
      sockets          = 4
      memory           = 4096
      disk_size        = "40"
      ip_address       = "192.168.20.104"
      enable_data_disk = false
    }

    k8s-node-02 = {
      os_family        = "ubuntu_noble"
      vmid             = 105
      cores            = 4
      sockets          = 4
      memory           = 4096
      disk_size        = "40"
      ip_address       = "192.168.20.105"
      enable_data_disk = false
    }

    #lab-node-01 = {
    #  os_family        = "ubuntu_noble"
    #  vmid             = 106
    #  cores            = 4
    #  sockets          = 4
    #  memory           = 4096
    #  disk_size        = "40"
    #  ip_address       = "192.168.20.106"
    #  enable_data_disk = false
    #  data_disks = [
    #    {
    #      size    = "300"
    #      storage = "pve-data"
    #    }
    #  ]
    #}

    rhel-plow-01 = {
      os_family        = "rhel_plow"
      vmid             = 107
      cores            = 4
      sockets          = 4
      memory           = 16384
      disk_size        = "40"
      ip_address       = "192.168.20.107"
      enable_data_disk = true
      data_disks = [
        {
          size    = "300"
          storage = "pve-data"
        }
      ]
    }

    /* 範例：取消註解即可快速新增機器
    rhel8-ootpa-01 = {
      os_type    = "rhel_ootpa"
      vmid       = 104
      cores      = 2
      sockets    = 2
      memory     = 4096
      disk_size  = "40"
      ip_address = "192.168.20.104"
    }
    */
  }

  # 4. 自動合併產生最終的 instances Map
  instances = {
    for k, v in local.instance_configs : k => merge(
      lookup(local.os_defaults, try(v.os_type, v.os_family), local.base_defaults),
      v,
      { name = k } # 自動使用 Map 的 Key 作為 VM 名稱
    )
  }
}
