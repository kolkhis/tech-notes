# Looping in Terraform

Hashicorp Language (HCL) supports the use of internal interations (loops).  

We can loop in HCL by using either `count` or `for_each`.  


## Looping with `count`

This is one of the easiest ways to loop, as it just loops over a range of
numbers.  

If we need multiple identical VMs, this type of loop is perfect.  

```hcl
resource "proxmox_vm_qemu" "vm" {
  count = 3
  name = "test-vm-${count.index + 1}"
  target_node = "home-pve"
  ...
}
```
At the top of the resource block, we specify a `count` of `3`.
This makes three copies of the VM resource.  

When looping, we can tap into the current loop number with `count.index`, using
the same notation as Bash (`${...}`).  
Within these braces, we can do some basic operations (i.e., addition). 

By default, HCL uses zero-based indexing for its loops, so we add `1` to get
the desired number.   

This will create:

- `test-vm-1`
- `test-vm-2`
- `test-vm-3`

All with identical configurations.  

### Padding with Zeroes

Say we want our naming convention to use something like `control-node01`,
`control-node02`, etc., but we don't want to hardcode the leading zero in. If
the count gets to ten, we'd end up with `control-node010`. That's not what we
want.  

We can use the `format()` builtin function to pad the number with zero(es).  
```hcl
resource "example" "example-name" {
  count = 2
  name = format("control-node%02d", count.index + 1)
}
```
This format of `%02d` will pad the left side with zeroes, as long as the
padding doesn't exceed 2 digits.  


## Resources
- <https://developer.hashicorp.com/terraform/language/meta-arguments>
- <https://developer.hashicorp.com/terraform/language/meta-arguments/for_each>
- <https://developer.hashicorp.com/terraform/language/meta-arguments/count>

