resource "proxmox_lxc" "lxcs" {
  for_each = { for lxc in var.lxcs : lxc.hostname => lxc }

  target_node = "pve"
  vmid        = each.value.vmid
  hostname    = each.value.hostname
  ostemplate  = var.ostemplate

  cores  = each.value.cores
  memory = each.value.memory
  swap   = each.value.swap

  password = var.root_password

  rootfs {
    storage = "local-lvm"
    size    = each.value.disk_size
  }

  dynamic "mountpoint" {
    for_each = each.value.mountpoints
    content {
      key    = mountpoint.value.slot
      slot   = mountpoint.value.slot
      volume = mountpoint.value.volume
      mp     = mountpoint.value.mp
      backup = mountpoint.value.backup
    }
  }

  network {
    name     = "eth0"
    bridge   = "vmbr0"
    ip       = each.value.cidr
    gw       = each.value.gateway
    firewall = true
  }

  unprivileged = each.value.unprivileged
  start        = true

  features {
    nesting = true
  }
}
