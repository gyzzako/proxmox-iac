terraform {
  required_version = ">= 1.13.0"

  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc04"
    }
  }
}

provider "proxmox" {
  pm_api_url  = var.PROXMOX_URL
  pm_user     = var.USER
  pm_password = var.PASSWORD

  # because of self-signed certificate
  pm_tls_insecure = true
}