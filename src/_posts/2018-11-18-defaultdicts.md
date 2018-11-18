---
layout: page
title: "defaultdicts: Never Check If a Key is Present Again!"
description: An overview of how to use the defaultdict class that is provided by the Python standard library.
tags: python standard-library defaultdict
cover_image: dictionary.jpg
---

*Cover image by Romain Vignes on Unsplash.*

It's fall, so it seems like the perfect time to write some posts about PSL.  Nope, not Pumpkin Spice Lattes -- the Python Standard Library!  The Standard Library is a bunch of useful modules that come packaged with Python (Batteries Included!), so there's little-to-no security/maintenance burden incurred when you pull them into your code!

As I mentor people new to Python on Exercism, there are a couple of exercises that make big use `dicts`.  You might know them in other languages as a `hash`, `hashmap`, or `dictionary`.  Whatever you call them, I'm talking about the data type that maps one value, a **key**, to another value, commonly just referred to as **the value**.

This data structure is really nice for picking out particular items for reading or writing quickly by their keys.  It's commonly used to label and collect data, for use cases like a school roster, a word counter, or as a substitute for an object, with named fields (although, in Python, there are a few better options than a plain ole' dict for that.  But that's another article).

Because of these use-cases, you often see code that needs to do this:

```python
grades = ["A", "A", "B", "C", "D", "C", "B", "C", "A", "C", "B"]

counter = dict()
for grade in grades:
    if grade in counter:
        counter[grade] += 1
    else:
        counter[grade] = 1
```

You need to check if that particular grade letter is in the `counter` dict before trying to add 1 to it.  Otherwise you'll run into errors!

There *is* a workaround that's reasonably clear and easy to read: our friend `get`.

```python
for grade in grades:
    counter[grade] = counter.get(grade, 0) + 1
```

By default, `dict.get(key)` returns `None` if the key isn't found instead of raising a `KeyError` like normal, *but* if you add that second argument to the `get` call, it will return that default instead, allowing you to update or create the key all in one line.

*But Ryan,* you say.  *That seems like an* awful *lot of work to do just to have a dict provide me with a default value when a key is missing!*  And you're right!

There's an even better way.

Let me introduce you to the [**Collections Module**](https://docs.python.org/3/library/collections.html).  Check out the documentation.  There's a lot more goodies in there (not least of which is the actual `Counter` class which takes care of our very problem here.  But, again, that's for another PSL article).  Specifically, we are looking at the `defaultdict` class.  Here's how it helps us solve the problem above.

```python
from collections import defaultdict

counter = defaultdict(int)

for grade in grades:
    counter[grade] += 1
```

Here's how it works.  The `defaultdict` constructor takes one argument: a function (or other callable).  Notice that we don't *call* the function argument (`int`), so there's no parenthesis after `int`, we pass the function `int` itself.

Anytime the defaultdict encounters a key that it hasn't seen before, instead of raising a `KeyError`, it calls that function you gave it, creates this new **key** inside itself, and puts the result of the function call as the **value** of the pair.  The magic here is that the `int` function, which you usually use to convert strings or floats to integers, actually returns `0` when you don't pass it anything.

```python
>>> int("5")
5
>>> int()
0
```

You might be asking yourself, well do the other primitive constructors do the same thing?  You bet your little patootie they do!

```python
>>> str()
''
>>> list()
[]
>>> float()
0.0
# And EVEN
>>> complex()
0j
```

The `list` one actually comes in handy a lot.  Let's say you want to put things in bins:

```python
from collections import defaultdict

school_roster = defaultdict(list)

# Nico is in 2nd grade
school_roster[2].append("Nico")

# So is Lester
school_roster[2].append("Lester")

# Laura is in 5th grade
school_roster[5].append("Laura")

school_roster
# => defaultdict(list, {2: ['Nico', 'Lester'], 5: ['Laura']})
```

But what if you want to make a custom constructor?  Like I said, it works with any callable that takes no arguments and returns something!

```python
def happy_constructor():
    return ":)"

happy_dict = defaultdict(happy_constructor)

happy_dict["Ryan"]
# => ":)"
```

More frequently, though, if the constructor is short like this, you'll see it in `lambda` form, which is just a fancy way of making a quick, short, throwaway, anonymous function.

```python
happy_dict = defaultdict(lambda: ":)")
happy_dict["You"]
# => ":)"
```

If your custom class doesn't take any arguments in its `__init__` method, you can pass in your own class, too.

```python
class Dog:
    def __init__(self):
        self.treats = 0
    
    def woof(self):
        return "Woof!"
    
hotel_for_dogs = defaultdict(Dog)
hotel_for_dogs["Fifi"].woof()
# => "Woof!"
```

There's a lot of cool things you can do with this class.  Do you have any cool ways you've used it?  I want to know about them!

