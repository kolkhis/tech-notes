# Variables in Terraform

Terraform uses Hashicorp Language (HCL). HCL supports the use of variables.  

Terraform variables are essentially placeholders for values that you can set in 
order to further customize configurations to make them more reusable and dynamic.  

## Supported Data Types

Variables in HCL (Hashicorp Language) support multiple different data types.  

The data types as specified by HCL:

- `string`: Array of characters.  
- `number`: Numeric values.  
    - Referenced as `int`/`float` in provider documentation.  
- `bool`: True/false values.  
- `list`: Array (single vector).  
- `map`: Associative array or dictionary, stores key/value pairs.  
- `tuple`: Immutable single-vector array.  
- `object`: JSON-like data type that can store any number of other data types (maps, lists, etc.) and nest them.  
- `set`: A list of **unique** values.  

## Locals

Local variables can be declared using a `locals` block, typically at the top of
the file. This block is a group of key/value pairs that can be referenced
inside the file it's defined in.  

```hcl title="main.tf"
locals {
  name        = "new-vm"
  os_type     = "ubuntu"
  cpu_type    = "x86-64-v2-AES"
  memory      = 2048
  cpu_cores   = 1
  cpu_sockets = 1
  tags = {
    name = "test-vm"
    env  = "dev"
  }
  storage     = "vmdata"
}
```

These variables can then be referenced in the rest of `main.tf` by using the `local` keyword,
then using dot notation to select the specific variable (e.g., `local.name`)

```hcl
resource "proxmox_vm_qemu" "test_vm" {
    name    = local.name
    memory  = local.memory
}
```

## Input Variables

Input variables are used to pass in values from outside the config/module.  
They're used to assign dynamic values to resource attributes. The difference
between locals and input vars is the input vars allow you to pass values
**before** code execution.    

Input variables are meant to act as inputs to modules. Input variables declared
within modules are used to accept outside values.  

When declaring input variables, we can set attributes:

- `type`: Data type
- `default`: Default value if none is given
- `description`: A description for the var, used to generate documentation for
  the module  
- `validation`: Defines validation rules
    - `condition`
    - `error_message`
- `sensitive`: Boolean used to mask the variable's value anywhere it would be
  displayed (e.g., for API keys)  
- `ephemeral`: Available during runtime, but not stored in `state` or `plan` files.  
    - Good for temporary variables (short-lived tokens, session IDs, etc.).   

We typically set these in a separate `variables.tf` file.  

The basic syntax is:

```hcl title="variables.tf"
variable "<label>" {
  description = "An example variable block"
  type        = "<type>"
  default     = "<default value>"
  sensitive   = true # or false
}
```

The values of the variables can be accessed in `main.tf` (or other) by using
the `var` keyword with dot notation, using the `<label>` as the name of the
variable.  

So for this example:
```hcl title="variables.tf"
variable "testvar" {
  description = "Test variable"
  type = string
  default = "Hello, world"
}
```
We'd access the value of this variable in `main.tf` as follows:
```hcl title="main.tf"
resource "example" "example" {
  name = var.testvar
}
```

---

If we are using a data type that stores multiple values, we need to specify 
the type for each value.  

For the `list` type, we'd need to specify the list item's attributes.
Same with `object` types, `map` types, `set` types, and `tuple` types.  
```hcl
variable "example_list" {
  description = "An example list variable in a variable block"
  type        = list(string)
  default     = "<default value>"
  sensitive   = true # or false
}

variable "example_object" {
  description = "An example object variable in a variable block"
  type        = object({
    name    = string
    age     = number
    enabled = bool
    tags    = list(string)
  })
  default     = {
    name = "john"
    age  = 30
    enabled = true
    tags = ["engineer", "male", 30]
  }
  sensitive   = true # or false
}

variable "example_tuple" {
  description = "An example tuple variable in a variable block"
  type        = tuple([string, number, bool])
  default     = ["item1", 33, false]
}

variable "example_set" {
  description = "An example set variable in a variable block"
  type        = set(string)
  default     = ["item1", "item2", "item3"]
}

variable "example_map" {
  description = "An example map variable in a variable block"
  type        = map(string)
  default     = {
    key1 = "value1"
    key2 = "value2"
  }
}
```

---

### Complex Input Variables

We can even use a `map` of objects or `list` of objects when declaring input variables.  
These ones have a bit more complexity involved, but they're powerful.  
```hcl
variable "example_object_map" {
  description = "An example map of objects in a variable block"
  type        = map(object({
    key1 = string
    key2 = string
  }))
  default     = {
    "vm1" = {
      key1 = "value1"
      key2 = "value2"
    },
    "vm2" = {
      key1 = "value1"
      key2 = "value2"
    },
    "vm3" = {
      key1 = "value1"
      key2 = "value2"
    }
  }
}
# Note we're doing `map()`, then `object()` nested within.  
# The `map` objects `vm1`/`vm2` have quotes, but the object keys themselves do not.  
# Also note the commas between map items.  

variable "example_object_list" {
  description = "An example list of objects in a variable block"
  type        = list(object({
    key1 = string
    key2 = string
  }))
  default = [
    {
      key1 = "value1"
      key2 = "value2"
    },
    {
      key1 = "value1"
      key2 = "value2"
    },
    {
      key1 = "value1"
      key2 = "value2"
    }
  ]
}
```

### Variable Validation

We can specify conditions that must be met for a variable's value to be valid.  

Within the `variable` block, we'd specify the `validation` keyword, along with
some code to be executed to test the value.  
```hcl
variable "name" {
  description = "The name of a VM or something"
  type        = string
  default     = "new-vm"
  validation = {
    condition     = length(var.name) > 1
    error_message = "We need at least 2 characters for the name!"
  }
}
```


## Environment Variables

Input variable values can be set by using Terraform environment variables.  

All we need to do in order to pass environment variables to Terraform is to
prepend the variable's name with `TF_VAR_<name>`.  

When setting variables this way, the `<name>` needs to match the variables
declared in `variables.tf`.  

```bash
export TF_VAR_proxmox_api_key='asdfasdfasdfasdf'
```
This will automatically be picked up by Terraform when we have an entry in
`variables.tf`.  
```hcl
variable "proxmox_api_key" {
  description = "API key for Proxmox"
  type        = string
  sensitive   = true
}
```

### Reserved Environment Variables

Terraform uses a bunch of different environment variables to customize
behavior.  

- `TF_VAR_name`: Set variables to be used (by name) within Terraform configurations.  
    - These are checked **last** for a value.  

- `TF_LOG`: Enables logging (to stderr). Set its value to a log level to see
  those logs.  
  ```bash
  export TF_LOG=trace  # | debug | info | warn | error
  # to disable, unset or set to 'off':
  unset TF_LOG
  export TF_LOG="off"
  ```
    - `TF_LOG_CORE`: Enables logging for **only** Terraform, will *not* output 
      provider plugin logs.   
    - `TF_LOG_PROVIDER`: Enables logging for **only** the provider plugin, will *not* output
      Terraform core logs.   

- `TF_LOG_PATH`: Path to file where the logs will output to.  
    - `TF_LOG` needs to also be set for any logging to be enabled.  


- `TF_INPUT`: When set to `false` or `0`, Terraform commands assume the CLI
  argument `-input=false`.  

- `TF_CLI_ARGS`: Specify additional arguments to be used when running 
  **any and all** Terraform commands.  
    - These args are placed directly after the subcommand, and before any
      flags/options on the command line.  
      For instance:
      ```bash
      export TF_CLI_ARGS="-input=false"
      terraform apply -force
      # Expands to:
      terraform apply -input=false -force
      ```

- `TF_CLI_ARGS_name`: Specify additional arguments to be used when running a
  specific Terraform command (`name`).  
    - Same placement strategy as `TF_CLI_ARGS`, and will only affect the given `name` subcommand.  
      ```bash
      export TF_CLI_ARGS_plan="-refresh=false"
      terraform plan
      # Expands to:
      terraform plan -refresh=false
      ```

- `TF_DATA_DIR`: The directory where Terraform will store its data. This
  defaults to `./.terraform` (in the current dir).    
    - Setting this could be useful if the pwd isn't writable.  
    - If setting this, set before running the initial `terraform init`.  

- `TF_WORKSPACE`: Sets the Terraform workspace.  
    - Automation-friendly alternative to using:
      ```bash
      terraform workspace select some_workspace
      ```

- `TF_IN_AUTOMATION`: If set (to any value), Terraform will avoid suggesting
  commands to run next.  

- `TF_REGISTRY_DISCOVERY_RETRY`: Set the max number of retries to the remote 
  registry client.  

- `TF_REGISTRY_CLIENT_TIMEOUT`: Timeout for requests to the remote
  registry. Defaults to 10 seconds.  

- `TF_STATE_PERSIST_INTERVAL`: Interval in seconds that TF attempts to persist
  state to a remote backend during `apply`. Defaults to 20 seconds.  

- `TF_CLI_CONFIG_FILE`: The location for the Terraform runtime configuration file. 
    - Called `.terraformrc`, or `terraform.rc` on Windows.  
    - Old version of this variable was `TERRAFORM_CONFIG`, but that one is deprecated.  

- `TF_PLUGIN_CACHE_DIR`: Enables and sets the `plugin_cache_dir` setting in the 
  Terraform CLI configuration.   
    - Equivalent to setting [`plugin_cache_dir` in your `.terraformrc`](https://developer.hashicorp.com/terraform/cli/config/config-file#provider-plugin-cache)


## `.tfvars`
Any file with the `.tfvars` file extension (or simply `.tfvars` by itself) will
be used to define values for the variables declared inside `variables.tf`.  

The syntax will be the same as other HCL variable definitions.  

For example, a `terraform.tfvars` file with the following definition:
```hcl title=".tfvars"
proxmox_api_key = "asdfasdfasdf"
```

Will populate the variable defined inside `variables.tf`:
```hcl
variable "proxmox_api_key" {
  description = "API key for Proxmox"
  type        = string
  sensitive   = true
}
```



## Resources
- <https://developer.hashicorp.com/terraform/language/block/variable>
- <https://developer.hashicorp.com/terraform/language/block/variable#basic-variable-declaration>
- <https://developer.hashicorp.com/terraform/cli/config/environment-variables>
- <https://developer.hashicorp.com/terraform/language/parameterize#environment-variables>
- <https://spacelift.io/blog/how-to-use-terraform-variables>
- <https://developer.hashicorp.com/terraform/cli/config/config-file>
- <https://developer.hashicorp.com/terraform/cli/config/config-file#provider-plugin-cache>

