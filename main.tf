# main.tf

# Provider block (already provisioned)
provider "azurerm" {
  features {}
}

# Networking module
module "networking" {
  source = "./networking-module"  # Update with the actual path to your networking module

  # Input variables for the networking module
  resource_group_name         = "networking-resource-group"
  location                    = "UK South"
  vnet_address_space          = ["10.0.0.0/16"]

  # Output variables from the networking module used as input for the cluster module
  aks_nsg_id                  = module.networking.aks_nsg_id
  control_plane_subnet_id     = module.networking.control_plane_subnet_id
  resource_group_name         = module.networking.networking_resource_group_name
  vnet_id                     = module.networking.vnet_id
  worker_node_subnet_id       = module.networking.worker_node_subnet_id
}

# Cluster module
module "aks_cluster" {
  source = "./aks-cluster-module"  # Update with the actual path to your cluster module

  # Input variables for the cluster module
  aks_cluster_name            = "terraform-aks-cluster"
  cluster_location            = "UK South"
  dns_prefix                  = "myaks-project"
  kubernetes_version          = "1.26.6"
  service_principal_client_id = "<Your service principal client ID>"
  service_principal_secret    = "<Your service principal secret>"

  # Output variables from the networking module used as input for the cluster module
  resource_group_name         = module.networking.resource_group_name
  vnet_id                     = module.networking.vnet_id
  control_plane_subnet_id     = module.networking.control_plane_subnet_id
  worker_node_subnet_id       = module.networking.worker_node_subnet_id
  aks_nsg_id                  = module.networking.aks_nsg_id
}
