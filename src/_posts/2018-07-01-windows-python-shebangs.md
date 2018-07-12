---
layout: page
title: Python Shebangs on Windows
description: Python handles unix shebangs (lines that tell your computer how to run a program) in a way that is really nice and portable.
tags: python
cover_image: shebang
---

*Cover image By Sven [Public domain], from Wikimedia Commons*

## Shebang Lines in the Wild

In Unix-like systems, if you want a file to be executable, you can add a line to the top called a **"shebang"**.  They look like this:

```bash
#!/usr/bin/env bash

echo "Hello, world!"
```

"Shebang" is short for "hash bang," which is slang for the pound/hash/octothorpe symbol (`#`), followed by the exclamation point/bang (`!`).  This line is responsible for telling the computer where the program or command that will be used to run this file lives.

Once your file has a shebang, you can make the file executable by adding "execute permissions," accomplished by running the following command in your Bash shell:

```bash
$ chmod u+x hello.sh
```

You can then run the program by executing it directly:

```bash
$ ./hello.sh
Hello, world!
```

## How it Works on Windows

If you're not using Windows Subsystem Linux or some other form of porting Bash to Windows, you're probably using PowerShell as your shell of choice.  And, I've never had very good luck with shebangs working on Windows.  I think it is because of the way Windows handles which programs deal with which file suffixes.  However, starting with Python 3.3, Python for Windows has shipped with a **"Python for Windows Launcher"**, called from the command line as simply `py`. 

You can launch your latest version of Python by running it with no arguments:

```powershell
$ py
```

You can select which version you'd like by specifying a version flag.

```powershell
$ py -2.7
```

If you can't find it or the command isn't working, the launcher lives by default in `C:\WINDOWS\py.exe`.  Make sure `C:\WINDOWS` is on your path and Python files use this executable as their default program.

 > This is *really* important.  If your default program for running Python files is set to a specific Python executable instead, you'll end up with some weird and hard-to-diagnose issues.  So, to ensure that you're set up right, run the "Default Programs" application and make sure Python files are associated with the `C:\WINDOWS\py.exe` executable and not something else.

The nice thing about this launcher is that, if it is the default program to run your Python files, it can process several common forms of shebangs.

```bash
#!/usr/bin/env python
#!/usr/bin/python
#!/usr/local/bin/python
#!python
```

If you're hoping to make your scripts portable, use one of the ones beginning with `/usr`.  If `py` encounters any of these, it will use your default Python.  If you specify a version (either major or major.minor), it will use that version instead:

```bash
#!/usr/bin/env python3
#!/usr/bin/env python2.7
```

In addition, if you use this `/usr/bin/env python` version (as opposed to the `/usr/bin/python` or `/usr/local/bin/python`), `py` will do the additional, expected search down your `PATH` for a python command, the same way it would on a Unix-like system.

There aren't really "execute permissions" on Windows (correct me if I'm wrong), but once you have one of these lines at the top of your script, you can run it just like an executable in your shell.

```python
#!/usr/bin/env python3
# Inside hello.py

print("Hi buddy!")
```

```powershell
$ ./hello.py
Hi buddy!
```

Just one more thing to make you a little less homesick for your Bash shell when you're on Windows.

There is a lot more information about working with Python on Windows in [the Python docs](https://docs.python.org/3/using/windows.html).  I recommend you take a look if you're on windows and you like to find ways to make your life easier.

Thanks for reading!

