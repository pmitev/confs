# Test

## Examples 
https://github.com/diodonfrost/terraform-openstack-examples

## Documentation
https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/compute_instance_v2


## Terraform hints

```bash
terraform init
terraform plan    # to check 
terraform apply

terraform apply -refresh-only  # to fetch the new values and changes

terraform destroy
```

# Ansible hints
```bash
ansible-playbook 01.configure-VMsOS.yaml --tags "os,docker"
```
