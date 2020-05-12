---
layout: page
title: 'Strings: A Neat Hexdump Alternative'
description: I found a command that works even better than hexdump for some tasks!
tags:
 - bash
 - cli
 - steganography
cover_image: secret_puppy.png
---

I was working through my most recent class, Application Security, and one of the exercises required us to find a secret message hidden in an image.  Now, I know you can do this manually with `hexdump -C`.  That output looks something like this:

![A screenshot of the output of hexdump, showing rows of hex data with a sidebar of ASCII text.](/img/hexdump-output.png)

This is fine unless your image is huge or your secret message has a bunch of garbage bytes mixed into it for extra secrets.  So I was trying to look up a way to get it to just kick out the ASCII output on its own so I could use other tools like `grep` to search through it, when I stumbled over a reference to the `strings` command.  What is the `strings` command?

> strings - find the printable strings in a object, or other binary, file

Well, OK then!  Granted, when you read through the man page for it, it proclaims itself as a very simple string-finding algorithm, but good as a first easy pass.

Take this image here:

![A cute picture of a puppy.](/img/secret_puppy.png)

Cute puppy, right?  Yes, but it is also a *puppy full of secrets.*

Give it a try.  Download it and then run:

```bash
strings secret_puppy.jpg
```

Find anything fun?

This method won’t find every hidden string in every secret image or binary file, but it’s a quick, easy command and much more useful than `hexdump` for some things!
