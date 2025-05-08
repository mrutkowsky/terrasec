locals {
  name                  = var.name
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.size
  network_interface_ids = var.network_interface_ids
}

resource "azurerm_linux_virtual_machine" "vm_linux" {
  name                  = local.name
  resource_group_name   = local.resource_group_name
  location              = local.location
  size                  = local.size
  admin_username        = "adminuser"
  network_interface_ids = local.network_interface_ids

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}