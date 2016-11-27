---
layout: page
title: Discovering Click
---
I'm going to have two posts here in quick succession, because I learned a bunch of things in the last couple weeks all in a row that are really cool.  The first one I want to talk about is (Click)[https://click.pocoo.com/5], which is a Python framework for quickly making command-line interface (CLI) programs.  I have been using it recently to make a (tool that automates a few of the more repetetive tasks at work)[https://github.com/rpalo/pq-cli].  The basics are really simple!

```python
# Example taken roughly from their documentation
# hello.py
import click    # You can install it using pip install click

@click.command()    # Click works mainly through decorators
@click.argument("name")         # Required arguments can be specified with another decorator
@click.option("-c","--count", default=1,
                help="Number of times to repeat")       # Options (short and long) are via decorator too!
def hello(name, count):         # By default, the name of the option or argument becomes
                                # the variable passed to the function
    for i in range(count):
        click.echo("Hello, {}".format(name))
        # Click provides some useful utility functions such as "echo"
        # that help to resolve cross-platform issues, and ease testing

if __name__ == '__main__':
    hello() # Allowing it to be called from the command line

```

And that's it!  You can run it like so:

```bash
$ python hello.py Ryan --count 3
Hello, Ryan
Hello, Ryan
Hello, Ryan
```

And it checks inputs to ensure the right number, count, and even type if you specify it.  If the user puts the wrong thing in or is unsure how to use it, they can simply:

```bash
$ python hello.py --help
Usage: hello.py [OPTIONS] NAME

Options:
  -c, --count INTEGER  Number of times to repeat
  --help               Show this message and exit.
```

And there are a whole bunch of other great things about it.  There is built in support for testing to aid with TDD and writing tests in general.  With my PQ-CLI, my goal was to do the project like a real big kid, with license, readme, git repo, writing tests first, etc.  I think I did ok with that, and I'm still going.  There is support for grouping and nexting and piping commands.  And the documentation is really helpful (examples first, API and documentation later).  I wasn't suprised when I looked up at the url for Click and realized it was part of the Pocoo family (the guy who made Flask, among a bunch of other useful projects).  Anyways, check out (my project)[https://github.com/rpalo/pq-cli] for more examples and take a stop by the (main Click project page)[https://click.pocoo.com/5] for even more guidance.

