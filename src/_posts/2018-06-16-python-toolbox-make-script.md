---
layout: page
title: "Python Scripting Toolbox: Part 2 - String Templates and `argparse`"
description: Part 2 of 3.  A couple of ways to beef up your Python scripts with the Standard Library.
tags: python scripting tutorial
cover_image: tools2.jpg
---

*Cover photo by Philip Swinburn on Unsplash*

This is Part 2 in the Python Scripting Toolbox series.  It's a three-part survey of the tools available to us for Python scripting.  I'm showing off the functionality by creating three scripts that show off different parts of the standard library.

1. In [Part 1](/2018/06/05/python-toolbox-shout/), we built `shout.py`: a script that shouts everything you pass into it.
2. In Part 2, we'll create `make_script.py`: a script that generates a starter script from a template, for use in things like [Project Euler](https://projecteuler.net/) or [Rosalind](http://rosalind.info/problems/locations/).
3. Next time, Part 3 will feature `project_setup.py`: a script that creates a basic project skeleton

Now, let's get started.

## Script 2: `make_script.py`

When doing coding challenges where you are supposed to write the code on your local machine and then just submit the answer once you find it, you find yourself rewriting a lot of the same boiler plate over and over for reading in command line arguments, parsing things, and outputting results, when the real meat and potatoes of your work is in the main function of the script.  Handling input and output is just a side task.  Wouldn't it be nice if we could just script away this grunt work and get started on the coding problem sooner?  That's what we're doing today.

Here are our requirements.  We're creating a Python script called `make_script.py`.  We want it to create a Python script from a template, filling in some variable names, docstrings, or other small variations based on our user inputs.  If it could have sensible defaults, that would be a plus.  Let's get started.

### Step 1: The Template

First, I want to come up with what our template should look like.  Open a file named `script.py.template`.  That's not a convention, it's a file ending I made up.  You can call it whatever you want.

```python
"""$docstring"""

import sys


def main($input):
    $output = ""
    return $output
  

if __name__ == "__main__":
    $input = sys.argv[1]
    $output = main($input)
    print($output)
```

Not a whole lot there, not super fancy, but it should save us some typing.

*But, Ryan!  What's with all of those dollar signs?  I thought this was Python, not PHP!*

You are correct.  We're going to be using the `template` class in Python's `string` module of the standard library.  It's good to note that there are several very good templating libraries that aren't in the standard library but have quite a bit more power.  [Jinja2](http://jinja.pocoo.org/docs/2.10/) and [Django Templates](https://docs.djangoproject.com/en/2.0/ref/templates/api/) come to mind right away.  But this will get us where we need to go.

With this templating language, we simply specify a variable with a dollar sign in front of it.  If you want to show an *actual* dollar sign, simply use 2 dollar signs in a row (`$$`).  This will render out as a single dollar sign.  Now, on to our actual code.

### Step 2: Filling In the Template

The code to actually fill in this template is not very many lines.  Create a new file called `make_script.py`.

```python
"""Creates a script from a basic template."""

import string

with open("script.py.template", "r") as f:
    template_text = f.read()

data = {
    "docstring": "Hey look at this cool script.",
    "input": "dat_arg",
    "output": "awesome_result"
}

template = string.Template(template_text)
result = template.substitute(data)

with open("new_script.py", "w") as f:
    f.write(result)

print(result)
print("----")
print("Script created!")
```

There are essentially four steps to this:

1. Read the template into a string.
2. Create a Template object from this string (provided by the Standard Libary's `string` module).
3. Substitute in data.  This can be done as keyword arguments to the `substitute` method, or (like we did it) as a dictionary.  Either way, the keys should be the names of variables defined in the template, and the values should be what you want to substitute in.
4. Write the newly processed result to a new file.

If you try running `python make_script.py`, you should see the results of the substitution in your terminal as well as in a new file called `new_script.py`.  Pretty cool, ja?

This is great, but we don't want to have to go in and change the values in `make_script.py` any time we want to create a new script.  We'd like our script to be a little more dynamic and maybe have a little better user interface.  Looks like it's time for…

### Step 3: `argparse`ing Our Way to CLI Greatness

We'd like our script to take some arguments, some options, and maybe show a help message.  Once again, I'd like to note that there are some excellent CLI libraries out there if you want a little more power.  I think [Click](http://click.pocoo.org/5/) is probably my favorite.  I wrote an article a while ago about [using Click](https://assertnotmagic.com/2016/11/27/discovering-click/).  Be gentle — it was one of my first blog posts!

Anyways, we've committed to using *only* the Standard Library in these guides, so we'll soldier on with our friend `argparse`.  For more examples and information, you can take a look at the [`argparse` documentation](https://docs.python.org/3/library/argparse.html).  For now, I think it's best to just show you the new, shiny version of `make_script.py`.

```python
"""Creates a script from a basic template."""

import argparse
import string

parser = argparse.ArgumentParser(description="Create new Python scripts from a template.")
parser.add_argument("scriptname", help="The name of the new script to create")
parser.add_argument(
    "-d", 
    "--docstring",
    help="The docstring to be placed at the top of the script",
    default="Placeholder docstring"
)
parser.add_argument(
    "-i",
    "--input",
    help="The name of the variable used as the input parameter",
    default="inval"
)
parser.add_argument(
    "-r",
    "--result",
    help="The name of the variable used as the result/output",
    default="result"
)

args = parser.parse_args()

# ...  You'll see how we use these args in a minute
```

Once we've imported the `argparse` module, we can create our argument parser.  We'll tell this argument parser about all of the arguments and options that we're expecting.  By default, any argument that starts with a `-` is considered an optional… um… option, while everything else is considered a required argument.

If you provide each argument with a `help` value, it will make your help text really look shiny.  At the end, you process the arguments provided by the user with the `parse_args` method.  Let's take a look at how to use them.

```python
# ... Everything in the previous code block

with open("script.py.template", "r") as f:
    template_text = f.read()

data = {
    "docstring": args.docstring,
    "input": args.input,
    "output": args.result
}

template = string.Template(template_text)
result = template.substitute(data)

with open(args.scriptname, "w") as f:
    f.write(result)
    
print(result)
print("----")
print("Script created!")
```

All of the arguments are available under the `args` *namespace*, which basically just means that you can access them via `args.whatever_your_variable_is`.  The variable name will be whatever name you passed into the `add_argument` method.

Now, if you run your script, it will complain if the right things aren't passed in, *and* if you run `python make_script.py —help`, it prints out a pretty little help message.

```bash
$ python make_script.py --help
usage: make_script.py [-h] [-d DOCSTRING] [-i INPUT] [-r RESULT] scriptname

Create new Python scripts from a template.

positional arguments:
  scriptname            The name of the new script to create

optional arguments:
  -h, --help            show this help message and exit
  -d DOCSTRING, --docstring DOCSTRING
                        The docstring to be placed at the top of the script
  -i INPUT, --input INPUT
                        The name of the variable used as the input parameter
  -r RESULT, --result RESULT
                        The name of the variable used as the result/output
```

Next time, we'll work on a script that will build a project directory for us.  Thanks for reading!