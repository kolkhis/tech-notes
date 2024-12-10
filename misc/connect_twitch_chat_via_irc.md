
# Connecting to twitch via IRC with SSL

Syntax for adding a server:
```bash
/server add <server_name> server_host/port -ssl -ssl_verify -nicks=username
```
With twitch you'll also use `-password=oauth:your_token`


## Table of Contents
* [Get OAuth Token](#get-oauth-token) 
* [Connecting to twitch with weechat](#connecting-to-twitch-with-weechat) 
    * [Adding the twitch server](#adding-the-twitch-server) 
    * [Connect & Disconnect Commands for Twitch IRC](#connect--disconnect-commands-for-twitch-irc) 

## Get OAuth Token
Get your oauth token [here](https://twitchtokengenerator.com/).  
The `Access Token` is the OAuth token you need to connect.  


## Connecting to twitch with weechat

### Adding the twitch server

Launch weechat, then use `/` to execute commands.  
`/server add <name>` adds a server with a given name. 
```bash
/server add twitch irc.chat.twitch.tv/6697 -ssl -ssl_verify -password=oauth:youraccesstoken -nicks=yourusername
```
* `twitch`: The name you give to the server. This is what you will `/connect` to.  
* `irc.chat.twitch.tv/6697`: The link/port to the server. `6697` is the secure port.  
- `-ssl`: Enables SSL/TLS for a secure connection.
- `-ssl_verify`: Enables SSL certificate verification for security.
* `-password=oauth:youraccesstoken`: The password that will be used to connect to the server.  
    * This must contain the `oauth:` part, since you're using an access token.  
* `-nicks=username`: The username of your twitch account.  

Optionally, you can add `-autoconnect` to connect to this server when `weechat` launches.  


### Connect & Disconnect Commands for Twitch IRC
Use `/connect twitch` and `/disconnect twitch` as necessary.  
To set up autoconnect after adding the server, use `/set`:
```bash
/set irc.server.twitch.autoconnect on
```
- WeeChat support tab completion for commands.  

Connect to twitch:
```bash
/connect twitch
```

Then join any given channel with `/join #channelName`:
```css
/join #channelName
```

---




