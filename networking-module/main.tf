# networking-module/main.tf

# Create Azure Resource Group
resource "azurerm_resource_group" "aks_rg" {
  name     = var.resource_group_name
  location = var.location
}

# Create Virtual Network
resource "azurerm_virtual_network" "aks_vnet" {
  name                = "aks-vnet"
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
}

# Create Control Plane Subnet
resource "azurerm_subnet" "control_plane_subnet" {
  name                 = "control-plane-subnet"
  resource_group_name  = azurerm_resource_group.aks_rg.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.0.1.0/24"]  # Example subnet address space. Replace with your desired address space.
}

# Create Worker Node Subnet
resource "azurerm_subnet" "worker_node_subnet" {
  name                 = "worker-node-subnet"
  resource_group_name  = azurerm_resource_group.aks_rg.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.0.2.0/24"]  # Example subnet address space. Replace with your desired address space.
}

# Create Network Security Group (NSG)
resource "azurerm_network_security_group" "aks_nsg" {
  name                = "aks-nsg"
  resource_group_name = azurerm_resource_group.aks_rg.name

  # Define inbound rules
  security_rule {
    name                       = "kube-apiserver-rule"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = var.my_public_ip
    destination_address_prefix = azurerm_subnet.control_plane_subnet.address_prefixes[0]
    destination_port_range     = "6443"
  }

  security_rule {
    name                       = "ssh-rule"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = var.my_public_ip
    destination_address_prefix = "*"
    destination_port_range     = "22"
  }
}
