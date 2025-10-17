# openwebui-ollama-aks-new

Sharath Anugula Patel 
Sharathpatel87427@zohomail.in

**step-1**
# Check if tools are installed
az --version          # Azure CLI
terraform --version   # Terraform
kubectl version       # Kubernetes CLI
docker --version      # Docker
---
**Step:2**
# Login to Azure
az login

# Verify subscription
az account show

# Set subscription (if multiple)
az account set --subscription 'Subscription ID'
---
**step-3**
# Clone your repository
git clone https://github.com/AnugulaSharathKumar/openwebui-ollama-aks-new

cd openwebui-ollama-aks-new

# Make all scripts executable
chmod +x scripts/*.sh

# Create necessary directories
mkdir -p backups logs
---
**Setup Terraform Configuration**

cd terraform

# Copy and edit terraform variables
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars with your values
nano terraform.tfvars

---
# Option A: Run individual script
./scripts/terraform-apply.sh

# Option B: Manual steps
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars -auto-approve
