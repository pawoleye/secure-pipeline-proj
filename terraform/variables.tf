variable "subscription_id" {
  description = "Azure subscription ID to deploy into"
  type        = string
}

variable "project_name" {
  description = "Short name used in resource names (lowercase letters and numbers)"
  type        = string
  default     = "secdemo"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "canadacentral"
}

variable "environment" {
  description = "Environment name, used for tagging"
  type        = string
  default     = "dev"
}
