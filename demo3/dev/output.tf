output "service_info" {
  value = <<-EOT
  #### Click the URL to go to the service ####
  https://cfg.fastly.com/${fastly_service_vcl.service.id}
  #### Send a test request with curl ####
  curl -svo /dev/null "https://${one(fastly_service_vcl.service.domain).name}/anything"
  EOT
}
