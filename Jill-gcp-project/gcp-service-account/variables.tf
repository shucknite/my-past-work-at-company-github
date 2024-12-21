variable "account_id" {
  description = "The service account ID. Changing this forces a new service account to be created."
}

variable "description" {
  description = "The display name for the service account. Can be updated without creating a new resource."
  default     = "sa-for-all-my-projects"
}

variable "roles" {
  type        = list(string)
  description = "The roles that will be granted to the service account."
  default     = []
}

variable "project_id" {
  type = string
}