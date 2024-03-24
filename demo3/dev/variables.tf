variable "service_name" {
  type        = string
  description = "The name of the Fastly service"
}

variable "version_comment" {
  type        = string
  description = "A comment for the service version"
  default     = ""
}

variable "activate" {
  type        = bool
  description = "Whether to activate the service version"
  default     = true
}

variable "service_domain" {
  type        = string
  description = "The domain associated with the Fastly service"
}

variable "origin_name" {
  type        = string
  description = "The name of the origin server"
}

variable "origin_domain" {
  type        = string
  description = "The domain of the origin server"
}
