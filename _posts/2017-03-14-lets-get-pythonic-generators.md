---
title: Let's Get Pythonic -- Generators
description: Learning about generators in our journey to Python enlightenment
cover_image: generator.png
layout: page
tags: python tricks
---

A couple posts ago, I wrote about using generators to [efficiently create prime numbers](http://assertnotmagic.com/2017/02/24/optimal-primes.html). I think I promised then to go a little more in detail about them, which I am now doing here, thus proving that I am a dependable and trustworthy friend.  A little caveat.  Before I started writing this, I knew the basics, but I wanted to get a better grasp of the finer details.  [This article](http://intermediatepythonista.com/python-generators) by Obi Ike-Nwosu is where I got most of my extra details.  In fact, this article will mostly be for me, to make sure I have a grasp on everything, and will contain a significant amount of the information from his original article.  I strongly recommend you check out [The Intermediate Pythonista](http://intermediatepythonista.com/) for the abovementioned article and apparently many others as well.  For those of you committed to seeing me lay out a review of the same information in my own way, let us begin.

## Digging In

So.  Generators.  What are they?  Generators are a subset of a larger group of objects called *iterators*, which I'll explain in a minute.  In short, generators (or, generator-iterators) are functions that, instead of simply returning a value at the end, will pause and save their state until the next time they are called to continue running.  Lemme 'splain.  Have a gander at the following function:

{% highlight python %}

def powers_of_two(start, limit):
    """Returns a list of the powers of two from start up to limit"""
    results = []
    for i in range(start, limit):
        results.append(2**i)
    return results

    # For the pythonic at heart, this is probably more efficient
    # return [2**i for i in range(start, limit)]
    
{% endhighlight %}  

A pretty common pattern, yes?  Create a full list, and then do stuff with that list.  Sum it, map it, print it, filter it, count it, graph it, etc.  One thing that is maybe a bummer is if you wanted to not use the whole list for some reason.  You are forced to create the whole thing and then use it.  Another bummer is if you are unsure of your limit!  What if you're not sure how many powers it will take, you just want however many until `2**i > 10000000`?  That is where generators come in, with the `yield` keyword.  Check it.

{% highlight python %}

def shwoopy_powers_of_two(start, limit=None):
    """Generator that creates powers of two, beginning with start and, optionally stopping"""
    i = start
    while True:
        yield 2**i
        i += 1
        if limit and i >= limit:
            return

{% endhighlight %}

In this newer version, the yield keyword is used.  Let's see it in action:

{% highlight python %}
>>> powers = shwoopy_powers_of_two(1)
>>> next(powers)
2
>>> next(powers)
4
>>> next(powers)
8
>>> powers.next() # Same thing.
16
{% endhighlight %}

As you can see, you can grab each of the values as you need them -- lazily -- rather than producing the entire list first.  But what is it??  Let's see:

{% highlight python %}
>>> powers = shwoopy_powers_of_two(1)
>>> print(powers)
<generator object powers at 0x10ee65b90>
{% endhighlight %}

It's a generator!  But where are your items!?  Do you have to call next a bazillion times?  That's exhausting!  No, don't worry.  Most functions that take lists as inputs will also take these generator objects.  Look again:

{% highlight python %}
>>> powers = shwoopy_powers_of_two(1, 10)
>>> list(powers)
[2, 4, 8, 16, 32, 64, 128, 256, 512]
>>> # When you run through a generator object, you use it up!
>>> list(powers)
[]
>>> # No worries!  You can just reload it with your generator function.
>>> # It's a factory!
>>> powers = shwoopy_powers_of_two(1, 10)
>>> sum(powers)
1022
{% endhighlight %}

## Iterators

OK, back to the theory.  Just to clarify, generators, or generator functions, create generator objects.  These are disposable objects that you can call `next()` on to get values.  These generators are just quick and dirty ways to create generator objects though.  You can actually create your own (which is what the function does behind the scenes).  All you need to create an iterator object is an `__iter__` method.  All that you need to be an iterator object is a `next` method.  Generally, it is efficient to do both within the same object.  You'll see.

{% highlight python %}

class Alphabet:
    """Iterator that provides the uppercase alphabet letters"""
    def __init__(self):
        self.a = 65
        self.z = 90

    def __iter__(self):
        self.current = self.a
        return self # Use itself as the iterator object

    def next(self):
        while self.current <= self.z:
            this_one = chr(self.current) # This is important!
            self.current += 1
            return this_one
            # This line gets ignored!
        raise StopIteration

>>> a = Alphabet()
>>> for i in a:
...    print(i)
A
B
C
D
E
F
G # You get the idea
...
{% endhighlight %}

**A note of warning!**  When creating your own iterators, they do not pause execution in the middle of the next function like a `yield` would.  The important line in the above next function is that we update our current variable before we return anything.  Returning kicks us back to the top with whatever state we had at the time, leaving the last line of the while loop ignored!

The other thing of note that happened here (and which you can include in your generator functions as well) is the `StopIteration` exception.  When you throw that from within an iterator, it signals the for loop to stop looping.  If you come upon it by using the `next()` function, it will actually throw the StopIteration exception.

## Bonus 1: Generator Expressions

You know what are great?  List comprehensions.  Off topic, but a 15-second explanation.

{% highlight python %}
>>> result = []
>>> for i in range(20):
...    result.append(i**2)
>>> result
[0, 1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 121, 144, 169, 196, 225, 256, 289, 324, 361]
>>> # This can be accomplished with this simple list comprehension
>>> [i**2 for i in range(20)]
[0, 1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 121, 144, 169, 196, 225, 256, 289, 324, 361]

{% endhighlight %}

Even greater is that you can create generators with a similar generator expression.  Simply use () instead of [] and your sequence will lazy load!

{% highlight python %}
>>> a = (i**2 for i in range(20))
>>> a
<generator object <genexpr> at 0x106072cd0>
>>> sum(a)
2470
{% endhighlight %}

So what's the difference??  Generator expressions are throwaway versions that can only be used once.  They create items on the fly, however, so they use much less memory.  You should use them if you only need them once or if your sequence is very large.  If you need to loop over the sequence multiple times, stick to list comprehensions.

## Bonus 2: Recursive Yielding

One more thing!  Generators can delegate to each other!  Here is a silly example, and then a useful example.

{% highlight python %}

def ping(ponger):
    """Generator one, delegates to two"""
    for i in range(5):
        yield "Ping!"
        yield from ponger()

def pong():
    """Generator two, delegates back to one"""
    yield "Pong!"

>>> for i in ping(pong):
...     print(i)
Ping!
Pong!
Ping!
Pong!
Ping!
Pong!
Ping!
Pong!
Ping!
Pong!
{% endhighlight %}

See?  You can kick into a different generator to get more values.  A more useful example from my previous post:

{% highlight python %}
def prime_factors(number):
    """Returns a list of the prime factors of a number"""

    for i in range(2, number+1):
        if number % i == 0:
            yield i
            yield from prime_factors(number//i)
            break

>>> list(prime_factors(24))
[2, 2, 2, 3]
{% endhighlight %}

Recursive Generation!!!!  I guess, if you've already read the previous post, you're not that surprised, but it's cool, ja?  Anyways, there are a lot more things you can do with the new `yield from` keywords.  I suggest you check out the [official documentation](https://docs.python.org/3/whatsnew/3.3.html#pep-380) for ideas.

## Wrap Up

Whew!  This was a long one!  Like I said before, be sure to check out [the Intermediate Pythonista's take](http://intermediatepythonista.com/python-generators) on generators for similar information presented slightly differently.  Hopefully this article was helpful!



