# Configure the Azure Provider
provider "azurerm" {}

variable "location" {
  default = "West US 2"
}

variable "username" {
  default = "***"
}

variable "password" {
  default = "***"
}

# Create a resource group.
resource "azurerm_resource_group" "resourceGroup" {
  name     = "arielmis_resource_group"
  location = "${var.location}"
}

# Create a public IP address.
resource "azurerm_public_ip" "publicip" {
  name                    = "arielmis_public_ip"
  location                = "${var.location}"
  resource_group_name     = "${azurerm_resource_group.resourceGroup.name}"
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30
  domain_name_label       = "arielmisvm01"

  tags {
    environment = "test"
  }
}

# Output the FQDN of the public IP address from above. Use this to RDP to the VM.
output "public_ip_dns_name" {
  description = "The FQDN of the public ip address allocated for the resource above."
  value       = "${azurerm_public_ip.publicip.*.fqdn}"
}

# Create a virtual network within the resource group.
resource "azurerm_virtual_network" "vnet" {
  name                = "arielmis_vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resourceGroup.name}"
}

# Create a security group and rule.
resource "azurerm_network_security_group" "nsg" {
  name                = "arielmis_nsg"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resourceGroup.name}"

  security_rule {
    name                       = "RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags {
    environment = "test"
  }
}

# Create a subnet in the vnet from above.
resource "azurerm_subnet" "subnet" {
  name                 = "arielmis_subnet"
  resource_group_name  = "${azurerm_resource_group.resourceGroup.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "10.0.2.0/24"
}

# Create a nic and assign a dynamic address
resource "azurerm_network_interface" "nic" {
  name                      = "arielmis_vm01_nic"
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.resourceGroup.name}"
  network_security_group_id = "${azurerm_network_security_group.nsg.id}"

  ip_configuration {
    name                          = "arielmis_configuration"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.publicip.id}"
  }
}

# Create a storage account
resource "azurerm_storage_account" "storageacc" {
  name                     = "arielmisstorageacc"
  resource_group_name      = "${azurerm_resource_group.resourceGroup.name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

# Create a storage contatiner
resource "azurerm_storage_container" "storagecont" {
  name                  = "arielmisstoragecont"
  resource_group_name   = "${azurerm_resource_group.resourceGroup.name}"
  storage_account_name  = "${azurerm_storage_account.storageacc.name}"
  container_access_type = "private"
}

# # Create an additional data disk if required.
# resource "azurerm_managed_disk" "datadisk" {
#   name                 = "arielmisvm01_datadisk"
#   location             = "${var.location}"
#   resource_group_name  = "${azurerm_resource_group.resourceGroup.name}"
#   storage_account_type = "Standard_LRS"
#   create_option        = "Empty"
#   disk_size_gb         = "1023"
# }

# Create a VM with 2 vCPU and 4 GiB memory. ~$36.21/month
resource "azurerm_virtual_machine" "vm" {
  name                  = "arielmis_vm01"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.resourceGroup.name}"
  network_interface_ids = ["${azurerm_network_interface.nic.id}"]
  vm_size               = "Standard_B2s"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "arielmis_osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # # Attach additional data disk from above.
  # storage_data_disk {
  #   name            = "${azurerm_managed_disk.datadisk.name}"
  #   managed_disk_id = "${azurerm_managed_disk.datadisk.id}"
  #   create_option   = "Attach"
  #   lun             = 1
  #   disk_size_gb    = "${azurerm_managed_disk.datadisk.disk_size_gb}"
  # }

  os_profile {
    computer_name  = "vm01"
    admin_username = "${var.username}"
    admin_password = "${var.password}"
  }
  os_profile_windows_config {
    enable_automatic_upgrades = true
    provision_vm_agent        = true
  }
}
