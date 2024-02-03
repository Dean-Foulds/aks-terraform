
# Project Name

## Overview

This repository contains the Infrastructure as Code (IaC) for provisioning an Azure Kubernetes Service (AKS) cluster along with networking resources using Terraform. The project is organized into modules for better maintainability and separation of concerns.

## Project Structure

- **main.tf**: The main Terraform configuration file that orchestrates the provisioning process.
- **modules/**
  - **networking-module/**: Module for networking resources.
  - **cluster-module/**: Module for AKS cluster specifications.

## Main Configuration File (`main.tf`)

### Provider Setup


provider "azurerm" {
  features = {}
}
```

The main provider block sets up the Azure provider without additional features.

### Networking Module Integration

```hcl
module "networking" {
  source               = "./modules/networking-module"
  resource_group_name  = "networking-resource-group"
  location             = "UK South"
  my_public_ip         = "84.71.226.249"
  # Additional module-specific variables can be provided here
}
```

The `networking` module is integrated to provision networking resources. Input variables like `resource_group_name`, `location`, and `my_public_ip` are specified.

### Cluster Module Integration

```hcl
module "aks_cluster" {
  source                     = "./modules/cluster-module"
  cluster_name               = "terraform-aks-cluster"
  location                   = "UK South"
  dns_prefix                 = "myaks-project"
  kubernetes_version         = "1.26.6"
  service_principal_client_id = var.service_principal_client_id
  service_principal_secret   = var.service_principal_secret
  # Other required input variables are populated using networking module outputs
  resource_group_name        = module.networking.resource_group_name
  vnet_id                    = module.networking.vnet_id
  control_plane_subnet_id    = module.networking.control_plane_subnet_id
  worker_node_subnet_id      = module.networking.worker_node_subnet_id
  aks_nsg_id                 = module.networking.aks_nsg_id
}
```

The `aks_cluster` module is integrated to provision the AKS cluster. Input variables are specified, and some are populated using outputs from the `networking` module.

### Output

```hcl
output "kube_config" {
  value = module.aks_cluster.kube_config_raw
}
```

An output block is defined to expose the `kube_config` from the AKS cluster module.

## Input Variables

- **service_principal_client_id**: Azure Service Principal Client ID.
- **service_principal_secret**: Azure Service Principal Client Secret.
- **resource_group_name**: Azure resource group name.
- **location**: Azure region.
- **my_public_ip**: Public IP address.
- **... (other networking and AKS-related variables)**

## Usage

1. Initialize the Terraform project:

   ```bash
   terraform init
   ```

2. Apply the Terraform configuration:

   ```bash
   terraform apply
   ```

3. Access the Kubernetes cluster by retrieving the kubeconfig:

   ```bash
   terraform output kube_config > kubeconfig
   ```

   Use `kubectl` to interact with the AKS cluster:

   ```bash
   kubectl get nodes
   ```

## Notes

- Ensure proper Azure credentials are configured before running Terraform commands.
- Add the `kubeconfig` file to your `KUBECONFIG` environment variable for kubectl access.
```

