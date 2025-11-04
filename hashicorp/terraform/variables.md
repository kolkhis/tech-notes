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


