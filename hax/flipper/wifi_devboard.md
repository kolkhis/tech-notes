
# WiFi Dev Board for the Flipper Zero

### Marauder - WiFi Dev Board Firmware
The WiFi dev board module for the Flipper Zero comes with
the Blackmagic firmware by default.

Changed baud rate to 921600. 

Serial USB Terminal (Android App) will allow you to interface
with the command line.  



## Making your own Sub-GHz C1101 Dev Board

Antenna looks to be a full wave whip antenna (~69cm) which will give
an increase in signal gain. 

However you'd get better results with that, a 1/4 or 1/2 wave
antenna (more compact, less conspicuous) and an external amplifier.

One tuned to 433MHz and bidirectional ideally. Airbuddy make those. 

If you can solder and have a soldering station you can make one for under $20, get
some right angle pin headers, some basic prototyping board, a CC1101 dev board,
a 5V to 3.3V low dropout (LDO) regulator, and antenna and an old, broken USB cable
to cannibalise thin (sheathed) copper wires from.

Optional airbuddy amplifier or other tuned, bidirectional amp. 

If you can't solder, get a soldering station and learn to solder, just
buy a bunch of cheap through hole soldering projects and make them.

Soldering is easy to learn for simple things. 

All CC1101 boards from me last checking are 433MHz tuned other than the
rabbit labs 900MHz one.

The flipper has a wide frequency range due to it having radio switches as
part of the internal radio circuit.
