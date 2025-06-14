# export TF_VAR_azure_subscription_id=
# export TF_VAR_azure_tenant_id=
# export TF_VAR_notification_alert_email=

variable "azure_subscription_id" {
  type = string
}

variable "azure_tenant_id" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "vm_size" {
  type    = string
  default = "Standard_NV4as_v4"
}
