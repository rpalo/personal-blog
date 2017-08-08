---
title: Cache Me Outside
layout: page
description: An easy trick to speed up your slower functions
cover_image: cache.png
tags: python tricks
---

I just came across a little nugget of wisdom after reading [this blog post](https://www.amin.space/blog/2017/5/elemental_speller/) about making words out of Periodic Table Elements.  I highly recommend the read.  However, that's not why we're here.  We're here to cache in on some of the benefits of Python's standard library.  

For those that don't know, caching is really useful for when a function is getting called with the same arguments repeatedly and you can expect the same result each time.  Instead of calculating the result each time, you save the result in your cache for later.  This is especially useful for functions that intrinsically take a long time to run, like API calls, file I/O, or super-duper nested loops.  Consider, for a moment, our humble friend the Fibonacci function.  In Python, a common (but grossly inefficient) version goes something like this:

{% highlight python %}
def fibonacci(n):
    """Finds the nth fibonacci number."""
    if n in [1, 2]:
        return 1
    else:
        return fibonacci(n - 2) + fibonacci(n - 1)

{% endhighlight %}

It looks really nice and is pretty understandable.  But imagine it running at even `n = 5`.  Here's a rough version of the call-stack:

{% highlight python %}
fibonacci(5)
    fibonacci(3)
        fibonacci(1) = 1
        fibonacci(2) = 1
        = 2
    fibonacci(4)
        fibonacci(2) = 1
        fibonacci(3)
            fibonacci(1) = 1
            fibonacci(2) = 1
            = 2
        = 3
----------------
2 + 3 = 5.
{% endhighlight %}

And that's only at # 5.  You can see how `fibonacci(2)` gets called *three times!*  Imagine what would happen if you tried to calculate `n = 10` or `n = 100`!  Don't worry.  I did.  Actually, for `n = 100` I got too bored waiting for it to finish up.  In fact, I couldn't even wait for `n = 50` to finish!  Even `n = 35` took like 7 seconds or so.  This is where the cache comes in.  You could probably make your own without too much trouble.  I tried a version way back in [this blog post](/2017/02/02/default-argument-tricks).  It came out pretty good if I do say so myself.  The only problem with adding a cache to a function is that it takes up a good number of lines of code and obscures what you actually want to show the function doing.  There are ways around that too, but why struggle and fight with that problem when the standard library (*trumpet fanfare*) has got you covered?

BEHOLD.

{% highlight python %}

from functools import lru_cache
# You should really look at the functools docs.
# I mean it, there's some awesome stuff in there!
# Also, FYI, LRU stands for Least Recently Used
# which is the item that gets booted from the cache when
# it hits its limit

@lru_cache(maxsize=128) # Works best with maxsize as a power of 2.
def fibonacci(n):
    """Finds the nth fibonacci number."""
    if n in [1, 2]:
        return 1
    else:
        return fibonacci(n - 2) + fibonacci(n - 1)

{% endhighlight %}

Notice how I didn't even change the main function?  I just thought to myself, "Oh, caching might be nice to have here," and sprinkled a little decorator on top.  I'll have to talk about decorators in another post, but just know that they're used to augment functions, usually to add side-effects like registering a function somewhere or, like you might expect, adding a cache.  How much benefit did we gain?  

Without the cache:

{% highlight bash %}
$ python3 -m cProfile fib.py -n 40
102334155
         204668315 function calls (7 primitive calls) in 89.028 seconds
{% endhighlight %}

Wowza.  With the cache:

{% highlight bash %}
$ python3 -m cProfile fib.py -n 300
222232244629420445529739893461909967206666939096499764990979600
         323 function calls (24 primitive calls) in 0.001 seconds
{% endhighlight %}

How bow dah?