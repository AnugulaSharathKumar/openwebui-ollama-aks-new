# Data source for AKS cluster credentials
data "azurerm_kubernetes_cluster" "credentials" {
  name                = azurerm_kubernetes_cluster.main.name
  resource_group_name = azurerm_resource_group.main.name

  depends_on = [azurerm_kubernetes_cluster.main, null_resource.configure_kubectl]
}

# Kubernetes provider configuration
provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.credentials.kube_config.0.host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.cluster_ca_certificate)

  depends_on = [null_resource.configure_kubectl]
}

# Helm provider configuration
provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.credentials.kube_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.cluster_ca_certificate)
  }

  depends_on = [null_resource.configure_kubectl]
}

# Kubernetes namespaces
resource "kubernetes_namespace" "ollama_system" {
  metadata {
    name = "ollama-system"
    labels = {
      name        = "ollama-system"
      environment = "production"
    }
  }

  depends_on = [null_resource.configure_kubectl, kubernetes_config_map.v1]
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
    labels = {
      name = "monitoring"
    }
  }

  depends_on = [null_resource.configure_kubectl, kubernetes_config_map.v1]
}

# Test config map to verify Kubernetes connectivity
resource "kubernetes_config_map" "v1" {
  metadata {
    name = "terraform-test"
    namespace = "default"
  }

  data = {
    "test" = "success"
  }

  depends_on = [null_resource.configure_kubectl]
}