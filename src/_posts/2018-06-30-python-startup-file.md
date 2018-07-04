---
layout: page
title: Python Has a Startup File!
description: Of course I knew that Python has a startup customization file this whole time.  I didn't just learn about it.  Shut up.
tags: python tricks
cover_image: baby_snek
---

*Cover Photo by Uriel Soberanes on Unsplash*

So, I want to be clear.  *I* knew that Python has a startup customization file this whole time I've been using Python.  *I* didn't just find out about it this week.  I mean, of *course* Python has a startup file.  Everything has a startup file!  I just want to make sure *you* know about it.  *(Only joking, I had no idea this was a thing.)*

 > Before you bring it up, I already know about [bPython](https://bpython-interpreter.org/screenshots.html), the awesome, syntax-highlighty, tab-completey, auto-indenty, wonderful drop in replacement for the regular Python interpreter.  I use it all the time.  But that's not what this blog post is about.  P.S. if you didn't know about bPython, I highly recommend it (Windows users' mileage may vary).

## $PYTHONSTARTUP

If you have the environment variable `$PYTHONSTARTUP` set to a valid Python file, that file will get run when starting up the Python interpreter.

```bash
$ export PYTHONSTARTUP="~/.config/pythonrc.py"
```

Don't worry about the name of the file.  Name it whatever you want!  `python_startup.py`, or just `pythonrc`.  You can also put it in whatever directory you want.  Just make sure your `$PYTHONSTARTUP` environment variable matches.  Then, you can put anything you want into that file.

```python
# ~/.config/pythonrc.py
a = "Wahoo!"
print("Soup")
try:
    import numpy as np
except ImportError:
    print("Could not import numpy.")
```

Try running your Python interpreter.

```bash
$ python  # or python3
```

And you should see something similar to the following:

```python
Python 3.7.0 (default, Jun 29 2018, 20:14:27)
[Clang 9.0.0 (clang-900.0.39.2)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
Soup
>>> np
<module 'numpy' from '/usr/local/lib/python3.7/site-packages/numpy/__init__.py'>
>>> np.zeros((3, 2))
array([[0., 0.],
       [0., 0.],
       [0., 0.]])
>>> a
'Wahoo!'
```

You can import commonly used libraries, create variables for yourself, and more.

## sys.ps1 and sys.ps2

One neat thing to do is to set the `sys.ps1` and `sys.ps2` variables, which control your Python prompts.

```python
# ~/.config/pythonrc.py

import sys

sys.ps1 = "🌮"
sys.ps2 = "💩"

# ...
```

And, back in the interactive REPL:

```python
🌮 for i in range(10):
💩     print("I am a mature adult.")
💩
I am a mature adult.
I am a mature adult.
...
```

In fact, you can even set `sys.ps1` and `sys.ps2` to objects that aren't even strings!  If they're not strings, Python will call `str(obj)` on them.

```python
# ~/.config/pythonrc.py

import sys
from datetime import datetime

class CustomPS1:
    def __init__(self):
        self.count = 0

    def __str__(self):
        self.count += 1
        return f"({self.count}) {datetime.now().strftime('%H:%m %p')} > "

sys.ps1 = CustomPS1()
```

And in the interpreter:

```python
(1) 10:06 AM > for i in range(10):
...     print("Am I cool now?")
...
Am I cool now?
Am I cool now?
# ...
(2) 11:06 AM >
```

## The -i Flag

In addition to these new superpowers, you can temporarily make *any* Python script your startup script.  This could come in really handy for some interactive debugging.  Let's say you're working on a project and you have a script that defines some functions:

```python
# cool_script.py

def what_time_is_it():
    return "Party Time"
```

You can use the `-i` flag when you run the Python interpreter to use `cool_script.py` as your startup file instead of your usual one.

```python
$ python -i cool_script.py
>>> what_time_is_it()
'Party Time'
```

If you do some cool things with your startup file, share it with me!  I want to know about it!  Happy coding!