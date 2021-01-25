# Desafio Terraform
Subir uma máquina virtual no Azure ou AWS instalando o MySQL e que esteja acessível no host da máquina na porta 3306.
Se quiser usar o Ansible para configurar a máquina é interessante mas não obrigatório, pode configurar via script também.
Enviar a URL GitHub do código.


### Necessário
`brew tap hashicorp/tap`
`brew install hashicorp/tap/terraform`
`brew update && brew install azure-cli`

### Para se logar na plataforma
`az login`

### Comandos 
- `terraform init`
- `terraform plan`
- `terraform apply`
- `terraform destroy`

### Users/Passwords
- SSH (azureUser/Pass1234)
- MySQL (admin/admin)

Ao rodar o `terraform apply` ele mostra o IP Público para a máquina com o MySql instalado.