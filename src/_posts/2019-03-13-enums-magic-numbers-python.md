---
layout: page
title: Giving Meaning to Magic Numbers with Python Enums
description: A quick little taste of the Enum module to show how cool it is.
tags: python standard-library
cover_image: python-enum.png
---

This article is not *super* in-depth.  I just discovered a cool module in the Python Standard Library and wanted to share it to spark your interest.  If you run into any issues with it and have any questions, though, I'm happy to try my best to help you work through it!

<hr>

## Using Python's `enum` Module

I was working through an exercise on [Exercism](https://exercism.io) that had to do with finding the best poker hand, and I found myself with lots of "magic values" floating around.  When I say "magic value," what I mean is a hard-coded constant that is supposed to have some sort of semantic meaning.  In this particular case, I had playing cards that could take on one of 13 different specific values, and some of these values had names.  And *then*, I had Poker hands that were getting scored, and those different types of hands also had intrisic values, where some hands were better than others.

My first iteration was extra magicky, and looked something like this:

```python
if self.is_straight() and self.is_flush():
    return 8
elif self.biggest_group() == 4:		# 4 of a Kind
    return 7
elif self.is_full_house():
    return 6
elif self.is_flush():
    return 5
elif self.is_straight():
    return 4
elif self.biggest_group() == 3:		# 3 of a kind
    return 3
elif self.is_two_pair():
    return 2
elif self.biggest_group() == 2:		# One pair
    return 1
else:								# High Card
    return 0
```

It felt weird and made my code-spidey-sense tingle.  But I let it pass.  Then I wrote this code:

```python
if value == "A":
    self.value = 14
elif value == "K":
    self.value = 13
elif value == "Q":
    self.value = 12
elif value == "J":
    self.value = 11
else:
    self.value = int(value)
```

More magic numbers!  I vaguely remembered that Python had an `enum` module in its standard library, and I also vaguely remembered that `enums` were supposed to be good for situations where you've got specific categories/types a value can take on.  So I did some research.  Turns out, they're actually even cooler than I thought.

The `enum` module has a bunch of different types of `enums`, but, because I was doing a lot of sorting, comparing, and relative ranking, as well as going between these and normal numbers, I decided on an `IntEnum`.  This just means that the `enum`'s values will be integers.  But what does that look like?

You can define an Enum with a functional syntax (much like you'd instantiate a class or create a type of `NamedTuple`), or you can create it with a class syntax.  You'll see both in this article, for different reasons.

I'll show the functional first, for the poker hand scores.  I'm going this route, because I don't really care what the numbers are.  I just want to make the relative ranking very clear.

```python
from enum import IntEnum

Score = IntEnum('Score', [
    'HIGH_CARD',
    'PAIR',
    'TWO_PAIR',
    'THREE_OF_A_KIND',
    'STRAIGHT',
    'FLUSH',
    'FULL_HOUSE',
    'FOUR_OF_A_KIND',
    'STRAIGHT_FLUSH',
])
```

And that's all we need.  Now we can see their relative values and compare them!

```python
>>> Score.STRAIGHT.value
5
>>> Score.FOUR_OF_A_KIND > Score.THREE_OF_A_KIND
True
>>> Score.FLUSH < Score.HIGH_CARD
False
```

This allows us to semanticize (my new word, thank you!) our code above:

```python
if self.is_straight() and self.is_flush():
    return Score.STRAIGHT_FLUSH
elif self.biggest_group() == 4:
    return Score.FOUR_OF_A_KIND
elif self.is_full_house():
    return Score.FULL_HOUSE
elif self.is_flush():
    return Score.FLUSH
elif self.is_straight():
    return Score.STRAIGHT
elif self.biggest_group() == 3:
    return Score.THREE_OF_A_KIND
elif self.is_two_pair():
    return Score.TWO_PAIR
elif self.biggest_group() == 2:
    return Score.PAIR
else:
    return Score.HIGH_CARD
```

A lot more readable!  One way that you know that we're doing something right is that I was able to delete the explanation comments for some of the less clear conditions without losing any readability at all.  Cool, right?

Now, lets look at the other case with the face card values.  For this one I used the Class syntax, because I wanted to add a little more functionality.  More on that in a minute.  Here's the starting code.

```python
class FaceCard(IntEnum):
    """Numeric values of face cards"""
    JACK = 11
    QUEEN = 12
    KING = 13
    ACE = 14
```

Now we can use it like a regular number, but it *has a name!*

The inputs were provided as strings of characters: `"AH"` for Ace of Hearts, `"8C"` for 8 of Clubs, etc.  I started by defining a card like this:

```python
class Card:
    def __init__(self, label):
        self.suit = label[-1]
        value = label[:-1]
        if value == "J":
            self.value = FaceCard.JACK
        elif value == "Q":
            self.value = FaceCard.QUEEN
        elif value == "K":
            self.value = FaceCard.KING
        elif value == "A":
            self.value = FaceCard.ACE
        else:
            self.value = int(value)

    def __lt__(self, other):
        return self.value < other.value
```

The `__init__` method is initializing the instance, and the `__lt__` method tells how these objects behave around the `<` operator.  We can now compare them like this:

```python
>>> king = Card("KS")  # King of Spades
>>> three = Card("3S")  # Three of Spades
>>> three < king
True
```

Even though the value for the king is actually a `FaceCard.KING`, it compares using its integer value, so I can treat it like a normal number for most things!  Enums are cool!

For more info, the [standard library docs](https://docs.python.org/3.7/library/enum.html) are really good.

## Bonus: Converting Back to Strings!

I thought `enum` was cool.  And then I found out that I needed to convert my card values back to their encoded strings for output.  As it turns out, Enums have two main properties: the `name`, which is like the "key", and the `value`.  Check this awesomeness:

```python
# The same FaceCard class as before:
class FaceCard(IntEnum):
    """Numeric values of face cards"""
    JACK = 11
    QUEEN = 12
    KING = 13
    ACE = 14

    # This is new:
    # Define a custom method to call when a case gets "stringified"
    def __str__(self):
        return self.name[0]
```

Now in our Card class:

```python
class Card:
    # ...
    def __str__(self):
        return str(self.value) + self.suit
```

And because we defined the custom `__str__` method for `FaceCard` the way we did, this code will work no matter whether the card is a face card or not!

```python
>>> eight = Card("8H")
>>> ace = Card("AD")
>>> eight.value
8
>>> eight.suit
"H"
>>> ace.value
FaceCard.ACE
>>> ace.suit
"D"
>>> str(eight)
"8H"            # str(eight) == str(8) + "H"
>>> str(ace)
"AD"            # str(ace) == str(FaceCard.ACE) + "D"
                # str(FaceCard.ACE) == "ACE"[0] == "A"
```

Right??  RIGHT?!?!  I mean, how elegant can you get?

<hr>

I want to know how *you've* used `enum` before.  Did you find a neat use case?  Are there other gems in the `enum` module that I haven't even discovered yet?