
# Installing Fonts on Linux (Mint)



Download the font.


---

Fonts will be stored in `/usr/share/fonts/` in the appropriate 
subdirectory (usually truetype). 
i.e., `/usr/share/fonts/truetype/` 


Move the font to the system's font directory:
```bash
sudo mv ~/Documents/Fonts/RobotoMono /usr/share/fonts/truetype/
```

---

Then, update the font cache:
```bash
sudo fc-cache -f -v
```


If installing for the terminal, open a new terminal instance
and the font should be listed in "Preferences."


