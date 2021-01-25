output "public_ip_address" {
  value = data.azurerm_public_ip.ip_aula_data_db.ip_address
}