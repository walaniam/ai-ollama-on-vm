terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.32.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
  tenant_id       = var.azure_tenant_id
}

resource "azurerm_resource_group" "ollama_rg" {
  name     = var.resource_group_name
  location = "West Europe"
}

resource "azurerm_virtual_network" "ollama_vnet" {
  name                = "ollama-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.ollama_rg.location
  resource_group_name = azurerm_resource_group.ollama_rg.name
}

resource "azurerm_subnet" "ollama_subnet" {
  name                 = "ollama-subnet"
  resource_group_name  = azurerm_resource_group.ollama_rg.name
  virtual_network_name = azurerm_virtual_network.ollama_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "ollama_nic" {
  name                = "ollama-nic"
  location            = azurerm_resource_group.ollama_rg.location
  resource_group_name = azurerm_resource_group.ollama_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.ollama_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ollama_public_ip.id
  }
}

resource "azurerm_public_ip" "ollama_public_ip" {
  name                = "ollama-ip"
  location            = azurerm_resource_group.ollama_rg.location
  resource_group_name = azurerm_resource_group.ollama_rg.name
  allocation_method   = "Static"
  sku                 = "Basic"
}

resource "azurerm_network_security_group" "ollama_nsg" {
  name                = "ollama-nsg"
  location            = azurerm_resource_group.ollama_rg.location
  resource_group_name = azurerm_resource_group.ollama_rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "OllamaPort"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "11434"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "ollama_nic_nsg" {
  network_interface_id      = azurerm_network_interface.ollama_nic.id
  network_security_group_id = azurerm_network_security_group.ollama_nsg.id
}

resource "azurerm_linux_virtual_machine" "ollama_vm" {
  name                  = "ollama-vm"
  location              = azurerm_resource_group.ollama_rg.location
  resource_group_name   = azurerm_resource_group.ollama_rg.name
  network_interface_ids = [azurerm_network_interface.ollama_nic.id]
  size                  = var.vm_size
  admin_username        = "azureuser"

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  custom_data = base64encode(file("cloud-init-ollama.yml"))

  disable_password_authentication = true
}

output "ollama_vm_public_ip" {
  description = "Public IP address of the Ollama VM"
  value       = azurerm_public_ip.ollama_public_ip.ip_address
}
