variable "manager_private_key_path" {
  default = "C:/Users/Arnaud/.ssh/terraform_manager_lxc"
}

variable "manager_public_key_path" {
  default = "C:/Users/Arnaud/.ssh/terraform_manager_lxc.pub"
}

locals {
  manager_public_key  = file(var.manager_public_key_path)
  manager_private_key = file(var.manager_private_key_path)
  private_key         = tls_private_key.ssh_key.private_key_pem
}

resource "proxmox_lxc" "manager" {
  target_node = "pve"
  vmid        = 110
  hostname    = "manager"
  ostemplate  = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"

  cores  = 2
  memory = 2048
  swap   = 512

  password = var.root_password

  rootfs {
    storage = "local-lvm"
    size    = "8G"
  }

  network {
    name     = "eth0"
    bridge   = "vmbr0"
    ip       = "192.168.129.110/23"
    gw       = "192.168.128.1"
    firewall = true
  }

  unprivileged = true
  start        = true

  features {
    nesting = true
  }

  ssh_public_keys = local.manager_public_key
}

resource "null_resource" "upload_private_key" {
  depends_on = [proxmox_lxc.manager, tls_private_key.ssh_key]

  connection {
    type        = "ssh"
    host        = "192.168.129.110"
    user        = "root"
    private_key = local.manager_private_key
  }

  provisioner "file" {
    content     = local.private_key
    destination = "/root/.ssh/id_rsa"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 /root/.ssh/id_rsa"
    ]
  }
}