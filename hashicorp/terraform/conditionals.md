# HCL Conditionals

Hashicorp Language (HCL) supports the use of conditional statements for various
things.  

Conditions can be any expression that resolves to a boolean value.  
We can use builtin functions and HCL conditional operators to perform
conditional checks.  

## Ternary Operator

HCL supports the use of the ternary operator for conditional variable
definitions and checks.  

The basic syntax:
```hcl
condition ? true_val : false_val
```
This is functionally equivalent to the logic flow:  
```bash
if condition then "true_val" else "false_val"
```

So we can use this to, say, give a default value to an empty variable.  
```hcl
var.a == "" ? "default-a" : var.a
```

This checks if `var.a` is an empty string (`var.a == ""`), and if that
condition is **true**, we use the value "`default-a`". If the condition is
false (the variable is not an empty string), then we use the value of the
variable itself, `var.a`.  



## Resources
- <https://developer.hashicorp.com/terraform/language/expressions/conditionals>

