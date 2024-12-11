
# Connecting to twitch via IRC with SSL
This short how-to is geared toward Linux users.  
This includes WSL2.  


## Table of Contents
* [Install Weechat](#install-weechat) 
* [Get OAuth Token](#get-oauth-token) 
* [Connecting to twitch with weechat](#connecting-to-twitch-with-weechat) 
    * [Adding the twitch server](#adding-the-twitch-server) 
    * [Connect & Disconnect Commands for Twitch IRC](#connect--disconnect-commands-for-twitch-irc) 
* [Some Useful Keybinds and Commands](#some-useful-keybinds-and-commands) 
* [tl;dr, just gimme the commands](#tldr-just-gimme-the-commands) 



## Install Weechat
Use your package manager to install `weechat`.
```bash
sudo apt-get install weechat -y
```

## Get OAuth Token
Get your oauth token [here](https://twitchtokengenerator.com/).  
The `Access Token` is the OAuth token you need to connect.  


## Connecting to twitch with weechat

### Adding the twitch server

`/server add <name>` adds a server with a given name. 
Let's add the twitch server. You'll need your OAuth token, so be sure you generated one!  
```bash
/server add twitch irc.chat.twitch.tv/6697 -ssl -ssl_verify -password=oauth:youraccesstoken -nicks=yourusername
```

Breakdown:  
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
* Connect to twitch:
  ```bash
  /connect twitch
  ```

* Then join any given channel with `/join #channelName`:
  ```css
  /join #rwxrob
  ```

* Save your configuration:
  ```bash
  /save
  ```
    * Just be aware, this will save your oauth token in plaintext in `~/.config/weechat/irc.conf`.  
      

---

## Some Useful Keybinds and Commands

* Use `Alt-<NUM>` to switch channels (channels are numbered, shown on left). 
    * `Alt-1` to show the main system buffer.  
* `/quit` to close weechat
* `/part` to disconnect from a channel.
* `/close` to close a buffer (the channel window). 

---

* To set up autoconnect after adding the server, use `/set`:
  ```bash
  /set irc.server.twitch.autoconnect on
  ```
* WeeChat supports tab completion for commands.  


## tl;dr, just gimme the commands
* [Generate an oauth token here](https://twitchtokengenerator.com/).  
    * Grab the `Access Token`

* Install and launch:
  ```bash
  sudo apt-get install weechat -y
  weechat
  ```

* Add the Twitch server (inside weechat)
  ```bash
  /server add irc.chat.twitch.tv/6697 -ssl -ssl_verify -nicks=YOUR_USERNAME -password=oauth:YOUR_TOKEN -autoconnect
  ```
    * You *must* include the `oauth:` in the `-password`.  

* Connect to a Twitch channel
  ```css
  /connect #rwxrob
  ```

* To leave a channel:
  ```bash
  /part
  /close
  ```
* To quit weechat:
  ```bash
  /quit
  ```

Now you've got a minimal `weechat` setup for twitch!

