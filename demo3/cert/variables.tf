variable "dns_zone" {
  type        = string
  description = "Name of the hosted zone"
}

variable "domains" {
  type        = set(string)
  description = "The set of domains to enable TLS"

  validation {
    condition     = length(var.domains) > 0
    error_message = "The domains variable requires at least one entry."
  }
}

variable "tls_config" {
  type        = string
  description = "TLS configuration"
  default     = "HTTP/3 & TLS v1.3 + 0RTT (t.sni)"
}

variable "version_comment" {
  type        = string
  description = "A comment for the service version, this is not used in the cert module"
  default     = ""
}
