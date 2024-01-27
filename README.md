

```
# Project Networking Infrastructure as Code (IaC)

## Overview

This project utilizes Infrastructure as Code (IaC) to define networking services using Terraform. The networking resources are defined in the "networking-module" directory.

## Terraform Networking Module

### Module Structure

The "networking-module" directory contains Terraform configurations for defining Azure networking resources.

```plaintext
networking-module/
|-- main.tf
|-- outputs.tf
|-- variables.tf
|-- terraform.tfvars
|-- README.md
```

- **main.tf:** Defines the main configuration for networking resources.
- **outputs.tf:** Specifies the output variables to be used by other modules.
- **variables.tf:** Declares input variables for the module.
- **terraform.tfvars:** Holds variable values specific to the project.
- **README.md:** This documentation file.

### Networking Resources

#### Azure Resource Group

- **Resource Name:** `azurerm_resource_group.networking`
- **Purpose:** Creates an Azure Resource Group to logically group networking resources.
- **Dependencies:** None.

#### Virtual Network

- **Resource Name:** `azurerm_virtual_network.my_vnet`
- **Purpose:** Defines an Azure Virtual Network to isolate resources within the project.
- **Dependencies:** Depends on `azurerm_resource_group.networking`.

#### Subnets

1. **Control Plane Subnet:**
   - **Resource Name:** `azurerm_subnet.control_plane`
   - **Purpose:** Creates a subnet for the control plane components of the AKS cluster.
   - **Dependencies:** Depends on `azurerm_virtual_network.my_vnet`.

2. **Worker Nodes Subnet:**
   - **Resource Name:** `azurerm_subnet.worker_nodes`
   - **Purpose:** Defines a subnet for the worker nodes of the AKS cluster.
   - **Dependencies:** Depends on `azurerm_virtual_network.my_vnet`.

#### Network Security Group

- **Resource Name:** `azurerm_network_security_group.aks_nsg`
- **Purpose:** Defines a Network Security Group for AKS cluster security rules.
- **Dependencies:** Depends on `azurerm_resource_group.networking`.

### Input Variables

- **Resource Group Name:** `name`
- **Location:** `location`
- **Virtual Network Name:** `vnet_name`
- **Control Plane Subnet Name:** `control_plane_subnet_name`
- **Worker Nodes Subnet Name:** `worker_nodes_subnet_name`
- **Network Security Group Name:** `nsg_name`

### Output Variables

- **VNet ID:** `vnet_id`
- **Control Plane Subnet ID:** `control_plane_subnet_id`
- **Worker Node Subnet ID:** `worker_node_subnet_id`
- **Networking Resource Group Name:** `networking_resource_group_name`
- **AKS NSG ID:** `aks_nsg_id`

## Usage

1. Ensure you have [Terraform](https://www.terraform.io/downloads.html) installed.
2. Update `terraform.tfvars` with your desired variable values.
3. Run `terraform init` in the "networking-module" directory.
4. Run `terraform apply` to create the networking resources.

## Example Terraform.tfvars

```hcl
name = "your-networking-rg"
location = "your-location"
vnet_name = "your-vnet"
control_plane_subnet_name = "control-plane-subnet"
worker_nodes_subnet_name = "worker-nodes-subnet"
nsg_name = "aks-nsg"
```

## Author

Your Name

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
```
