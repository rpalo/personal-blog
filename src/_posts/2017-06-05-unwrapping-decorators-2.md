---
layout: page
title: Unwrapping Decorators, Part 2
description: A more in-depth look at the more advanced capabilities of decorators
cover_image: decorators.jpg
tags: python pythonic functional
---
# Quick Recap

Last post, I wrote about the basics of decorators in Python.  For those of you that missed it, here are the highlights.

 1. Decorators are placed before function definitions, and serve to wrap or add additional functionality to functions without obscuring the single purpose of a given function.
 2. They are used like this:
{% highlight python %}
@custom_decorator
def generic_example_function():
    # ...
    pass
{% endhighlight %}
 3. When defining a decorator function, it should take a function as input and output a new/different/modified/wrapped function.
{% highlight python %}
def custom_decorator(func):
    # *args, **kwargs allow your decorated function to handle
    # the inputs it is supposed to without problems

    def modified_function(*args, **kwargs):
        # Do some extra stuff
        # ...
        return func(*args, **kwargs) # Call the input function as it
                                    # was originally called and return that

    return modified_function
{% endhighlight %}

Okay.  That about covers it.  Let's get to the good stuff!  I'm going to cover passing arguments to decorators (a la Flask's `@app.route('/')`), stacking decorators, and Class-Based decorators.

# Decorator Arguments

You can pass arguments to the decorator!  It gets a little more complicated though.  Remember how a basic decorator function takes in a function, defines a new function, and returns that?  If you have arguments, you actually have to generate the decorator on the fly, so you have to define a function that returns a decorator function that returns the actual function you care about.  Oy vey.  Go go gadget code example!

{% highlight python %}
from time import sleep

def delay(seconds): # The outermost function handles the decorator's arguments

    def delay_decorator(func): # It defines a decorator function, like we are used to

        def inner(*args, **kwargs): # The decorator function defines the modified function
            # Because we do things this way, the inner function
            # gets access to the arguments supplied to the decorator initially
            sleep(seconds)
            return func(*args, **kwargs)
        
        return inner  # Decorator function returns the modified function
    
    return delay_decorator # Finally, the outer function returns the custom decorator

@delayed_function(5)
def sneeze(times):
    return "Achoo! " * times

>>> sneeze(3)
(wait 5 seconds)
"Achoo! Achoo! Achoo!"
{% endhighlight %}

Again, it may look confusing at first.  You can think about it this way: The outermost function, `delay` in this case, behaves like it is being called right when you add the decorator.  As soon as the interpreter reads `@delay(5)`, it runs the delay function and replaces the `@delay` decorator with the modified returned decorator.  At run-time, when we call `sneeze`, it looks like `sneeze` is wrapped in `delay_decorator` with `seconds = 5`.  Thus, the actual function that gets called is `inner`, which is `sneeze` wrapped in a 5 second sleeping function.  Still confused?  Me too, a bit.  Maybe just sleep on it and come back.

# Stacking Decorators

I'd like to move to something easier, in the hopes that you continue processing the previous section in the background and by the end of this, it will magically make sense.  We'll see how that works out.  Let's talk about stacking.  I can pretty much just show you.  You'll get the gist.

{% highlight python %}
def pop(func):

    def inner(*args, **kwargs):
        print("Pop!")
        return func(*args, **kwargs)

    return inner

def lock(func):

    def inner(*args, **kwargs):
        print("Lock!")
        return func(*args, **kwargs)

    return inner

@pop
@lock
def drop(it):
    print("Drop it!")
    return it[:-2]

>>> drop("This example is obnoxious, isn't it")
Pop!
Lock!
Drop it
"This example is obnoxious, isn't "
{% endhighlight %}

As you can see, you can wrap a function that is already wrapped.  In math (and, actually, in programming), *they* would call this **Function Composition**.  Just as `f o g(x) == f(g(x))`, stacking `@pop` on `@lock` on `drop` produces pop(lock(drop(it))).  Huey would be so proud.

# Class-Based Decorators...

## ...With No Arguments

A decorator can actually be created out of anything that is callable, i.e. anything that provides the `__call__` magic method.  Usually, I try to come up with my own examples, but the one that I found [here](http://python-3-patterns-idioms-test.readthedocs.io/en/latest/PythonDecorators.html) illustrated what was happening so darn well, I'm going to poach it with minimal modification.

{% highlight python %}
class MySuperCoolDecorator:
    def __init__(self, func):
        print("Initializing decorator class")
        func()

    def __call__(self):
        print("Calling decorator call method")
        func()

@MySuperCoolDecorator
def simple_function():
    print("Inside the simple function")

print("Decoration complete!")

simple_function()
{% endhighlight %}

Which outputs:

{% highlight python %}
Initializing decorator class
Inside the simple function
Decoration complete!
Calling decorator call method
Inside the simple function
{% endhighlight %}

## ...With Arguments

Class-based decorators make decorator arguments much easier, but they behave differently from above.  I'm not sure why.  Someone who is smarter than me should explain it.  Anyways, when arguments are provided to the decorator, three things happen.  

 1. The decorator arguments are passed to the `__init__` function.
 2. The function itself is passed to the `__call__` function.
 3. The `__call__` function is only called once, and it is called immediately, similar to how function-based decorators work.

Here's an example I promised to sneak in.

{% highlight python %}
class PreloadedCache:
    # This method is called as soon as the decorator is declared.
    def __init__(self, preloads={}):
        """Expects a dictionary of preloaded {input: output} pairs.
        I know it only works for one input, but I'm keeping it simple."""
        if preloads is None:
            self.cache = {}
        else:
            self.cache = preloads
    
    def __call__(self, func):
        # This method is called when a function is passed to the decorator
        def inner(n):
            if n in self.cache:
                return self.cache[n]
            else:
                result = func(n)
                self.cache[n] = result
                return result
        return inner

@PreloadedCache({1: 1, 2: 1, 4: 3, 8: 21}) # First __init__, then __call__
def fibonacci(n):
    """Returns the nth fibonacci number"""
    if n in (1, 2):
        return 1
    else:
        return fibonacci(n - 1) + fibonacci(n - 2)

# At runtime, the 'inner' function above will actually be called!

{% endhighlight %}

Pretty cool right?  I submit that this version of creating a decorator is, at least for me, the most intuitive.

# Bonus!

A bonus is that in Python, since functions are objects, you can add attributes to them.  Thus, if you modify the `__call__` method above to add the following:

{% highlight python %}
    def __call__(self, func):
        # ... Everything except the last line
        inner.cache = self.cache # Attach a reference to the cache!!!
        return inner

>>> fibonacci(10)
55
>>> fibonacci.cache
{1: 1, 2: 1, 4: 3, 8: 21, 3: 2, 5: 5, 6: 8, 7: 13, 9: 34, 10: 55}
{% endhighlight %}

![Vigorous head banging](/img/decorator_head_bang.gif)

# Wrap Up

Anyways, I know this is a lot.  This topic is one of the more confusing Python topics for me, but it can really make for a slick API if you're making a library.  Just look at [Flask, a web framework](http://flask.pocoo.org/) or [Click, a CLI framework](http://click.pocoo.org/5/).  Both written by the same team, in fact!  Actually, [I wrote a brief post about Click](http://assertnotmagic.com/2016/11/27/discovering-click.html) a while ago, if you're interested. 

Anyways anyways, if you have any questions about decorators (or anything else for that matter), don't hesitate to ask me!  I'm always happy to help (even though I usually end up doing some vigorous googling before I am able to fully answer most questions).  Ditto goes for if you can explain something better than I did or have extra input. 😁