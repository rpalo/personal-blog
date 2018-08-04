---
layout: page
title: 3 Common Mistakes that Python Newbies Make
description: Some common patterns that could use a little refactoring that I've seen with new Python learners.
tags: python beginner
cover_image: whoops_snake.jpg
---


Last weekend, I stared mentoring people on [exercism.io](https://exercism.io) on the Python track.  I wasn't sure what to expect, but over the last week I have mentored about 50 people, helping them get their solutions from "tests passing" to "tests passing, readable, *and* Pythonic."  I'm hooked.  It's a total blast.  I'm going to write a post specifically on that experience.  That's not this post.  This post is to talk about the three most common mistakes I saw over the last week and some possible alternatives that might be better!  So let's start the countdown!

## 1. Deep Nesting of If Statements or Loops

```python
# Calculating whether or not 'year' is a leap year

if year % 4 == 0:
    if year % 100 == 0:
        if year % 400 == 0:
            return True
        else:
            return False
    else:
        return True
else:
    return False
```



A lot of times, I'll pull a line from the [Zen of Python](https://www.python.org/dev/peps/pep-0020/#id3) to lead off my feedback to a "mentee" (not to be confused with a manitee).  When I see this issue, I always lead with

> Flat is better than nested.

If you look at your code with your eyes unfocused, looking at the shapes and not reading the words, and you see a bunch of arrows going out and back in again:

```
\
 \
  \
   \
    \
    /
   /
  /
  \
   \
    \
     \
     /
    /
   /
  /
 /
/
```

It's not *definitely* a bad thing, but it is a "code smell," or a Spidey Sense that something could possibly be refactored.

So, what can you do instead of nest?  There are a couple things to try.  The first is inverting your logic and using "early returns" to peel off small pieces of the solution space one at a time.

```python
if year % 400 == 0:
    return True
if year % 100 == 0:
    return False
if year % 4 == 0:
    return True
return False
```

If the number is divisible by 400, then we immediately return true.  Otherwise, for the rest of our code, we can know that year is *definitely not* divisible by 400.  So, at that point, any other year that's divisible by 100 is not a leap year.  So we peel off that layer of the onion by returning False.

After that, we can know that `year` is definitely not a multiple of 400 *or* 100, and the remainder of the code follows the same pattern.

The other way to avoid nesting is by using "boolean operators:" `and, or, and not`.  We can combine `if` statements and thus, save ourselves a layer of nesting!

```python
if year % 4 == 0 and (year % 100 != 0 or year % 400 == 0):
    return True
else:
    return False
```

Of course, that leads us to our second item...

## 2. Returning Booleans from If Statements

We'll start with our last example from above:

```python
if year % 4 == 0 and (year % 100 != 0 or year % 400 == 0):
    return True
else:
    return False
```

Anytime you find yourself writing:

```python
if something:
    return True
else:
    return False
```

You should remember that the clause of an `if` statement is itself a boolean!

```python
>>> year = 2000
>>> year % 4 == 0 and (year % 100 != 0 or year % 400 == 0)
True
```

So, why not type a little less and return the result of the boolean operation directly?

```python
return (year % 4 == 0 and (year % 100 != 0 or year % 400 == 0))
```

Granted, at this point, the line may be getting a little long, but the code is a little less redundant now!

## 3. Lists are Like Hammers -- Not Everything is a Nail

Here are two possible ways that this could show up:

```python
some_numbers = [1, 2, 5, 7, 8, ...]
other_numbers = [1, 3, 6, 7, 9, ...]
# Let's try to combine these two without duplicates
for number in other_numbers:
    if number not in some_numbers:
        some_numbers.append(number)
```

Or:

```python
data = [["apple", 4], ["banana", 2], ["grape", 14]]
# What fruits do we have?
for item in data:
    print(item[0])
# => "apple" "banana" "grape"
# How many grapes do we have?
for item in data:
    if item[0] == "grape":
        print(item[1])
# => 14
```

In the first case, you're trying to keep track of some groups of items and you want to combine them without duplicates.  This is an *ideal* candidate for a [`set`](https://www.geeksforgeeks.org/sets-in-python/).  Sets inherently keep track of their items (although not the order, so don't use a set if the order is important).  You can declare them with the built-in `set()` function or with squiggle braces (`{}`).

```python
some_numbers = {1, 2, 5, 7, 8}
other_numbers = {1, 3, 6, 7, 9}
# Sets use the 'binary or' operator to do "unions"
# which is where they take all of the unique elements
some_numbers | other_numbers
# => {1, 2, 3, 5, 6, 7, 8, 9}

# You can even add single items in!
some_numbers.add(10)
# => {1, 2, 5, 7, 8, 10}

# But adding a duplicate doesn't change anything
some_numbers.add(1)
# => {1, 2, 5, 7, 8, 10}
```

In the second case, again, order probably isn't critical.  You want to keep track of some data by a "label" or something, but be able to keep them all together and list them out as necessary.  This time, you're probably looking for a `dict`.  You can create those with either the `dict()` built-in function or, again, squiggle braces (`{}`).  This time, however, you separate the labels (keys) and the values with a colon.

```python
fruits = {
    "apples": 4,
    "bananas": 2,
    "grapes": 14,
}
```

You can list out all of the keys (or values!).

```python
list(fruits.keys())
# => ["apples", "bananas", "grapes"]
list(fruits.values())
# => [4, 2, 14]

# Or both!
list(fruits.items())
# => [("apples", 4), ("bananas", 2), ("grapes", 14)]
```

And you can ask it about (or give it a new value for) specific keys.

```python
# How many grapes are there?
fruits["grapes"]
# => 14

# Not anymore.  I ate some.
fruits["grapes"] = 0

fruits["grapes"]
# => 0
```

Using a list, the your algorithm loops through every item to find the right one.  `dict`'s are built to have very fast lookups, so, even if your `dict` is a bazillion fruits long, finding the `grapes` is still super fast -- and easy to type!  No loops!

## Call to Action

Exercism needs mentors!  If you think you'd be a good mentor (or even a decent mentor, just on the easy exercises), sign up at [their Mentor Signup page](http://mentoring.exercism.io/).  Right now, Rust, Golang, and Elixir are especially swamped and need *your* help!