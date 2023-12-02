
# Connecting to twitch via IRC with SSL

## Get OAuth Token
Get your oauth token [here](https://twitchapps.com/tmi/).

## Set the client up for Twitch
> Example using `irssi`, using SSL  

### Set up the Server Block
```lua
-- Server block
server = {
    address = "irc.chat.twitch.tv";
    chatnet = "twitch";
    port = "6697";
    password = "oauth:changeme";
    use_ssl = "yes";
    ssl_verify = "yes";
    autoconnect = "no";
}
```

### Set up the Chatnet Block
```lua
-- Chatnet block
chatnets = {
    twitch = {
        type = "IRC";
        nick = "your_twitch_username";
    };
}
```

## Connect & Disconnect Commands for Twitch IRC
Use `/connect twitch` and `/disconnect twitch` as necessary.  
But if you're dedicated, just set `autoconnect = "yes"`.

---


## LCOLONQ IRC Channel
`#cyberspace on IRC at colonq.computer:26697 (over TLS)`
