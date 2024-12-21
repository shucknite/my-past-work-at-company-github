

### Deploy a component 
```
terraform init -var-file='../variables/dev.tfvars'
terraform plan -var-file='../variables/dev.tfvars' -out='../variables/terraform-dev.tfplan'
terraform apply "../variables/terraform-dev.tfplan"
terraform destroy -var-file='../variables/dev.tfvars'
```

###  Documentación 

https://www.terraform.io/docs/commands/apply.html