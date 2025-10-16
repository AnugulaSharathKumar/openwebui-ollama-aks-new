output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.main.name
}

output "aks_cluster_name" {
  description = "AKS cluster name"
  value       = azurerm_kubernetes_cluster.main.name
}

output "acr_name" {
  description = "ACR name"
  value       = azurerm_container_registry.main.name
}

output "storage_account_name" {
  description = "Storage account name for backups"
  value       = azurerm_storage_account.backup.name
}

output "kube_config" {
  description = "Kubernetes config"
  value       = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive   = true
}