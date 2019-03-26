---
layout: page
title: Python's random.choices is Awesome
description: I read some cool code that used random.choices and wanted to share it.
tags: python tricks standard-library
cover_image: python-random-choices.png
---

I'm reading through [Classic Computer Science Problems in Python](https://amzn.to/2FvzVDI) (affiliate link) by David Kopec, and I'm working on his Genetic Algorithm examples.  He got to the point where he describes the roulette-style selection process.

Some background: this isn't a post about Genetic Algorithms, but imagine this.  Assume you've got a group of candidates in a breeding process.  The roulette-style selection process means that you create a giant roulette wheel with all of the candidates on it, and the size of each candidate's wedge depends on their "fitness" score: how much of the desired result they have in them.  Then, you spin the wheel to randomly select based on these weights.

OK, so back to me.  

I read through that description and I was mentally gearing up to implement this.  We need to get each candidate's fitness, figure out how they stack up, normalize to a scale from 0 to 1, and then figure out how to randomize that selection.  Not impossible to implement, but it would take several lines or more of code to do it.  Cool beans.

Then I get to the author's solution.

And I just sat there.  Staring at it.

You know that feeling when you see something and it just makes you mad and because of how hard you worked on yours and then somebody comes in and does it the easy way?  But at the same time, you're also very impressed because it's awesome?

![Dang... But... Alright, that's fair.](https://i.imgur.com/hxdCpt2.gif)

Something like that.

Here.  Just look at it.  I tweaked it a little to show more context here:

```python
from random import choices

def pick_parent_candidates(population):
    fitnesses = [candidate.fitness() for candidate in population]
    return tuple(choices(population, weights=fitnesses, k=2))
```

It just...  It just does the thing.

Anyways, [`random.choices`](<https://docs.python.org/3/library/random.html#random.choices>) is pretty cool.  In fact, the whole `random` module has a lot of underrated functions that can save you oodles of time and code.