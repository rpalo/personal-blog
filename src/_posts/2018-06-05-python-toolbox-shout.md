---
layout: page
title: "Python Scripting Toolbox: sys and fileinput"
description: Part 1 of 3.  A couple of ways to beef up your Python scripts with the Standard Library.
tags: python scripting tutorial
cover_image: tools.jpg
---

*Cover Photo by Fleur Treurniet on Unsplash*

Python is an extremely flexible language with uses in tons of different applications and fields: web apps, automation, sciences, and data analysis, to name a few.  However, my *favorite* thing to use it for is scripting.  Scripting can be as simple as writing a quick little one-off script to do something faster than you would want to do by hand, or it can more complex, a recurring task that you polish up -- something with options, and flags, and a bit of a user interface.

Lucky for us, Python already has many of the essentials for scripting built into its standard library!  I'm going to show you a few of the features I like best and how they are used.  I'll be using Python 3.6 for all of these examples.  Most things should work in any Python 3.  Your mileage may vary if you use legacy Python (Python 2). 

> I know that there are libraries and frameworks out there for creating command line interfaces.  They are awesome.  In this article, I'm going to focus on Python's "Batteries Included": the standard library.  I'll show you how much you can accomplish without installing a single external dependency.

## The Setup

This will be a three-part survey of the tools available to us for Python scripting.  I'll show off the functionality by creating three scripts that show off different parts of the standard library.

1. `shout.py`: a script that shouts everything you pass into it.
2. `make_script.py`: a script that generates a starter script from a template, for use in things like [Project Euler](https://projecteuler.net/) or [Rosalind](http://rosalind.info/problems/locations/).
3. `project_setup.py`: a script that creates a basic project skeleton

This here is part one.  Now, let's get started.

## Script 1: shout

Did you ever wish that your computer would yell at you more?  Or that you computer was more abraisive?  You're in luck then, because we're about to fix all of that.  Create a new file called `shout.py`.  We're going to first just fill in the basic functionality, and then build out the interface from there.

```python
#!/usr/bin/env python
"""Takes in input and returns that same input, but uppercase."""

def shout(text):
    return text.upper()
```

Good so far!  I wanted to keep it simple to start with so we can focus mainly on our toolbox.  Right now, if you run `python shout.py`, it doesn't do anything.  Let's fix that.  But how do we get access to the arguments provided to our scripts?  Our first tool: `sys`.  `sys` is a module that handles a lot of different system-level, system-specific, or python-install-specific options and values.  You can use it to check what version of Python someone's using, what operating system the script is running on, or (what we're using it for) get access to `stdin`, `stdout`, and command line arguments.

### Using `sys.argv`

Let's look at one way we could use this script, which might be a good option if we have a set or specific number of arguments we expect.

```python
#!/usr/bin/env python3
"""Takes in input and returns that same input, but uppercase."""

import sys

def shout(text):
    return text.upper()
  
if __name__ == "__main__":
    text = sys.argv[1]
    print(shout(text))
```

`argv` is the array of arguments (space-separated) that were passed to our script.  Note that `argv[0]` is the name of the script that was run.  Running this, the result would be:

```bash
$ python3 shout.py banana
BANANA
```

That works OK for some things.  If we had a script that calculated the area of a polygon based on the number of sides and side length (`e.g. python polygonArea.py 5 20`), `argv` would be just what the doctor ordered.  But, in this case, it might be useful to be able to pass things into our script via `stdin`, like any other shell command.  Luckily, `sys` has our back once again!

### Using `sys.stdin` and `sys.stdout`

```python
#!/usr/bin/env python3
"""Takes in input and returns that same input, but uppercase."""

import sys

def shout(text):
    return text.upper()
  
if __name__ == "__main__":
    text = sys.stdin.read()
    sys.stdout.write(shout(text))
```

The `sys` module provides handles to `stdin`, `stdout`, and `stderr`, which you can read and write to, respectively, just like any other file-type object.  Now find a text file or create one with multiple lines, and run your code like this:

```bash
$ cat test.txt | python3 shout.py
BANANA OONANA
I GAVE MY HEART TO A BANANA
MY HEART TO A BANANA.
BANANA OONANA!
```

I'm sorry for all of the "banana" stuff.  I've got [that song](https://www.youtube.com/watch?v=BQ0mxQXmLsk) stuck in my head.  But the Python stuff is cool, right?  There's one more improvement we can make here.  What if our text that we want shouted was really, *really* long?  It would be better for it to be processed line by line, right?  That way, we could see partial outputs as it processes, and we don't have to worry about reading the whole file into memory.  That's what's so great about `stdin` and `stdout` being "File-like objects."  They've got the same methods that regular files do.  That means we can iterate over the lines of `stdin` in a `for` loop!

```python
# ...
if __name__ == "__main__":
    for line in sys.stdin:
        sys.stdout.write(shout(line))
```

This time, when you run it, you won't notice any difference.  Let's put a delay in between each line.

```python
#!/usr/bin/env python3
"""Takes in input and returns that same input, but uppercase."""

import sys
from time import sleep

def shout(text):
    return text.upper()
  
if __name__ == "__main__":
    for line in sys.stdin:
        sys.stdout.write(shout(line))
        sleep(3)
```

As you run it this time, the lines should come out slowly, whereas the old version would happen all at once no matter what!

### Using `fileinput`

What if you wanted to go really over the top with this shouting tool?  You wanted to be able to shout a whole bunch of files at once, along with piping from `stdin`?  You'd want `fileinput`.  Check it out.

```python
#!/usr/bin/env python3
"""Takes many inputs and returns that same input, but uppercase."""

import fileinput
import sys

def shout(text):
    return text.upper()
  
if __name__ == "__main__":
    for line in fileinput.input():
        sys.stdout.write(f"({ fileinput.filename() }) - { shout(line) }")
```

Now, create a second file (`test2.txt`) .  Run the script like this:

```bash
$ python3 shout.py test.txt test2.txt
(test.txt) - BANANA OONANA
(test.txt) - I LEFT MY HEART INSIDE BANANAS
(test.txt) - INSIDE BANANAS.
(test.txt) - BANANAS OONANANA!
(test2.txt) - THIS IS THE SECOND FILE.
(test2.txt) - IT IS LAMER.
(test2.txt) - NOT AS CATCHY OF TEXT.
(test2.txt) - HELLO.
```

[`fileinput`](https://docs.python.org/3/library/fileinput.html) uses the `input` function to combine all of the filename arguments and read them in as a single line-by-line stream.  It has additional useful functions that you can call while reading to add additional information, as well.  We used it to provide the filename of the file being processed, but there are more, like `lineno`, `filelineno`, `isfirstline`, and `isstdin`.  You can even add extra options to change the input files in-place, create backups of in-place modified files, decompress compressed files, and more!

*But wait a minute.  That's really cool, but you promised that we could still use `stdin` with this method.  How does that work?*

You can include `stdin` in your list of files by using a single dash (`-`).

```bash
echo "whaddup from stdin" | python3 shout.py test.txt - test2.txt
(test.txt) - BANANA OONANA
(test.txt) - I LEFT MY HEART INSIDE BANANAS
(test.txt) - INSIDE BANANAS.
(test.txt) - BANANAS OONANANA!
(<stdin>) - WHADDUP FROM STDIN
(test2.txt) - THIS IS THE SECOND FILE.
(test2.txt) - IT IS LAMER.
(test2.txt) - NOT AS CATCHY OF TEXT.
(test2.txt) - HELLO.
```

## All Shouted Out

That's it for `sys`, `fileinput`, and our `shout.py` script.  Stay tuned for the next part, where we'll build `make_script.py` — we'll write a script that writes scripts so we can script while our scripts script.  See you next time!