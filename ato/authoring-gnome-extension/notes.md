# Authoring a GNOME Shell Extension
## By Josh Huber (ATO 2025)

Dev's journey as an open source project sole maintainer.  


Outline
1. Linux Desktop and GNOME shell
2. How to make a GNOME extensions
3. how he became a maintainer
4. perpectives as a sole maintainer
5. takeaways

## Linux Desktop

2-5% of global market share is Linux Desktop (based on browser research)
- no incl chromebooks, wsl

### desktop Environments
envs:
- GNOME shell
- kde plasma
- hyprland
- xfce
- cinnamon
- mate
- lxde
- budgie
- cosmic
- lxqt
- pantheon
- unity
- enlightenment

GNOME vs kde:
- GNOME:
    - simpler streamlined cleaner, lower distraction, default in fedora and ubuntu,
      lighter hardware reqs, less directly customizable
- kde: 
    - More granular, customizable powerful, large community, many apps available

### GNOME shell extensions
Fewer builtin features than KDE does. No task bar. There's a dash. 
- Fewer builtin features, customize GNOME by using extensions
- customize GNOME by using extensions
- similar to chome extensions and mozilla addons

Most popular gnome extension is "Dash to Dock".   

33 how to make a gnome extension

gis.guide/extensions has a getting started page

```bash
gnome-extensions create --interactive
```
Code your extension: Requires a bit of Js.  
Test extension locally.  


### demo

```bash
gnome-extensions create --interactive
```
- Set name
- Add Description
- give it UUID (FQDN, e.g., `ato@demo.com`)
- Choose template 

It will show you where it was created. 
You then copy that path, go to that directory, then you modify the files.

It will generate .js, .json, and .css file.  

- extension.js - This is where functionality goes
- metadata.json - Contains metadata (given via the prompt)
- stylesheet.css - Styling

When making changes, you cana test via the 

```bash
dbus-run-session -- gnome-shell --devkit
```

This will launch another instance of a GNOME shell in a window in a dev shell.  

It's essentially another desktop within a window.  

Here you can enable your extension and test it.  
Close the windoow to end the dev shell and resume your terminal.  

## Publishing your GNOME Extension

- Make the source code available publicly (e.g., github)
- Upload that packed extension to the GNOME Extension site
- Extension review process
- Extension goes live
- Maintain your extension
    - you're not *technically* obligated to maintain the extension. But if
      you've got users, you should.  

- Each major GNOME version upgrade intentionally disables extensions.  
- Maintainers must update extension for new GNOME versions.  
- Best case: No code changes are needed, only bmetadata needs updating.  
- Maintainers vary on attention to updates.  
- Update your extension ahead of the ofificial release of new GNOME versions.  
    - Use beta or RC releases of GNOME to do this.  


## Path to Maintainer

Using a GNOME extension to do local IP on the top bar.  
Had shortcomings. Displays wrong address when doing dev work with containers
locally  
Sometimes would show loopback address.  
Showed private VPN addr when VPN was up.  
Extension maintainer seemed inactive and couldn't find alternative.  


Goal: Fix the thing.

Share the thing as open source. Then bug fix and become sole maintainer.  

Ext: LAN IP Address


consideration: When expanding your project, make sure that it's not too much
work to maintain in the future.  

Contributing back to open-source can be rewarding. Utility that has one lil
function, that may be great thing for a lot of people.

Being a maintainer helps make you a better contributor to other projects:
- If we get a feat request with nice tests included and style guide matches,
  that's great. We may see that and then we try to do that for other people


## Takeaways

1. Start small right now. pick something that's small that doesn't have an existing solution (to your liking).  Scratching your own itch by working on something you want is motivating. You're user #1)
2. Control the scsop: You know your resource limites. Stick to it avoid
   burnout.
3. Big projects can come later. don't get paralyzed thinking about a grand
   project. small projects will prob lead you to bigger projects anyway
4. Don't be daunted. You don't need to be an expert or even good at coding.
   More accessible than ever with TY vids and AI code assistants. 
5. Gain skills and exp running your own project. Add it to your resume. 


## Idea
YOu can even remove extensions with an extension. E.g., remove CSS stuff.  


