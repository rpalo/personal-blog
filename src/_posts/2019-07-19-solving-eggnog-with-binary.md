---
layout: page
title: Solving Eggnog Problems with Binary
description: Binary is not scary.  It's math with light switches.  And it can be used to solve a wider range of problems than you might think!
tags: python binary
---

Binary.  It feels like a concept that you only need for esoteric or complicated things like complex number problems, writing byte-code, building executables, encryption, and digital forensics.  But really, it’s just math that you can do with light switches!  And sometimes, knowing whether a light switch is on or off, true or false, in or out, is actually a lot easier to reason about than any other way of looking at a problem.

Let’s look at an Advent of Code puzzle that I was fiddling with in my break time.

The year is 2015.  The day is 17.  And the elves bought too.  Much.  Eggnog.  150 liters too much!  Luckily you’ve got a bunch of containers to put it in.  Less luckily, all of the containers are different and unpredictable sizes.  That’s your puzzle input.  It looks like this:

```Plaintext
11
30
47
31
32
36
3
1
5
3
32
36
15
11
46
26
28
1
19
3
```

Woah, right?  So the question is this: how many different ways are there that you can hold *exactly 150 liters* with different combinations of these containers (each measured in liters)?

## First Thoughts

My first thought was that we’re dealing with combinations.  We don’t care about the order that the containers are used in, we just want to try every possibility of using or not using each one.  “Ooh!  Python has a `itertools.combinations` function that will help me!”  But then I looked it up and it only returns fixed-length subset combinations of a larger collection.  Fixed-length isn’t going to help me!  My results could be any number of these containers.

As usual, my second thought was, “OK, let’s do it the simple way.  What do I have to loop over?”  But what *would* you loop over?  You’d have to go through the whole thing and find all combinations of length 1, then all combinations of length 2, then all combinations of length 3…  Actually, you know what?  As I type this out, that’s starting to sound like a viable option.

**But I didn’t think of that at the time!**

So here’s what I came up with and how binary comes in.  We’ll use some neat Python standard lib modules along the way.

## Binary: Just a Bunch of Light Switches

I got to thinking about the definition of a combination.  For each container, the possible options were “use it” or “don’t use it.”  It’s either “in” or “out” of the solution.  Well, that sounds like a row of toggle switches all lined up.  And then, we  would need to iterate through the possibilities somehow.

Well, for each container, we have two options.  For two containers, we would have 2 x 2 options.  For three containers we would have actually 8 options:

```Plaintext
no no no
no no yes
no yes no
no yes yes
yes no no
yes no yes
yes yes no
yes yes yes
```

8 options, or 2 x 2 x 2, better known as `2^3`.  For four containers, each one having two options, it would be 2 x 2 x 2 x 2 or `2^4` or 16 options.

So, for our input we have 20 containers.  That’s `2^20` options, or 1,048,576 possibilities.  Actually, a pretty doable number of overall iterations!  There may be a better way, but premature optimization is the root of all evil, so let’s try it the easier, brute force way first and see if it’s fast enough for our needs.

> Premature optimization is the root of all evil.
> -- Donald Knuth

Now we just need a nice methodical way of stepping through the on/off possibilities like we did in the 8 options above.  Except that typing that many yes’s and no’s is going to get exhausting.  I’m going to use a shorthand where 1 means yes and 0 means no.  I’m not being very sneaky about this—can you see where it’s going?  Let’s lay out all the possibilities for the four-container problem I mentioned above.

```Plaintext
0000
0001
0010
0011
0100
0101
0110
0111
1000
1001
1010
1011
1100
1101
1110
1111
```

It’s kind of like we’re counting, but with only two possibilities (1 or 0) instead of 10 (0-9) for digits.  Oh, crap, we just re-invented binary.  You could see this coming from a mile away.  Or maybe you couldn’t and you’re just having binary click for the first time!  Congratulations!  Either way is fine, because now we can solve our eggnog problem.

You know the neat thing about binary?  You can convert regular numbers to binary!  So instead of figuring out how to write an algorithm that counts in binary, we will need a very complex and mysterious algorithm for counting in regular numbers:

```python
for i in range(2**20):
    print(i)
```

Tada!  We’ve just invented the for-loop!  We’re having a very productive day.

## Programming the Solution

Great.  There are three more pieces to figuring out our solution.

1. How do we convert our regular number `i` to binary?
2. How do we convert *that* to a useful selection of containers from our list?
3. How do we check to see if that selection of containers is a solution to the problem?

That may seem like a lot, so we’ll handle this the same way you eat an elephant: one bite at a time.  One byte at a time?  Eh?  Eh?

![Binary Joke FTW](https://static-similan.similandivingtours.com/images/Blog/information/moral-eels-in-Thailand/Giant-Moray-eel.jpg "An eel looking like he's waiting for you to laugh at his joke.")

### Converting to Binary

Usually, if you just want to do binary operations on a number in Python, you don’t even have to “convert” to binary.  That’s a common beginner’s mistake, and one that has about a billion wrong answers on StackOverflow.  However, in this case, we actually want a list of ones and zeros to iterate over, rather than a full binary number.  There are several ways you can handle this.  The shortest way is probably—unfortunately—to abuse the `bin` function in Python, which returns a *string* representation of the number in binary (e.g. `"0b0010101"`).  Something like this *almost* works:

```python
bits = [1 if bit == "1" else 0 for bit in bin(i)[2:]]
```

You need the `[2:]` to scrape off the `0b` at the beginning, and you need to get back to integers after a brief stop in string-land.  Overall, not my favorite, but probably easier and simpler  than the alternatives.  But, because this checks the digits from left to right, and different numbers have different numbers of bits, we’ll need to left-pad our binary number with zeros to ensure that we start on the same digit every time.  Luckily strings have a handy-dandy `zfill` method that prepends zeros to strings until they’re the length we want.

```python
binary_number = bin(i)[2:].zfill(len(containers))
bits = [1 if bit == "1" else 0 for bit in binary_number]
```

Hmmm… I dunno.  That’s starting to look awfully hacky and murky.  Personally, my preference would be to do something like this where we calculate it more similarly to how the math actually works.

```python
def bits(number):
    while number > 0:
        yield number % 2
        number >>= 1
```

> Note: this is a concept in Python that might be a little unfamiliar called a generator function.  When we call this function, it creates a generator, which we can iterate over to receive our values.  Or, if we’re greedy, we can use the `list` function to get them all right now into a list.  Generators are a little more efficient than making a list, because it’s lazy and only evaluates one item at a time, and a lot of times it’s actually easier to reason about when you see how items are generated in a function rather than in a list comprehension for some reason.

If a number is divisible by 2, it’s rightmost bit will be a zero.  Otherwise it will be a one.  So, what we’re doing here is yielding the right-most bit of the number, shifting the number to the right to drop that bit, and continuing until we are out of number.  A little more technical to understand, but we depend less on weird Python idiosyncrasies and our intent is clearer.

We can use it like this:

```python
>>> for bit in bits(i):
...     print(bit)
1
0
0
1
1
1

>>> bits(i)
<generator object bits at 0x10eaf3480>

>>> list(bits(i))
[1, 0, 0, 1, 1, 1]
```

Now, there’s one important caveat here that you’ll notice.  These two methods that we’ve presented provide the bits *in opposite order*.  This method is **”Little Endian”** meaning it provides the bits in least-significant-bit-first order.  The other method, using `bin` is **”Big Endian”**, meaning it provides the bits in most-significant-bit-first order.  Usually, this is pretty important.  In our case, however, we just want to make sure we get through all the possibilities, so as long as we pick a method and stay consistent with which digit we start on (hence the padding in the first case), we don’t need to care.

OK, that was a lot of explanation for a couple lines of code, but I think it was worth it.

### Picking Containers with our Bits

This one’s easier.  How would we do this manually?  I’ll show you in three, gradually improving stages:

```python
result = []
for index in range(len(bits)):
    if bits[index] == 1:
        result.append(containers[index])
```

Pretty good, right?  We go through the bits and containers with the same index, and if that bit is a 1, we take the container at the corresponding index.  If it’s not, we don’t!  Light switches!  And it handles the weirdness about the fact that some smaller numbers have less bits than the number of containers without having to pad with a bunch of weird zeros (i.e. `bits(7)` returns, `[1, 1, 1]`, and we don’t have to add 13 more 0’s so that there are the same number of bits as containers.  Instead, we can iterate over the bits, and stop when we run out.

But, we’re using indices, which is yucky.  The fact that we had to type `range(len(` should be immediate warning bells.  There must be a better way!  And there is.  Anytime you find yourself using indices because you need to connect two lists together somehow, you’d probably be better off with the `zip` function.

```python
result = [container for bit, container in zip(bits, containers) if bit == 1]
```

Ahhh, much nicer.  No indices, just a nice clean comprehension.

We can go even cleaner in this next step.  I would say that it’s probably optional.  The code we have there is pretty clean.  But I want to show it to you because it’s a neat function.

```python
from itertools import compress

result = compress(containers, bits)
```

That’s right!  In all of our wisdom, we have re-invented something the Python maintainers already gave us.  The `compress` function in `itertools` takes two iterables (similar to `zip`), and it filters the first one by only yielding items if the corresponding element in the second one is “truthy.”  This is why we needed to convert the digits from the `bin` function from strings to integers.  While `1` is truthy and `0` is falsy, unfortunately, both `"1"` and `"0"` are truthy because they are non-zero-length strings, so they won’t work for this method.

### Checking for a Solution

In the last step, we need to check if this collection of containers is a solution to the problem: does it add up to exactly 150 liters of space?

```python
if sum(result) == 150:
    good_combinations.append(result)
```

I don’t think we need to do more than that.

## Putting it All Together

Here’s what it looks like all together.  Remember that the puzzle is asking us how many different ways can we store exactly 150 liters.  I’ve streamlined a couple of things to make them a little more modular and easy to connect.

```python
"""Eggnog Storage: How can you store 150 liters exactly?"""

import itertools


def bits(number):
    while number > 0:
        yield number % 2
        number >>= 1


def perfect_fits(containers, target):
    for i in range(2**len(containers)):
        selection = itertools.compress(containers, bits(i))
        if sum(selection) == target:
            yield selection


if __name__ == "__main__":
    with open("containers.txt", "r") as f:
        containers = [int(line) for line in f.read().splitlines()]

    total_eggnog = 150  # liters
    good_options = perfect_fits(containers, total_eggnog)

    print("Combinations that work:", len(list(good_options)))

    # 4372
```

*Note: If this much generator-ing makes you a little nervous, here’s a version creating everything with lists the way you might be a little more familiar with.*

```python
"""Eggnog Storage: How can you store 150 liters exactly?"""

def bits(number, width):
    binary_number = bin(number)[2:].zfill(width)
    return [1 if bit == "1" else 0 for bit in binary_number]


def perfect_fits(containers, target):
    results = []
    for i in range(2**len(containers)):
        selection = [container
                     for container, bit 
                     in zip(containers, bits(i, len(containers))
                     if bit == 1]
        if sum(selection) == target:
            results.append(selection)

    return results


if __name__ == "__main__":
    with open("containers.txt", "r") as f:
        containers = [int(line) for line in f.read().splitlines()]

    total_eggnog = 150  # liters
    good_options = perfect_fits(containers, total_eggnog)

    print("Combinations that work:", len(good_options))

    # 4372
```

Personally, I think a little less pretty, but perfectly workable.  And now we can hold all our eggnog!

## Binary FTW!

Hopefully we didn’t get lost too much in the weeds of the problem with the technical implementation, generators, string vs. mathy bits, etc.  The whole thing I’m trying to show here is that, at its essence, we used binary to allow us to do a simple counting loop to help us select all the different combinations of containers, and that binary isn’t scary.  I’ll say it again.

> Binary isn’t scary—it’s just math with light switches.

My goal is to inspire you to add binary to your toolbox and at least consider it anytime you find yourself in a situation where you’re dealing with a set of items that may or may not be selected.  This may be toppings on a pizza.  Maybe it’s different status effects in an RPG.  Poisoned, burned, and sleepy?  `111`, or `status = 7`.  Just poisoned and sleepy?  `101`, or `status = 5`.  Only burned?  `010`, or `status = 2`.  

Binary is cool, and you are cool too!
