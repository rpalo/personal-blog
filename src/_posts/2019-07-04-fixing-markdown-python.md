---
layout: page
title: Fixing Python Markdown Code Blocks… with Python!
description: I breakdown a quick script I wrote to fix markdown output from the Ulysses writing app.
tags: 
  - python
  - scripting
  - cli
  - bash
cover_image: space.jpg
---

I’m trying out [Ulysses](https://ulysses.app/ "Ulysses Home Page") for writing, and so far I’m really liking it.  But yesterday, I went to export one of my posts to markdown to get ready to post on my blog, and I found a slight hiccup.  Ulysses formats all code blocks with tabs instead of spaces.  Now, there’s no way that I’m going to get into *that* whole thing, but I will at least say that PEP8 tells us that the standard for Python is 4 spaces.  What kind of self-respecting technical blogger would I be if I posted code samples with—*shudder*—tabs in my Python code?

[So I asked them!](https://twitter.com/paytastic/status/1146059025206743045 "My tweet to Ulysses")  And they responded really quickly and politely told me “not at this time.”  Which is fine.

I immediately began researching to figure out how I was going to solve the problem myself.  Could I look into customizing Markdown formats?  Tweaking the export process?  But before I could start spiraling down that rabbit hole, it hit me: it’s just text!

I’m a programmer!  I have the power of the universe at my fingertips!  (On my machine, at least.)  So I got to work on a script for a platform that was *designed* to work with, modify, and tweak streams of text: the command line.

## Bash One-Liner

My first thought was that it’s a real simple substitution.  I can do this in a single command!

````bash
$ sed $'s/\t/    /g' example.md
Hello this is text

```python
def thing():
    print("Spaces!")
```

There should be four spaces there.
````

And honestly, that’s probably good enough.  But I was on a roll, and I wanted a little more fine-grained control.

## Let’s do it in Python

I’ll show you the whole thing for those that are just here for the copy/paste, and then I’ll step through the important bits and how they work.  Essentially, we loop through each line of the input stream, and if we’re in a Python code block and there’s a tab, we replace the tabs with spaces.  I pull in `argparse` and `fileinput` from the standard library to put a little polish on the user experience.  Here’s what I came up with:

````python
#!/usr/bin/env python3

import argparse
import fileinput

parser = argparse.ArgumentParser(description="Convert tabs in markdown files to spaces.")
parser.add_argument("-a", "--all", action="store_true", help="Convert all tabs to spaces")
parser.add_argument("-n", "--number", type=int, default=4, help="Number of spaces to use.")
parser.add_argument('files', metavar='FILE', nargs='*', help="files to read, if empty, stdin is used")

args = parser.parse_args()
if args.all:
    start_tag = "```"
else:
    start_tag = "```python"

in_code_block = False
for line in fileinput.input(files=args.files):
    if line.startswith(start_tag) and not in_code_block:
        in_code_block = True
    elif line.startswith("```") and in_code_block:
        in_code_block = False
    elif in_code_block:
        line = line.expandtabs(args.number)

    print(line, end="")
````

The meat of the business logic is here:

````python
in_code_block = False
for line in fileinput.input(files=args.files):
    if line.startswith(start_tag) and not in_code_block:
        in_code_block = True
    elif line.startswith("```") and in_code_block:
        in_code_block = False
    elif in_code_block:
        line = line.expandtabs(args.number)

    print(line, end="")
````

Loop through each line, keeping track of if we’re in a code block (more on the specifics of that in a minute) or not.  If we’re in a code block, expand the tabs!  Finally, output the new version of the line.

But what’s all that other stuff?  Even in the main code, there’s a reference to `fileinput`.  What the heck?

### Using fileinput

`fileinput` is a neat (and frankly underrated) module in Python’s standard library that allows scripts to load input from one or many file arguments and even STDIN super ergonomically.  The most common use case is in the [docs for it](https://docs.python.org/3/library/fileinput.html "FileInput Docs") and it’s almost comically short:

```python
import fileinput

for line in fileinput.input():
    process(line)
```

With these lines of code, you can call your script with as many filenames as you want, and Python will string their contents together into one stream of text.  For example, if you have a script that prints the capitalized version of all the text it receives called `capitalize.py`, you could run it like this:

```bash
$ python3 capitalize.py README.md hello.txt banana.rb
# THIS IS THE TITLE OF MY README

CHECK OUT THE README CONTENTS.
SO MANY CONTENTS.
NOW HELLO.TXT IS HERE
YOOOOOOOO
DEF BANANA
    PUTS 'A MAN, A PLAN, CANAL BANANAMA'
END
```

*But Ryan, in your script it looks different!  You’re not using it the same way!*  That’s right.  I’m combining it with another CLI power module:

### Parsing Arguments with argparse

`argparse` is the standard library way of handling command line arguments, flags, options, and providing a little bit of a user interface.  Its particular syntax is one that I always have to look up, but it’s lightweight, works well, and does what I want.    Here’s that relevant code.  You’ll see how it starts to tie into the `fileinput` section above as well.

````python
parser = argparse.ArgumentParser(description="Convert tabs in markdown files to spaces.")
parser.add_argument("-a", "--all", action="store_true", help="Convert all tabs to spaces")
parser.add_argument("-n", "--number", type=int, default=4, help="Number of spaces to use.")
parser.add_argument('files', metavar='FILE', nargs='*', help="files to read, if empty, stdin is used")

args = parser.parse_args()
if args.all:
    start_tag = "```"
else:
    start_tag = "```python"
````

We go in three stages:

1. First we create the `ArgumentParser`.  It will managing all of our parsing for us.
2. Then we add arguments and specify their behavior.  In this case, I added an `--all` flag to make it so we could eradicate all tabs and restore order to all of our code blocks, and a `--number` flag to tell it how many spaces to make each tab.  This might be useful if I’ve got Ruby or JS examples where I prefer 2 spaces.  Lastly, I add a `*args`-flavor positional argument for all of the filenames the user wants to provide.
3. Finally, now that everything is specified, we parse and process the args.  Depending on the type and action we specify for each input, we can expect different behaviors.

The last little trick is how we tie `argparse` and `fileinput` together with this little line:

```python
for line in fileinput.input(files=args.files):
```

`fileinput.input` takes an optional list of filenames, rather than trying to get them from the passed in script arguments.  Because `argparse` gobbles up all the command line arguments, we need to tell it to pass those filenames through so `fileinput` can do its thing.  And it all works like a charm!

## TABS ARE FOR PEOPLE WHO MIX THEIR CORN AND POTATOES TOGETHER

No, I don’t have strong opinions on trivial things, why do you ask?  In any case, until that feature request to Ulysses makes its way into their queue, I’ve got my little script, and it makes me happy!  How well does it work, you ask?  Well, do you see tabs or spaces in the code examples in this post?
