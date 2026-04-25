variable "instances" {
  description = "Identifies the object of virtual machines."
  type        = map(any)
  default     = {}
}

variable "enable_data_disk" {
  type        = bool
  description = "Add data disk to the virtual machine."
  default     = false
}
