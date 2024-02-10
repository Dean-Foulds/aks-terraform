# networking-module/variables.tf

variable "resource_group_name" {
  description = "Name of the Azure Resource Group where networking resources will be deployed."
  type        = string
  default     = "myResourceGroup"
}

variable "location" {
  description = "Azure region where networking resources will be deployed."
  type        = string
  default     = "East US"  # Replace with your desired Azure region
}

variable "vnet_address_space" {
  description = "Address space for the Virtual Network (VNet)."
  type        = list(string)
  default     = ["10.0.0.0/16"]  # Example address space. Replace with your desired address space.
}
