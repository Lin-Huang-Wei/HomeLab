variable "pm_api_url" {
  type        = string
  description = "The Proxmox API URL"
}

variable "pm_api_token_id" {
  type        = string
  description = "The Proxmox API Token ID"
}

variable "pm_api_token_secret" {
  type        = string
  description = "The Proxmox API Token Secret"
  sensitive   = true
}
