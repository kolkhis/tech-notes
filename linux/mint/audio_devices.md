

# Audio Devices on Linux Mint

You can access and manipulate audio settings using the `pacmd` command (Pulse Audio cmd).


## Using `pacmd`

```bash
# Display help
pacmd help

# List available audio output devices
pacmd list-sinks

# Set default output device
pacmd set-default-sink (index|name)
```

## Getting Available Output Devices

Pulse Audio (`pacmd`) calls output devices "`sinks`". 


A quick way to get the names of available output devices:
```bash
pacmd list-sinks | grep "name:"
# Or, for just the names:
pacmd list-sinks | grep "name:" | awk '{print $2}'
```
To get their indexes:
```bash
pacmd list-sinks | grep "index:"
```

To see which programs are being streamed to the `sink`:
```bash
pacmd list-sink-inputs
```


## Setting the Default Output Audio Device

You can set the default audio output device using `pacmd set-default-sink`,
followed by either the `name` or `index` of the audio output device listed 
in `pacmd list-sinks`.


## Finding Audio Inputs



