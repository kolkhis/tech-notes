
# ANSI Color Control Sequences  

The ANSI color control sequences are used to change the text color  
and background color of the terminal.  
 
Each number in the control sequence represents a way to customize the 
foreground (text) or background.  


## Basic Syntax  
 
The basic syntax for an ANSI color control sequence is:  

```bash  
printf "\e[<STYLE_CODE>m"
```
* `\e` represents the escape character, which begins the sequence.  
* `<STYLE_CODE>` is a number (or series of numbers separated by semicolons) that specifies the color or style.  
* `m` indicates the end of the sequence.  

## Common Style Codes  

* Text Styles and Defaults  
    * `0`: Reset all styles to default.  
    * `1`: Bold.  
    * `4`: Underline.  
    * `5`: Blink (not widely supported).  
    * `7`: Inverse (swap foreground and background colors).  
    * `39`: Default foreground (text) color.  
    * `49`: Default background color.  

* Standard Text Colors (30-37, 90-97)  
    * `30` to `37`: Standard foreground colors.  
    * `40` to `47`: Standard background colors.  
    * `90` to `97`: Bright (or bold) mode for 16-color foreground colors.  
    * `100` to `107`: Bright (or bold) mode for 16-color background colors.  

* 256-Color Mode  
    * `38;5;<COLOR_CODE>`: Set the foreground color in 256-color mode.  
    * `48;5;<COLOR_CODE>`: Set the background color in 256-color mode.  
    * `<COLOR_CODE>` ranges from `0` to `255`.  


## Standard Colors (8 color)  
The foreground (`30-37`) and background (`40-47`) colors use 8 "standard" colors.  
 
The 8 standard colors are:  
* `0`: Black  
* `1`: Red  
* `2`: Green  
* `3`: Yellow  
* `4`: Blue  
* `5`: Magenta  
* `6`: Cyan  
* `7`: White  


## Formatting the Style Code

The style code can be formatted in several ways. 
As long as the numbers given match the ones above, the order doesn't matter  
all that much.  

---

I generally format the style code like this:
```bash  
printf "\e[<TEXT_STYLE>;<COLOR_MODE>;<COLOR>]"  
```
* `<TEXT_STYLE>` is a number that specifies the text style (`1`-`7` or `0`).  
    * There can be multiple text styles, separated by semicolons.  
* `<COLOR_MODE>` will specify the color mode (i.e., if using 256-color).  
    * This can be `38;5` or `48;5` for 256-color mode foreground and background respectively.  



### Examples  
```bash  
printf "\e[1;5;31;40m---Testing a color code---\e[0m"  
```
* `\e[`: The start of the sequence  
    * This can also be `\033[`
* `1;5;`: Specifies bold and blinking text (styles `1-7`))  
* `31;`: Specifies red text (foreground `30-37`)  
* `40`: Specifies grey/black background (background `40-47`)  
* `m`: The end of the sequence  

* `\e[0m`: Resets all styles to default.  


---  


### 256-colors  

38; indicates "foreground"  
5; indicates "256-color"  
```bash  
SYNTAX="\e[38;5;${COLOR_CODE}m"  
# or, if used in your prompt customization:  
PS1_SYNTAX="\[\e[38;5;${COLOR_CODE}m\]"  
0-7: Standard colors  
8-15: Bright colors  
16-231: 6x6x6 RGB cube  
232-255: Grayscale  
```

