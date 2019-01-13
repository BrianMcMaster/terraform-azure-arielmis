# terraform-azure-arielmis

* Download main.tf to local folder.

* Install Terraform
Download and install Terraform
REF: https://learn.hashicorp.com/terraform/getting-started/install.html

* Install Azure CLI
brew update && brew install azure-cli
az login
REF: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-macos?view=azure-cli-latest

* CD to folder with main.tf

* `terraform init`
This will load the Azure provider and create terraform state file.

* `terraform apply`
This will create the resources on Azure

* `terraform destroy`
This will destroy all the resources on Azure



## Terraform
What is Terraform?
https://www.terraform.io/intro/index.html

## Terrafrom Providers
https://www.terraform.io/docs/providers/vsphere/index.html
https://www.terraform.io/docs/providers/aws/

## Core commands
https://www.terraform.io/docs/commands/index.html
* `terraform help`
* `terraform get` - Download or update modules
* `terraform init` - Initialize a working directory
* `terraform plan` - Create an execution plan to see what will done. Check this before "terraform apply".
* `terraform apply` - Applies plan, prompts the user before performing a terraform apply.
* `terraform apply -target <module.resource name>` - Apply only to a specific resource.
* `terraform destroy` - Destroy plan, then prompts the user before performing a terraform destroy
* `terraform import`  - Import a resource to be managed by Terraform.

## Basic instruction examples
1. cd `{terraform_provider}/{environment}/{function}`
2. run command `terraform init`
3. run command `terraform apply`
4. run command `terraform destroy`

## Files and other folders in the configuration
* All .tf files in a folder are combined during a terraform command. The files can be any name and you can have as many as you want. To keep things simple, we are trying to use the following in most instances.
* `main.tf` - Defines the "resources" to build such as vm, networking, etc.
* `variables.tf` - Defines the variables used in the configuration.
* `outputs.tf` - Output variables provide a means to support Terraform end-user queries. This allows users to extract meaningful data from among the potentially massive amount of data associated with a complex infrastructure.
* `data.tf` - Data sources represent read-only views of existing infrastructure intended for semantic use in Terraform configurations.
* `terraform.tfstate` - These are the state files or flat database used by Terraform. Care should be taken to consider locking issues (by default, these files are not locked to prevent sharing) and if these files are lost the infrastructure continues to run but will not longer be managed by Terraform. TFSTATE file per environment and should be stored in AWS or Terraform Enterprise. Before progressing, it is also very important to understand https://www.terraform.io/docs/state/index.html, how it is fits in and the criticality of state file management.

