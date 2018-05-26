---
layout: page
title: Dict Moves in Python
description: A quick tip on how to change a dictionary in Python into a defaultdict in a slick way.
tags: python tricks
cover_image: default-dict.jpg
---


Quick tip time!

Today, I started the #100DaysOfCode challenge again (for the millionth time).  I'm determined to actually succeed at this challenge, and I refuse to give up.  This time, I'm using the [Python Bytes Code Challenges website](https://codechalleng.es/) and their 100 days project suggestions.  During today's challenge, I learned a neat little trick for working with dictionaries that I wanted to share.

## The Challenge

The challenge is this: go through a [dictionary of words](https://raw.githubusercontent.com/rpalo/100DaysOfCode/master/001/dictionary.txt), which is really just a copy of `/usr/share/dict/words`.  Find the word that scores the highest in Scrabble, using these letter scores:

```python
SCRABBLE_SCORES = [
  (1, "E A O I N R T L S U"),
  (2, "D G"),
  (3, "B C M P"),
  (4, "F H V W Y"), 
  (5, "K"), 
  (8, "J X"), 
  (10, "Q Z"),
]
LETTER_SCORES = {
    letter: score for score, letters in scrabble_scores
    for letter in letters.split()
}
# {"A": 1, "B": 3, "C": 3, "D": 2, ...}
```

## The Issue

The issue is that I don't want to worry about whether or not there are any invalid characters in the input (for now at least).  So if I look up the word "snoot!43@@@ ", right now, I'd prefer to see the score for SNOOT and then 0 points for the rest of the characters.  I know there are a bunch of ways to do this, but the first way that popped into my head was to use a *default* of 0 (i.e. if you try to look up a character that's not in `LETTER_SCORES`, it returns zero instead of raising a `KeyError`.)

## Enter DefaultDict

Luckily for us, Python comes with exactly the thing we need: a `defaultdict`, courtesy of the standard library's `collections` module.  Its usage is reasonably straightforward: you supply the `defaultdict` with a class or function that constructs the default if the input isn't found.  Let me show you.

```python
from collections import defaultdict

zeros = defaultdict(int)
zeros["a"] = 1
zeros["b"] = zeros["definitely not in there"] + 4
print(zeros)
# => defaultdict(<int>, {"a": 1, "b": 4, "definitely not in there": 0})
```

Since the `zeros` dict can't find the `"definitely not in there"` key, it calls its default-maker function, `int`.  Go ahead and open up your Python REPL and try just calling the `int` function with no arguments.

```python
>>> int()
0
```

The `int` function, called with no arguments, returns 0 every time.

You can even create your own default-maker functions (and classes will work too)!

```python
from random import choice

def confusing_default():
    possibles = ["1", 1, True, "banana"]
    return choice(possibles)

tricky_dict = defaultdict(confusing_default)
tricky_dict["Ryan"]
# => "banana"
tricky_dict["Python"]
# => True
tricky_dict["Why would you do this?"]
# => 1
tricky_dict
# => defaultdict(<confusing_default>, {"Ryan": "banana", "Python": True, "Why would you do this?": 1})
```

Often times, you can do things a little quicker with `lambdas`.

```python
from random import randint

SCREAMING = defaultdict(lambda: "A")
for i in range(20):
    key = randint(0, 3)
    SCREAMING[key] += "A"
SCREAMING
# => defaultdict(<function <lambda> at 0x108707f28>, {0: 'AAAAAAAA', 1: 'AAAAAAA', 3: 'AAAAA', 2: 'AAAA'})
```

In fact, I actually think that using `defaultdict(lambda: 0)` is more explicit and less confusing than using `defaultdict(int)`, as long as you're not creating huge numbers of these `defaultdicts` this way.

## Upgrading to a DefaultDict

Now, finally, we're ready for the quick tip.  Up above, I defined `LETTER_SCORES` as a plain, old Python `dict`.  How do I get the default behaviors I want, quickly?  One way is using the built-in `dict.update()` function, which merges two dictionaries.

```python
FORGIVING_SCORES = defaultdict(lambda: 0)
FORGIVING_SCORES.update(LETTER_SCORES)

FORGIVING_SCORES["Q"]
# => 10

FORGIVING_SCORES["@"]
# => 0
```

Hooray!

Granted, this isn't a perfect solution, because the `FORGIVING_SCORES` defaultdict stores each of the invalid asks.  It's probably OK if you're not expecting a huge number of invalid look-ups.  If you *are* worried about staying space-efficient, though, it's probably better to do this:

```python
score = LETTER_SCORES.get("@") or 0
```

The `get` function returns `None` if a `KeyError` occurs, and the `or` allows us to provide a sane default if the lookup goes bad.  And everybody's happy!


