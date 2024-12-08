# -------------------------------------- Required ------------------------------------------------
variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the virtual network. Changing this forces a new resource to be created."
}

variable "st_name" {
  type        = string
  description = "(Required) Specifies the name of the storage account. Only lowercase Alphanumeric characters allowed. Changing this forces a new resource to be created. This must be unique across the entire Azure service, not just within the resource group."
}

# -------------------------------------- Optional ------------------------------------------------

variable "account_kind" {
  type        = string
  description = "(Optional) Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Defaults to StorageV2."
  default     = "StorageV2"
}

variable "access_tier" {
  type        = string
  description = "(Optional) Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot."
  default     = "Hot"
}

variable "nfsv3_enabled" {
  type        = bool
  description = "(Optional) Is NFSv3 protocol enabled? Changing this forces a new resource to be created. Defaults to false."
  default     = false
}

variable "large_file_share_enabled" {
  type        = bool
  description = "(Optional) Are Large File Shares Enabled? Defaults to false."
  default     = false
}

variable "enable_soft_delete" {
  type        = bool
  description = "Set to 'true', if the 'storage account' created to store 'platform logs'."
  default     = true
}

variable "delete_retention" {
  type        = number
  description = "Specifies the number of days that the blob should be retained, between 1 and 365 days. Defaults to 7."
  default     = 7
}

variable "additional_tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the User Assigned Identity resource."
  default     = null
}
