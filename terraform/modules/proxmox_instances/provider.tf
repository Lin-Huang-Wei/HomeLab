terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.14"
    }
    tls = {
      source = "hashicorp/tls"
      version = "4.0.4"
    }
  }
}

provider "proxmox" {
  pm_tls_insecure     = true
  pm_api_url          = "https://<IP Address>:<Port>/api2/json"
  pm_api_token_id     = "<TOKEN_ID>"
  pm_api_token_secret = "<TOKEN_SECRET>"
  pm_debug            = true
  pm_log_levels = {
    _default    = "debug"
    _capturelog = ""
  }
}
