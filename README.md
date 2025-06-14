# ai-ollama-on-vm
Start Ollama on VM in cloud

## Prerequisites
1. Terraform installed
1. ssh key pair generated in `~/.ssh/id_rsa.*`

## Provision environment
Have a look on `variables.tf` and create corresponding `*.auto.tfvars` file with your values.

Initiailze terraform with `terraform init`.  
Provision environment with `terraform apply`.

To destroy environment when no longer needed run `terraform destroy`.

## Open port forwarding to Ollama on the VM
Point local `21434` to `11434` on the VM.  
`ssh -L 21434:localhost:11434 azureuser@<vm-public-ip>`

## Browse logs
`tail -f /var/log/cloud-init-output.log`

# Configure Continue plugin
In `~/.continue/config.json` set following models
```json
  "models": [
    {
      "title": "qwen2.5-coder",
      "provider": "ollama",
      "model": "qwen2.5-coder:latest",
      "apiBase": "http://localhost:21434"
    },
    {
      "title": "codellama:7b-code",
      "provider": "ollama",
      "model": "codellama:7b-code",
      "apiBase": "http://localhost:21434"
    }
  ]
```