# ai-ollama-on-vm
Start Ollama on VM in cloud

## Prerequisites
1. Terraform installed
1. ssh key pair generated in `~/.ssh/id_rsa.*`

## Provision environment
Have a look on `variables.tf` and create corresponding `*.auto.tfvars` file with your values.

Initiailze terraform with `terraform init`.  
Provision environment with `terraform apply`.

## Open port forwarding to Ollama on the VM
Point local `21434` to `11434` on the VM.  
`ssh -L 21434:localhost:11434 azureuser@<vm-public-ip>`

## Brows logs
`tail -f /var/log/cloud-init-output.log`
