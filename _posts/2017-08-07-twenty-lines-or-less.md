---
title: Your Own REPL in Twenty Lines or Less
layout: page
description: Python's standard library makes it easy for you to use custom REPL's
cover_image: code-repl.gif
tags: python fun
---

Have you ever been in a Python interactive REPL and said to yourself, "You know, this is nice and all, but... it's missing something.  There's not enough *me*!"  Well, worry no more!  I'll show you how to do it in twenty lines or less!  Let me introduce the main attraction:

## Code

As unhelpful as that sounds, it's true.  Python has a module in the standard library called `Code`.  You can check out the [code module documentation](https://docs.python.org/3/library/code.html) if you don't believe me.  The documentation is maybe a little tough to understand on first pass-through, so I thought I'd create a few examples to show it off.  There are a few objects in the `code` module, but only one that I'm going to talk about this time: `interact`.

## Interact

Let's dive in.  I'll show you.  Let's create a new file in our directory called `shell.py`.

```python
#!/usr/bin/env python
# I'll be using Python 3, for reference.

import code  # seems silly, but works great

def custom_repl():
    pie = "delicious"
    pi = 3.14159
    homonyms = (pie != pi)
    code.interact(
        banner="Hello!  My name is Jeeves!  I am fancy.  🎩",
        local=locals(),
        exitmsg="Ta-ta!"
    )

if __name__ == "__main__":
    custom_repl()
``` 

Try running it and watch the magic work.

```python
$ python3 shell.py
Hello!  My name is Jeeves!  I am fancy.  🎩
>>> pi
3.1415
>>> pie
'delicious'
>>> homonyms
True
>>> 4 + 3
7
>>> import math
>>> math.sqrt(pi)
1.7724531023414978
<Ctrl-D>
Ta-ta!
```

As you can see, the banner message we specified shows, the exit message we specified shows (although it didn't work for me if I used the built-in `exit()` or `quit()` commands), and we had access to the local variables when `interact` was called.  And we can use anything to act as our local state!  Go back in and create `shell2.py`.

```python
#!/usr/bin/env python
# shell2.py

import code

class Car:
    def __init__(self, color, mileage):
        self.color = color
        self.mileage = mileage

    def honk(self):
        return "Beep!"

    def __repr__(self):
        return "<Car - color: {}, mileage: {}>".format(self.color, self.mileage)

if __name__ == "__main__":
    c = Car("red", 20000)
    code.interact(
        banner="Now interactively inspecting {}".format(c),
        local={"car": c},
    )
```
Back in the shell... `python3 shell2.py`

```python
Now interactively inspecting <Car - color: red, mileage: 20000>
>>> car
<Car - color: red, mileage: 20000>
>>> car.honk()
'Beep!'
```

Keep in mind that the `local` parameter to `interact` has to be a Dict -- such as the one returned by `local()` and `global()`.

## Wrap Up

You can use this to provide a nice interactive aspect to your app to help you do shell things, inspect objects, debug, and much more.  This is roughly how [pdb](https://docs.python.org/3/library/pdb.html) works too!  Django and Flask both use a variation on this for their "shell" commands too.  I think I'm going to try to use it to generate an automated quiz or homework for a python intro class (similar to [the swirl package in R](https://www.youtube.com/watch?v=McoHQIxJd-o)).  Have any other cool ways you've used this?  Let me know!