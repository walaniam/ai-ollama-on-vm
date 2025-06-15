# export TF_VAR_azure_subscription_id=
# export TF_VAR_azure_tenant_id=

variable "azure_subscription_id" {
  type = string
}

variable "azure_tenant_id" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type    = string
  default = "Sweden Central"
}

variable "vm_size" {
  type    = string
  default = "Standard_D8as_v5"
}
