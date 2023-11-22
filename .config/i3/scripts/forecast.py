#!/usr/bin/python3
import shutil
from tkinter import Label, Tk

import requests
from PIL import Image, ImageTk

root = Tk()
root.geometry("596x606-10+25")

# Get forecast image
forecast = requests.get("https://v2.wttr.in/Evansville.png", stream=True)
with open("forecast.png", "wb") as f:
    forecast.raw.decoder_content = True
    shutil.copyfileobj(forecast.raw, f)
display = ImageTk.PhotoImage(Image.open("forecast.png"))

label = Label(root, image=display, anchor="ne")
label.pack()

root.mainloop()
