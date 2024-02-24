
# Radio Waves and RFID Types

## Radio Waves

The electromagnetic spectrum is composed of various frequencies of
waves that are produced using electromagnetic energy.  

A radio wave is essentially a disturbance through space that carries
energy from one place to another.  


### Oscillation Rate

* Radio waves `oscillate`, in that, while traveling the energy continuously 
  rises and falls in intensity.  

* This oscillation is what is typically depicted as a wave pattern
  consisting of `peaks` (highs) and `troughs` (lows).  

* The path from trough to trough, or peak to peak, is considered a
  full wave `cycle.`

* The number of `cycles` that take place in one second is known as
  the wave’s `rate of oscillation`.

### Frequency

Radio waves are characterized by `frequency` and `wavelength`.  

Frequency is measured in `Hertz` (`Hz`), 
* One `Hertz` is equal to one full wave cycle per second;
  so, frequency is dependent upon the wave’s `oscillation rate`.

### Equation for a wave's oscillation rate
```
Frequency = 865 MHz
Constant: 1 Megahertz = 10^6 Hertz (1 million Hertz)

865 * 10^6 = 865,000,000 Hz (865 million Hertz)
```

865 MHz is equal to 865,000,000 Hz, which means the oscillation rate
is 865,000,000 cycles per second.  


### Equation for a wave's wavelength
Wavelength is measured in meters and is found using the formula:
```
Frequency = 865 MHz
Constant: 1 Megahertz = 10^6 Hertz (1 million Hertz)
Speed of Light: 299,792,458 Meters/second

Wavelength = Speed of Light (m/s) / Frequency in Hertz (Hz)
299,792,458 / 865,000,000 = .3468 meters = 34.68 centimeters

For quick calculations, you can simplify:
300 / 865 = .3468 meters = 34.68 centimeters
```

## Wavelength

Within the radio wave subset of the RF spectrum, there are
eight designated frequency bands.

* Very low frequency
* Low frequency
* Medium frequency
* High frequency
* Very high frequency
* Ultra-high frequency
* Super high frequency
* Extremely high frequency

Starting at the left side of the spectrum and moving right, the wavelength
gradually decreases.  

---

Very low frequency (`VLF`), the first frequency range on the left side of 
the spectrum, has an average wavelength of around 55,000 meters.  

That means that a `VLF` wave, from one `peak` to another (or one `trough` to another),
has an average distance of 55,000 meters, or around 500 U.S. football fields
stacked together.  

Because radio wavelengths correlate with the speed of data transmission 
(i.e., the longer the wavelength, the slower the data transmission and
vice-versa), `VLF` waves result in very low read rates.

Therefore, `VLF` is not used commonly for RFID applications.

---

Of the eight frequencies on the radio wave band, there are three that 
are typically used for RFID applications:


* Low frequency (LF)
* High frequency (HF)
* Ultra-high frequency (UHF)


## Low Frequency (LF)
### About the LF Band
The Low Frequency, or LF band, is between 30 kHz and 300 kHz with long
wavelengths of around 2,400 meters

Because there are multiple types of signals communicating on this 
band, LF RFID systems are only allowed to use the small range between
125 - 134 kHz.  

The large wave size allows LF waves to penetrate metal and water which is 
unique to this frequency band.

Although LF RFID has a long wavelength, the read range is shorter than 
both HF and UHF RFID – only extending from a couple centimeters, up to
about 50 centimeters in ideal conditions.  
The short read range is due to dependence on magnetic coupling.

Things to consider:
* LF tags are generally more expensive than HF and UHF RFID tags.
* These are powered solely via magnetic coupling.
* They cost between $0.70-$20.00 per tag.
* They vary in cost depending on type and application.

Unlike other RFID tags, LF tags do not have security standards, so they
are not recommended for applications where encrypted communication is a
requirement.

### LF RFID Applications

LF RFID systems are used most often for animal tracking applications 
(e.g. pet tagging and livestock identification), but are also used in
some access control applications.  

LF tags are ideal for animal tracking applications because they are easily
read through the animal’s body (containing water).


## High Frequency (HF)
### About the HF Band
The high frequency (HF) band on the RF spectrum extends from 3 MHz to 30 MHz.

The wavelength of a high frequency wave is much shorter than an LF wave, only
around 22 meters, or a little less than 2 school buses in length.  

High frequency, like low frequency, uses magnetic coupling to communicate 
between the tags and the RFID reader/antenna.

HF waves can pass through most materials except for water and dense metals.

Thin metals, like aluminum, can still be tagged with HF tags and function normally.

HF RFID tags usually have a general read range of a few centimeters up to about
a meter in length depending on the setup of the system.

---

Within the high frequency band of the RF spectrum, near-field 
communication, or NFC, is a communication protocol approved by
the International Organization of Standardization, or ISO 
(ISO 14443 & ISO 18000-3).  

Because NFC is a global communication standard, and therefore 
regulated, it operates on a single frequency - 13.56 MHz.

---
HF Tags:
* HF and NFC tags cost from about $0.35 - $10.00 per tag.  
* The tags are usually delivered as labels, cards, or plastic encased tags.
* They are generally small in size so that they can be applied to many different items.  
* HF tags rely on magnetic coupling as their power source so they tend to last
the lifespan of the application unless damaged by wear and tear to the tag.

---
HF Readers:
* HF RFID readers are used with HF tags and cost around a few hundred USD.  
* NFC tags can be read with the same HF readers, including any smartphones
  that contain HF/NFC readers.  

### HF RFID Applications
HF and NFC RFID applications are continuously emerging from many companies
looking to solve business problems using RFID technology.  

NFC is particularly popular in marketing applications like advertising 
posters, smart items, and brand/item interactive experiences.  

The most used applications for HF RFID are access control applications, data
transfer applications, and some ticketing applications.

---

HF RFID tags are also used in passports across the world in countries like
the United States, Norway, Japan, Australia, India, and more.  

There has been criticism in the past about the security of these tags in 
passports. 

This was later addressed by adding both a metal lining to lower the read 
range, and a password that has to be keyed into the RFID reader to read the tag.


## Ultra-High Frequency (UHF)
### About the UHF Band
<!-- TODO: Finish this -->


### tl;dr
* The lower the frequency, the longer the wavelength
* the longer the wavelength, the slower the data transmission and vice-versa
* NFC is part of the High Frequency (HF) band at 13.56 MHz

* LF can pass through water and metal (unique to LF)
* HF can pass through most materials except water and dense metals.


Source: [Atlas RFID Store](https://www.atlasrfidstore.com/rfid-resources/a-guide-to-rfid-types-and-how-they-are-used/)
