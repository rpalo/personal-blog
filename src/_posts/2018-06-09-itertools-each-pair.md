---
layout: page
title: Each Pair with Itertools
description: This week I saw a slick way of iterating through each pair of items in a list in Python and wanted to share it.
tags: python tricks itertools
cover_image: pears.jpg
---

*Cover Photo by [Dan Gold](https://unsplash.com/photos/hXaHghBkEMQ?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/search/photos/pears?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)*.

Quick Tip Time!

This week I was working on some coding challenges on [Rosalind](http://rosalind.info) in Python.  For one of the problems, I needed to run through consecutive groups of characters in a string and do something with them.  For example, if the string was "ACGTACAGTACTGACAGATCA", I wanted to operate on the following substrings:

```text
"ACGT"
"CGTA"
"GTAC"
"TACA"
...
```

If I was writing in Ruby, this would be a perfect use case for the [each_cons](https://ruby-doc.org/core-2.5.1/Enumerable.html#method-i-each_cons) method!  Unfortunately, no such luck with a similar function built-in to Python.  I ended up going with the slightly less pretty:

```python
def each_cons(n, iterable):
    """Returns every n consecutive items in an iterable.
    Example: each_cons(4, range(10)) => [0, 1, 2, 3], [1, 2, 3, 4], [2, 3, 4, 5]...
    """
    return (iterable[i: i + n] for i in range(len(iterable) - n + 1))
```

Anytime you write `range(len(...`, there's probably a better way you could have done things.  **If you know a slicker, less indexy way to do this, please share it, because there's got to be a better way.  I can't be indexing into things manually like a barbarian.**

However, that's not what this post is about.  In my search for a better way, I came across a clever use of the `itertools` module that was too good not to share.

## Each Pair with Itertools

This method only really works cleanly if you need only two consecutive items, but it feels *very* Pythonic to me.  I'll show you the code and then point out the key parts.

```python
from itertools import tee

def each_pair(iterable):
    """Returns each consecutive pair of items in an iterable"""
    first, second = tee(iterable)
    next(second, None)
    return zip(first, second)

each_pair(range(10))
# => [0, 1], [1, 2], [2, 3], [3, 4], [4, 5]...
```

Ahhhh *SO GOOD.*

## The Magic Explained

So, how does it work?

First, we use `itertools.tee`, which returns two copies of the original iterable (a fancy word for anything you can iterate through: strings, lists, generators, etc.).  It also takes an optional argument for `n` if you want to make `n` copies instead of just 2.

Now we have two identical copies of the original iterable.  We then call `next` on the second one in order to step it one item forward.  Notice the second argument to `next`, `None`.  The `next` function returns (and uses up) the next item in an iterable, and if you provide it a *default* and it can't return another item because that iterable is empty, it just returns the default.  

```python
# next only works on Iterator objects
a = iter([1, 2, 3])
next(a, "EMPTY")
# => 1
next(a, "EMPTY")
# => 2
next(a, "EMPTY")
# => 3
next(a, "EMPTY")
# => "EMPTY"
next(a)
# => Error!  StopIteration!
```

This is just a neat way of saying "cycle the `second` iterable one item forward, but if you're already empty, don't worry about it.  Just don't throw an error."  You probably also noticed that we don't do anything with the result of this call to `next`.  We're just throwing an item away, if it exists.

The last part is zipping the two iterables together.  `zip` is a tricky function that seems simple, but often the results can be hard to wrap your head around.  It makes each n-th item of each iterator it is passed into one single list.

It's  easier to see in an example:

```python
a = [1, 2, 3, 4]
b = ["Apple", "Banana", "Pear", "Soup"]
c = [True, False, True, False]

zip(a, b, c)
# => [
#       [1, "Apple", True],
#       [2, "Banana", False],
#       [3, "Pear", True],
#       [4, "Soup", False],
#	]
```

The trick is that, if our lists have different lengths, it will only use up to the shortest one.

```python
a = [1, 2, 3, 4, 5, 6, 7, 8]
b = [1, 2, 3]
zip(a, b)
# => [[1, 1], [2, 2], [3, 3]]  See how it drops the last 5 elements of 'a'?
```

> The `itertools` module also has a `zip_longest` function that takes a default value to fill in if some of the arguments to zip are too short.
>
> ```python
> a = [1, 2, 3, 4, 5, 6]
> b = [1, 2]
> itertools.zip_longest(a, b, fillvalue=":)")
> # => [
> #	    [1, 1],
> #	    [2, 2],
> #	    [3, ":)"]
> #	    [4, ":)"]
> #	    [5, ":)"]
> #	    [6, ":)"]
> # ]
> ```



## Wrap Up

Anyways, I thought this was neat.  I like it anytime I can get what I want out of an iterable without actually using any brute force indices.  It seems like it cuts down on [off-by-one](https://twitter.com/codinghorror/status/506010907021828096?lang=en) errors.

Like I said before, if you've got a better way to make the `each_cons` function above, I want to see it.  Be sure to comment or [tweet it at me](https://twitter.com/paytastic/).