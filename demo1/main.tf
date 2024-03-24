terraform {
  required_providers {
    fastly = {
      source  = "fastly/fastly"
      version = "~> 5.6.0"
    }
  }
}

resource "fastly_service_vcl" "service" {
  name = "Development Service"

  domain {
    name = "dev.hkakehas.tokyo"
  }

  backend {
    name          = "Example Backend"
    address       = "http-me.glitch.me"
    override_host = "http-me.glitch.me"
  }

  force_destroy = true
}
