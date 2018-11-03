---
layout: page
title: Automating Simple Things with Python is Awesome
description: I scripted the renaming of a bunch of files at work and it make me feel like a wizard.
tags: python scripting
cover_image: tiny-city.jpg
---

*Cover photo by Tim Easley on Unsplash.*

This is just a quick post about something that happened to me yesterday at work.

So there I was: working hard as a mechanical engineer.  You know, measuring stuff.  Squinting at things.  Taking some notes.  Buying various bolts and screws.  The usual.

I had just downloaded some 3D model files for a clamp we were going to use in a fixture -- a real one, sorry software testing folks.  [This clamp](https://www.destaco.com/catalog/215-U), in fact.  As the files came in, I gasped in horror.  The files all had the wrong extensions!  I had clicked the button to download a folder full of `.sldprt` (individual parts) and `.sldasm` (assemblies) files, but they came in as `.prt.1` and `.asm.1` files.  What gives!?  And to make matters worse, there were a few XML files thrown into the mix -- useless to me!

So I right-clicked and renamed the first file, changing to the appropriate extension.  And, as I right-clicked on the second file (of about 30), my inner developer started getting grumpy.  "We don't have to stand for this!" he cried, flinging his tiny inner-developer keyboard accross his tiny inner-developer office.  (My inner developer startup has offices and doors because I'm not a monster.)

Anyways, back to him.  "We don't have to stand for this!" he cried.  "We're not some mindless, paper-pushing drones!  We can program!  We could script this in no time!"

"We *could*," my inner project manager chimed in.  (My inner startup is well-staffed.)  "But how much time is that really going to save us?  We could be done renaming all of these files in like two minutes."

"Alright," the inner developer replied, bottom lip starting to jut stubbornly.  Then I'll do it in 120 seconds or less."

He then said, "Crap.  We're on a Windows machine without Bash, and I can't quite remember the PowerShell syntax to manipulate strings.  Or, at least, not enough to get it done in time.  Oh wait!  We know Python!  We can do anything we want!"

So, he quickly guided me to do a search for a way to iterate over a directory and rename files.  I had to search, because I know there are a few ways of doing it.  Was it `os`, or `shutil`, or `pathlib`?  I think any one of those would have worked.  I know there's a bunch of ways to do what I want, but I needed a way that could be accomplished in 120 seconds of combined Googling and implementing.

Aha!  Got it!

"That's 30 seconds down," warned my inner project manager.  "Get a move on!"

So I opened up a terminal and fired up `ipython`, my preferred Python REPL.  (Yes I have used `bpython`.  Yes it is amazing.  I still like `ipython`.)

```python
import os

for filename in os.listdir("."):
    if filename.endswith(".1"):
        basename = filename[:-6]
        extension = filename[-5:-2]
        os.rename(filename, basename + ".sld" + extension)
```

My inner dev team high-fived and clinked their cans of La Croix in celebration.

Was it the prettiest, most elegant code I've ever written?  No.  But did I get it done in less than 120 seconds?  Yes.  Did it work?  Yes.  Did I feel like a wizard?  You're darn right.

Python is awesome, and no matter what I do with it, it makes me feel happy.

## After-Credits Scene

Now that I'm not on the clock and I'm free to take as much time as I like, I've decided I like this solution better:

```python
from pathlib import Path

for file in Path(".").glob("*.1"):
    name, ext, _ = file.name.split(".")  # There were no other .'s in the names
    file.rename(f"{name}.sld{ext}")
```

