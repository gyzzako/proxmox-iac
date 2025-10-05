variable "ostemplate" {
  type = string
}

variable "root_password" {
  type = string
  sensitive = true
}

variable "lxcs" {
  description = "List of LXC containers to create"
  type = list(object({
    hostname  = string
    vmid      = number
    cores     = number
    memory    = number
    swap      = number
    disk_size = string
    cidr      = string
    gateway   = string
    mountpoints = list(object({
      slot   = number
      volume = string
      mp     = string
      backup = bool
    }))
    unprivileged = bool
  }))
}