
# Taking in Arguments from the Command Line in Bash  

## The `shift` Command  

Processing CLI arguments is best done using the `switch` command.  
* The `shift` command will remove the first argument from the list.  
* This will mean the **next** argument is now in `$1`.  
* All the remaining arguments will be shifted from `$n` to `$n-1`.  
    * `$2` becomes `$1`, `$3` becomes `$2`, and so on.  

## Getting CLI Options, Arguments, and Flags  
1. Use a `while` loop to loop over the arguments.  
    * ```bash  
        while [[ "$1" ]]; do  
            echo "Code to process the arguments..."  
            # Now move on to the next argument:  
            shift 
        done  
    * The `shift` command will remove the first argument from the list.  
    * This will mean the **next** argument is now in `$1`.  
    * All the remaining arguments will be shifted from `$n` to `$n-1`.  


2. Use the regex comparison operator `=~` to check if the argument starts with a dash `-`.  
    * ```bash  
        while [[ "$1" =~ ^- ]];  

3. Check that the argument isn't `--` on its own.  
    * ```bash  
        while [[ "$1" =~ ^- && ! "$1" == "--" ]];  
    * The `--` flag is used to indicate that all the arguments have been given.

4. If it does, use a `switch`/`case` to handle the flag  
    * ```bash  
        while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do  
            case $1 in  
                (-v | -version)  
                    printf "%s" "$version";  
                    ;;  

5. Use `shift` to pop the argument off the argument list.  
    * This will mean the **next** argument is now in `$1`.  
    * All the remaining arguments will be shifted from `$n` to `$n-1`.  


```bash  
while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do 
    case $1 in  
      -V | --version)  
        echo "$version";  
        exit;  
        ;;  
      -s | --string )  
        shift; 
        string=$1;  
        ;;  
      -f | --flag )  
        flag=1;  
        ;;  
    esac;  
    shift;  
done  
if [[ "$1" == '--' ]]; then  
    shift;  # Clean up the argument list 
fi  
```


## Flags that take a value  
If you have a flag that takes a value, use the `shift` command to get the value:  
```bash  
    case $1 in  
      -i | --input-file)  
        shift;  # Pop the -i or --input-file flag out of the argument list  
        INPUT_FILE="$1";  
        shift;  # Now pop the value out of the argument list  
        ;;  
```




