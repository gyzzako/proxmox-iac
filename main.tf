module "lxc" {
  source = "./lxc"

  ostemplate = var.ostemplate
  root_password       = var.root_password
  lxcs       = var.lxcs
}