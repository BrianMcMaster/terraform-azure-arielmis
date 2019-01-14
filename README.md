# terraform-azure-arielmis

## Working example of a Windows RDP VM with networking on Azure.

* Clone repo or copy the one simple file, main.tf to local folder.

## Install Terraform
* Download and extract to a location such as /usr/local/bin
* REF: https://learn.hashicorp.com/terraform/getting-started/install.html

## Install Azure CLI
* `brew update && brew install azure-cli`
* az login
* REF: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-macos?view=azure-cli-latest

## CD to the folder with main.tf
* Edit main.tf and add username and password to the default variables.
* Run `terraform init` from the same directory.
This will load the Azure provider and create the Terraform state file.
* `terraform apply`
This will create all the resources on Azure
* `terraform destroy`
This will destroy all the resources on Azure



## Terraform
What is Terraform?
https://www.terraform.io/intro/index.html

## Terraform Providers
https://www.terraform.io/docs/providers/azurerm/index.html

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

## Common commands:
  * https://www.terraform.io/docs/commands/index.html
*    `apply`              Builds or changes infrastructure
*    `console`            Interactive console for Terraform interpolations
*    `destroy`            Destroy Terraform-managed infrastructure
  * https://www.terraform.io/intro/getting-started/destroy.html
*    `fmt`                Rewrites config files to canonical format
*    `get`                Download and install modules for the configuration
*    `graph`              Create a visual graph of Terraform resources
*    `import`             Import existing infrastructure into Terraform
*    `init`               Initialize a new or existing Terraform configuration
*    `output`             Read an output from a state file
*    `plan`               Generate and show an execution plan
*    `providers`          Prints a tree of the providers used in the configuration
*    `push`               Upload this Terraform module to Terraform Enterprise to run
*    `refresh`            Update local state file against real resources
*    `show`               Inspect Terraform state or plan
*    `taint`              Manually mark a resource for recreation
*    `untaint`            Manually unmark a resource as tainted
*    `validate`           Validates the Terraform files
*    `version`            Prints the Terraform version
*    `workspace`          Workspace management

### All other commands:
*    `debug`              Debug output management (experimental)
*    `force-unlock`       Manually unlock the terraform state
*    `state`              Advanced state management

### Other common examples:
  * `terraform help`
  * `terraform get -update` - Download or update modules
  * `terraform init -upgrade` - Upgrades the provider.
  * `terraform import vsphere_virtual_machine.tf_windowsimport /den-1a.us.sans.org/vm/tf_windowsimport`
  * `terraform import module.p-4-s3-pac-1a.aws_s3_bucket.a p-4-s3-pac-1a`
  * `terraform plan -var-file=./terraform.tfvars`
  * `terraform apply -state=./terraform.tfstate -var-file=./terraform.tfvars`
  * `terraform destroy -state=./terraform.tfstate -var-file=./terraform.tfvars`
  
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
