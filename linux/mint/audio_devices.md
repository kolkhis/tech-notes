

# Audio Devices on Linux Mint

You can access and manipulate audio settings using the `pacmd` command (Pulse Audio cmd).

```bash
# Display help
pacmd help

# List available audio output devices
pacmd list-sinks

# Set default output device
pacmd set-default-sink (index|name)

```

