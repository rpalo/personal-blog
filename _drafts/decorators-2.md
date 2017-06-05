---
layout: page
title: Unwrapping Decorators, Part 2
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

    def output_function(*args, **kwargs):
        # Do some extra stuff
        # ...
        return func(*args, **kwargs)

    return output_function
{% endhighlight %}

Okay.  That about covers it.  Let's get to the good stuff!

## Decorator Arguments

You can also pass arguments to the decorator!  It gets a little more complicated though.  In order to process the arguments you have to generate the decorator on the fly.  Go go gadget code example!

{% highlight python %}
from time import sleep

def delay(seconds):

    def delay_decorator(func):

        def inner(*args, **kwargs):
            sleep(seconds)
            return func(*args, **kwargs):
        
        return inner
    
    return delay_decorator

@delayed_function(5)
def sneeze(times):
    return "Achoo! " * times

>>> sneeze(3)
(wait 5 seconds)
"Achoo! Achoo! Achoo!"
{% endhighlight %}

Again, it may look confusing at first.  You can think about it this way: The outermost function, `delay` in this case, behaves like it is being called right when you add the decorator.  As soon as the interpreter reads `@delay(5)`, it runs the delay function and replaces it with the returned decorator.  At run-time, when we call `sneeze`, it looks like `sneeze` is wrapped in `delay_decorator` with `seconds = 5`.  Thus, the actual function that gets called is `inner`, which is `sneeze` wrapped in a 5 second sleeping function.  Still confused?  Me too, a bit.  Maybe just sleep on it and come back.