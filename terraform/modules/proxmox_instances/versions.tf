terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">= 3.0.0" # 確保子模組也認得 v3 語法
    }
    tls = {
      source = "hashicorp/tls"
    }
  }
}
