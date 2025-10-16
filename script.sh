# Option A: Run individual script
./scripts/terraform-apply.sh

# Option B: Manual steps
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars -auto-approve
