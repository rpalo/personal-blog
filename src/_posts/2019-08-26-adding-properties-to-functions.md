---
layout: page
title: Mocking by Adding Attributes to Functions
description: Python functions are first-class objects, which means we can stick whatever data we want on them!
tags:
  - python
  - tricks
---
I was reading through a blog post on how to quickly mock the print function to test a function’s output to the command line and I came across this technique. 

```python
def fake_print(*args, sep=" ", end="\n"):
    fake_print.output.append(sep.join(args) + end)

fake_print.output = []

mymodule.print = fake_print

mymodule.run_function()

expected = """Hello there.
How are you?
I'm great, thanks!
Banana.
"""

assert expected == "\n".join(fake_print.output) + "\n"
```

So, first-off, I know that there are better and more robust ways to do this.  I’ve got a post on my list of drafts to do about that.  And I also know that, in general, if you’re having to check STDOUT in order to ensure your function is working properly, there’s a reasonable chance that you could structure your code better and make it easier to test.  In this case, a class assignment was having me perform some operations and I was going to be graded on whether or not my STDOUT output exactly matched the expected or not, so I wanted to exactly test what I was getting graded on, just in case I made a stupid printing error.

Anyways, I’m getting off track.  The *point* of this post is this:

I know that functions are objects.  You hear all the time that they’re “first-class” objects (which means that they get better snacks and their seats recline all the way).  I’ve passed them as arguments, assigned them to variables, defined them inside other functions, and return them.

> I never thought about the fact that, because they are objects, you can stick arbitrary properties to them whenever you want!

Now.  A reasonable next question is: is this a good idea?  How useful is this really?  My answer: probably not all that much.

Realistically, all you are doing here is sneakily hiding what might be a global variable inside the properties of this function.  Are you adding some nice self-documentation of what this variable does by doing this?  Maybe.  Are you cleaning up the global namespace?  Sure.  But for the most part, it smells a little bit of “clever in a bad way.”  

Like I said, I’ve been programming Python for three or four years and mentoring for at least one, and I’ve *never* seen it.  It’s *never* occurred to me.  Am I the end-all Python knowledge guru arbiter of correctness?  No.  (OK, sometimes I tell my cat I am.)  But, it seems like a good indicator that this isn’t exactly commonplace.  And I don’t think that the small, neat namespacing benefits and little giggle I get from being clever are worth the mental overhead of anyone else who has to read my code.

Nonetheless, with all of that said, it’s still a neat trick and highlights some things that I love about Python in general.  Here’s another example use-case to show it off: caching.

```python
def fibonacci(n):
    if n in fibonacci.cache:
        return fibonacci.cache[n]

    result = fibonacci(n - 1) + fibonacci(n - 2)
    fibonacci.cache[n] = result
    return result

fibonacci.cache = {}
```

This saves a bunch of function call by saving the results of calculations in the `cache` dict.

*Side note: this is really just a lame version of `functools.lru_cache`.  Look it up.  It’s great!*

Anyways, I just wanted to share this neat, quirky way of handling something in Python.  Thanks for reading!