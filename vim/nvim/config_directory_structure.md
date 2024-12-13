# Lua Config Directory Structure

## Example Structure
```bash
    ~/.config/nvim
    |-- after/
    |  |-- plugin/
    |-- ftplugin/
    |-- lua/
    |  |-- myluamodule.lua
    |  |-- other_modules/
    |     |-- anothermodule.lua
    |     |-- init.lua
    |-- plugin/
    |-- syntax/
    |-- init.lua
```

## `~/.config/nvim/`
### `~/.config/nvim/lua`
The directory structure for lua files:
```bash
    ~/.config/nvim
    |-- after/
    |-- lua/
    |  |-- myluamodule.lua
    |  |-- other_modules/
    |     |-- anothermodule.lua
    |     |-- init.lua
    |-- init.lua
```

Anything that goes in `~/.config/nvim/lua` can be loaded with `require`
Then the following Lua code will load `myluamodule.lua`:
```lua
require("myluamodule")
```
Do not include the `.lua` extension.  

Loading other modules in subdirectories (`other_modules/anothermodule.lua`) is done with `/` or `.`:
```lua
require('other_modules/anothermodule')
-- or
require('other_modules.anothermodule')
```


Any directory that has an `init.lua` file can be `require`d directly, without
having to specify the name of the file:
```lua
require('other_modules') -- loads other_modules/init.lua
```

So, this structure:
```bash
    ~/.config/nvim
    |-- after/
    |-- ftplugin/
    |-- lua/
    |  |-- myluamodule.lua
    |  |-- kolkhis/
    |     |-- set.lua
    |     |-- remap.lua
    |     |-- init.lua
    |-- plugin/
    |-- syntax/
    |-- init.lua
```
If you have, in `~/.config/nvim/lua/kolkhis/init.lua`:
```lua
require('set')
require('remap')
```

You can `require` it in `~/.config/nvim/init.lua`
```lua
require('kolkhis') -- just the directory name, since there is an init.lua inside it
```
Then everything you `require`d in `lua/kolkhis/init.lua` will be loaded.  

### `~/.config/nvim/after/plugin/`
Anything in this directory will be automatically loaded *after* everything else.   


