resource "fastly_service_vcl" "service" {
  name            = var.service_name
  version_comment = var.version_comment
  activate        = var.activate

  domain {
    name = var.service_domain
  }

  backend {
    name          = var.origin_name
    address       = var.origin_domain
    override_host = var.origin_domain
  }

  vcl {
    name    = "main"
    content = file("${path.module}/vcl/main.vcl")
    main    = true
  }

  # Custom 404
  snippet {
    content  = file("${path.module}/vcl/fetch_custom_404.vcl")
    name     = "fetch_custom_404"
    type     = "fetch"
    priority = 100
  }

  snippet {
    content = templatefile("${path.module}/vcl/error_custom_404.vcl",
    { html = file("${path.module}/html/custom_404.html") })
    name     = "error_custom_404"
    type     = "error"
    priority = 100
  }

  force_destroy = true
}
