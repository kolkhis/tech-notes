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
- <https://spacelift.io/blog/how-to-use-terraform-variables>

