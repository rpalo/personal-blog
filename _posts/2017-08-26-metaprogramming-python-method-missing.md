---
title: Metaprogramming Python - Method Missing
description: Implementing Ruby's 'method_missing' method in Python
layout: page
tags: python ruby metaprogramming
cover_image: metaprogramming.jpg
---

I'm reading a book called [Metaprogramming Ruby](https://pragprog.com/book/ppmetr2/metaprogramming-ruby-2) by Paolo Perrotta, and it's really interesting!  I'm learning a lot.  Every so often, as I'm reading, I come accross a technique and I think to myself, "That's neat!  I wonder if I can do something similar in another language like Python?"  After some research, I thought I'd share one such discovery with everybody else.  But first, some background. 

## The Background: What is Metaprogramming?

Metaprogramming is a neat thing that some (all?  not sure) dynamic languages can do.  Essentially, it's a bunch of different ways of writing code that will, at runtime, write your code for you.  Let's take a look to see what I mean.

```python
>>> class Dude:
...     def __init__(self):
...         pass
...
...     def sup(self):
...         return "Sup, brah!"
>>> d = Dude()
>>> dir(d)
[ ...(lots of built-in methods, etc.), 'sup']
```

See that?  At runtime, we just peeked into an object and could see its methods!  Keep going.
```python
>>> if 'sup' in dir(d):
...     d.name = "Brad"
... else:
...     d.name = "Chad"
...
>>> d.name
'Brad'
```

Now, we have modified our objects based on the methods and attributes of those same objects.  Our code has caused code to be written (a little bit).  FEEL THE POWER.

## The Technique: Method Missing

If you're familiar with Ruby, you might know that Ruby objects have a built-in method called `method_missing` that gets called -- predictably -- if you call a method that doesn't exist inside that particular object.  You can do all sorts of things with this.  One is to dynamically generate methods at run-time based on things out of your control.  It saves on boilerplate code and constant refactoring.  We need an example to make things more clear though.

### Scenario: Crazy API Designer!

Let's say you're working with a teammate that drinks way too much coffee.  They manage the API that your program consumes, but they keep adding and changing the endpoint names.  The layout is always the same though, so that's predictable at least.  For instance, last Monday, the main resource was `beets`, and so you implemented a `get_beets()` method on your `Supermarket` class.  This method fetches the current `beet` objects in inventory... 

```python
class Supermarket:
    def __init__(self, api_root):
        self.api_root = api_root
    
    def get_beets(self, *args, **kwargs):
        url = f'{self.api_root}/beets/'
        return self.api_get(url, *args, **kwargs)

    def api_get(self, url, *args, **kwargs):
        ...
        # Imagine this method hits the api with the provided arguments
        print(f'{url} called with args: {args}')  # for this example
```

At least... it did until that yahoo decided to use the slightly more descriptive object name: `beetroot`.  And so, you go back to your code and update the method name and API call.  Then, they add `rootabegas` on the fly, even though most of your code is the same.  But!  You are sneaky, you are smart, and you know about **Metaprogramming**!  And so you reach for your `Supermarket`'s `__getattr__` method.

```python
import re

class Supermarket:
    def __init__(self, api_root):
        self.api_root = api_root
        self.pattern = re.compile(r'get_([a-z]+)')  # matches any get_[something] call

    def __getattr__(self, method_name):
        match = re.match(self.pattern, method_name)
        if match:
            def temp_method(*args, **kwargs):
                url = f'{self.api_root}/{match.group(1)}/'
                return self.api_get(url, *args, **kwargs)
            return temp_method
        else:
            raise AttributeError(f'No such attribute: {method_name}')

# Let's test it!
>>> s = Supermarket('example.com')
>>> s.get_beetroots(3)
'example.com/beetroots Called with args: (3)'
>>> s.this_should_error()
...
AttributeError: No such attribute: this_should_error
```

What just happened?  Let's hit the key points:

1. `__getattr__` is a builtin method in Python objects that gets called if Python can't find the method or attribute you're looking for.  We'll talk about this a little more in a minute.  But Python expects that this method will either return a function to be called or raise an AttributeError like normal.  As you can hopefully see, that's what we've done above.
2. We defined a [regular expression](http://www.rexegg.com/regex-quickstart.html) to match the API call method pattern that we expect.  We don't know what the object/endpoint will be, but we do know that it will start with "get_" and end with the object's name.
3. `__getattr__` gets passed the name of the method that gets called.  If the method name matches our regex, we move to step 4.  Otherwise we carry on with raising an AttributeError.  That gets shown in the last REPL call for `this_should_error`.
4. If the method call matches our regex, we want to build and return a function to call.  It doesn't necessarily matter what you call this inner function.  It might if we decided to permanently add it to our class, but we're not doing that now.  This function lays out the boilerplate we are looking to avoid.  It should take the parameters we expected functions like `get_beets` to accept.
5. `match.group(1)` returns the item in the first (and only) group of parenthesis in our regex, which happens to be the name of the objects we care about.
6. Finally, we return the function, which immediately gets called with the arguments that the user initially specified.

In a perfect world, we should probably have the `Supermarket` fetch a list of available endpoints so we can alert the user if they make API calls for something that isn't an available endpoint.  This might also help with security some.  I'll leave that as an exercise for the reader.

## Overriding `__getattr__`'s Methods

I have two more possible scenarios for you.  Both have the same solution.

### Scenario: Example Method or Overriding

What if you want to lay out an example method, so people who are reading your code can see an example of what one of the dynamically generated methods will look like?  OR.  What if you want to override a method, defining your own behavior.  Both are possible, since `__getattr__` only gets called after Python searches the object for the desired attribute.  Take a look.

```python
class Supermarket:
    ...
    def get_squash(self, *args, **kwargs):
        return "NO.  NO SQUASH.  It is the devil's gourd."

    def get_peanuts(self, *args, **kwargs):
        """
        Example of a dynamically generated API call method
        created by __getattr__
        """
        url = f'{self.api_root}/peanuts/'
        return self.api_get(url, *args, **kwargs)

>>> s = Supermarket('localhost')
>>> s.get_squash()
"NO.  NO SQUASH.  It is the devil's gourd."
>>> s.get_peanuts()
'localhost/peanuts called with args: []'
>>> s.get_bananas('big ones')
'localhost/bananas called with args: ["big ones"]'
>>> s.soup()
...
raise AttributeError(f'No such attribute: {method_name}')

```

It all works as planned!

## Caveat Meta

You should know that with great metaprogramming power comes great metaprogramming responsibility.  This kind of thing, if not well-laid-out and cleanly implemented, can make code super hard to read, reason about, and debug.  If you find yourself writing out more comments than code to explain how your object works, you should maybe ease up on the Meta.  In fact, I've read in several places that if you are unsure of whether or not you need metaprogramming, you probably don't.  And if you are pretty sure you do need it, you still maybe don't.  But, in specific instances, like when you need a bunch of methods that are all almost the same and you don't know ahead of time which ones should exist, it can be very powerful and save you a lot of maintenance, headache, and typing.

Overall, give it a try and maybe it will be a useful tip for you!  Let me know how it goes 😁

<hr>

P.S. - I really recommend checking out the *Metaprogramming Ruby* book I mentioned at the beginning of this article.

P.P.S. - If you found yourself going "What the F are these F-strings (e.g. `f'WHAT IS THIS'`)", fear not.  They're Python's newest string interpolation/formatting syntax.  I've got plans to write a post gushing about them in the near future.  They're similar to JavaScript's new `#{syntax}`.