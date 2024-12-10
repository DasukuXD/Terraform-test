variable "resource_group_name" {
  type        = string1
  description = "(Required) Resource Group to create the Private Endpoint(s) in."
}

variable "private_endpoints" {
  type = map(object({
    name                           = string
    subnet_id                      = string
    group_ids                      = list(string)
    approval_required              = bool
    approval_message               = string
    private_connection_resource_id = string
    subresource_names              = list(string)
  }))
  description = "(Required) Map containing Private Endpoint details: name, subnet_id, group_ids, approval_required, approval_message, private_connection_resource_id, subresource_names."
}

variable "default_request_message" {
  type        = string
  description = "(Optional) A message passed to the owner of the remote resource when the private endpoint attempts to establish the connection to the remote resource. This is passed when the 'approval_message' in the 'private_endpoints' object is empty and an approval is required."
  default     = "Please approve this private endpoint connection request"
}

variable "additional_tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the User Assigned Identity resource."
  default     = null
}
