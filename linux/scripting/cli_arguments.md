
## Getting CLI Options, Arguments, and Flags
1. Use a `while` loop to loop over the arguments
    * ```bash
        while [[ "$1" ]];
1. Use the regex comparison operator `=~` to check if the argument starts with a dash `-`.
    * ```bash
        while [[ "$1" =~ ^- ]];
1. Check that the argument isn't `--` on its own.
    * ```bash
        while [[ "$1" =~ ^- && ! "$1" == "--" ]];
1. If it does, use a `switch`/`case` to handle the flag
    * ```bash
        while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do
            case $1 in
                (-v | -version)
                    printf "%s" "$version";
                    ;;
1. Use `shift` to pop the argument
    * This will mean the next argument is now in `$1`
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
    shift;  
fi  
```

