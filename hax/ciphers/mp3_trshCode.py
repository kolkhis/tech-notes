#!/usr/bin/env python3
# Python program to read image using OpenCV
 
# importing OpenCV(cv2) module
import cv2
 
# Save image in set directory
# Read RGB image
img = cv2.imread('spectrogram.pgm')
 
#def get_width(r,c):
 #   current_row = img[r]
#    for i in current_row:
 
 The 4 + 8.whatever * n is the Y location. The scanning of that line, finds the X locations.
 
 
rows,cols,_ = img.shape
max_color = 225 
count = 0
letter_parts = []
 
for r in range(0, 8):
    for box in r:
        if box >= 225:
            letter_parts.append(box)
    letter_arr = [0,0,0,0,0,0,0,0]
    for c in range(0,8):
 
 
 
    for c in range(cols):
        count += 1
        if c >= 225:
 
 
 
 
#        # highest value is 255
 #       pixel = img[r][c]
  #      if pixel[0] > max_color:
           # We've hit the top L corner of a 1 bit 
   #         width = get_width(r,c)
#    r       length = get_length(r,c)
 
print(count)
print(f"max = {max_color}")
print(f"img: {img[50][50]}")
