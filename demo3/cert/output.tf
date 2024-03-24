output "cert_info" {
  value = <<-EOT
  #### Click the URL to go to the subscription details ####
  https://manage.fastly.com/network/subscriptions/${fastly_tls_subscription.subscription.id}
  #### Check the certificate with openssl ####
  openssl s_client -connect ${one([for r in data.fastly_tls_configuration.configuration.dns_records : r.record_value if r.record_type == "CNAME"])}:443 -servername "${tolist(var.domains)[0]}" </dev/null | openssl x509 -text -noout
  EOT
}
