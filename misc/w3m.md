
# Notes on w3m Terminal Browser


`w3m -o` displays a list of options, describing everything in the `w3m/config` file.


## Colors
The color options in w3m are generally limited to the basic ANSI terminal colors. These are:

* black
* red
* green
* yellow
* blue
* magenta
* cyan
* white

You can also use terminal as a value, which will use the terminal's 
default color for that particular setting.

Unfortunately, w3m doesn't support hex color codes or extended color schemes out of the box.
It's limited to the basic 8-color ANSI scheme that your terminal emulator interprets.
