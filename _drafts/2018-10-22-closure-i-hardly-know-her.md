---
layout: page
title: Closure? I Hardly Know Her!
description: Why closures are useful, even if you don't notice that you're using them.
tags: go python functional
cover_image:
---

# Closure? I Hardly Know Her!

I've learned about closures a few different times, and each time, I've come away feeling like I get it, but I don't necessarily understand why people make such a big deal out of them.  Yeah, hooray, you get functions that can persist their data!  I've seen people post things like, "If you're not using closures, you're really missing out."  I think I've finally figured out why people are so excited, and why, up until last week, I haven't really been that excited.  This post will explain what closures are, when you might want to use them, and why it took me so long to get why they're special.

## What are Closures

A closure (also called a *function closure* or a *lexical closure*) is when you find a way of wrapping up a function with the state in which it was defined into one connected and persistent bundle.  I'll show you a bunch of examples if that doesn't make sense.  There's a number of ways to create a closure, but the canonical one is to define and return a function from within another function.  Here's what I mean.

```python
def build_zoo():
    animals = []
    def add_animal(animal):
        animals.append(animal)
        return animals
    return increment

zoo_a = build_zoo()
zoo_b = build_zoo()

zoo_a("zebra")
# => ["zebra"]
zoo_a("monkey")
# => ["zebra", "monkey"]
zoo_b("snek")
# => ["snek"]
zoo_a("panda")
# => ["zebra", "monkey", "panda"]
```

The `build_zoo` function is a kind of "factory" that creates a *scope* and defines a function within that scope.  Then it gives the function *that still has access to that scope (and the variables therein)* to you.  And every time you call this `build_zoo` function, it creates a brand new scope, unconnected to any of the other scopes.  That's why `zoo_a` and `zoo_b` were not able to affect each other when they were called!

### Side Note: Python and Scopes

In Python, you are unable to modify variables outside your scope without extra work.  So, if you tried something like this:

```python
def build_incrementer():
    current_value = 0
    def increment():
        current_value += 1
        return current_value
    return increment

incrementer = build_incrementer()
incrementer()
# => UnboundLocalError: local variable 'current_value' referenced before assignment
```

You get an error!  This is not so in many languages.  In many languages, it's ok to access variables in parent scopes.  In Python, you'll have to do this:

```python
def build_incrementer():
    current_value = 0
    def increment():
        nonlocal current_value # <==
        current_value += 1
        return current_value
    return increment
```

This lets you reach out and modify this value.  You could also use global, but we're not anarchists, so we won't.

## OK, but So What?

"You can keep track of state like a billion different ways!" you say exaggeratingly.  "What's so special about closures?  They seem unnecessarily complicated."  And that's a little bit true.  Generally, if I wanted to keep track of my state with a function, I would do it in one of a few different ways.

### Generator Functions

```python
def build_incrementer():
    current_value = 0
    while True:
        current_value += 1
        yield current_value

inc_a = build_incrementer()
inc_b = build_incrementer()

next(inc_a)
# => 1
next(inc_a)
# => 2
next(inc_a)
# => 3
next(inc_b)
# => 1
```

This method is very "Pythonic".  It has no inner functions (that you know of), has a reasonably easy-to-discern flow-path, and (provided you understand generators), gets the job done.

### Build an Object

```python
class Incrementer:
    def __init__(self):
        self.value = 0
    
    def increment(self):
        self.value += 1
        return self.value
    
    # Or, just so we can match the section above:
    def __next__(self):
        return self.increment()
    
inc_a = Incrementer()
inc_b = Incrementer()

next(inc_a)
# => 1
next(inc_a)
# => 2
next(inc_b)
# => 1
```

This is another good option, and one that also makes a lot of sense to me coming, having done a good amount of Ruby as well as Python.

### Global Variables

```python
current_value = 0
def increment():
    global current_value
    current_value += 1
    return current_value

increment()
# => 1
increment()
# => 2
increment()
# => 3
```

No.

*But, I--*

No.

*Wait!  Just let me--*

Nope.  Don't do it.

![Do you want bugs?  Because that's how you get bugs.](/img/closure-bugs.jpg)

Global variables will work in very simple situations, but it's an really quick and easy way to shoot yourself in the foot when things get more complicated.  You'll have seventeen different unconnected functions that all affect this one variable.  And, if that variable isn't incredibly well named, it quickly becomes confusion and nonsense.  And, if you made one, you probably made twenty, and now no-one but you knows what your code does.

![Well, at least it doesn't need obfuscating.](/img/closure-obfuscating.jpg)

## Why Closures are Cool

Closures are exciting for three reasons: they're pretty small, they're pretty fast, and they're pretty available.

### They're Small

Let's look at the rough memory usage of each method (except global variables) above:

```python
import sys

def build_function_incrementer():
    # ...

funky = build_function_incrementer()
def build_generator_incrementer():
	# ...
jenny = build_generator_incrementer()
class Incrementer:
    # ...
classy = Incrementer()

### Functional Closure
sys.getsizeof(build_function_incrementer)
# => 136
sys.getsizeof(funky)
# => 136

### Generator Function
sys.getsizeof(build_generator_incrementer)
# => 136
sys.getsizeof(jenny)
# => 88

### Class
sys.getsizeof(Incrementer)
# => 1056
sys.getsizeof(classy)
# => 56
```

Surprisingly, the generator function's output actually ends up being smaller.  But both the generator function, and the traditional closure are much smaller than creating a class.

### They're Fast

Let's see how they stack up, time-wise.  Keep in mind, I'm going to use `timeit` because it's easy, but it won't be perfect.  Also, I'm doing this from my slowish little laptop.

```python
import timeit

### Functional Closure
timeit.timeit("""
def build_function_incrementer():
	# ...
funky = build_function_incrementer()
for _ in range(1000):
	funky()
""", number=1)
# => 0.0003780449624173343

### Generator Function
timeit.timeit("""
def build_generator_incrementer():
	# ...
jenny = build_generator_incrementer()
for _ in range(1000):
	next(jenny)
""", number=1)
# => 0.0004897500039078295

### Class
timeit.timeit("""
class Incrementer:
    def __init__(self):
        self.value = 0

    def increment(self):
        self.value += 1
        return self.value

    def __next__(self):
        return self.increment()

classy = Incrementer()
for _ in range(1000):
    next(classy)
""", number=1)
# => 0.001482799998484552
```

Once again, the class method comes in at the bottom, but this time we see a marginal speed bump with the functional closure.  However, keep in mind, the final argument for closures is the strongest one.

### They're Available

This is the one that took me the longest to find out.  *Not all languages are as lucky as Python.*  (Excuse me while I prepare my inbox for a deluge of hate mail.)  In Python, we are lucky enough to have Generators as well as a number of ways to create them, like Generator functions.  Honestly, if I had to choose from the above methods, and I was writing Python, I'd actually recommend the Generator Function method, since it's easier to read and reason about.  