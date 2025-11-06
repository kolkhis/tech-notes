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



