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

## Browse logs and system usage
### Init log
`tail -f /var/log/cloud-init-output.log`
### Ollama service log
`journalctl -u ollama.service -f`
### CPU usage
`htop`

# Configure Continue plugin
In `~/.continue/config.json` set following models
```json
  "models": [
          {
      "title": "codellama:13b-instruct-q4_K_M",
      "provider": "ollama",
      "model": "codellama:13b-instruct-q4_K_M",
      "apiBase": "http://localhost:21434"
    },
	    {
      "title": "codellama:13b-code-q4_K_M",
      "provider": "ollama",
      "model": "codellama:13b-code-q4_K_M",
      "apiBase": "http://localhost:21434"
    }
  ]
```