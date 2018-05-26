---
layout: page
title: Wishful Coding
description: Write code using methods you wish existed, and go back and write them later.
tags: tricks focus productivity
cover_image: wishful-cat.jpg
---

*Cover Image credit to [René de Ruijter](https://hatrabbits.com/author/rene/), at least, as far as I can tell.*

I've been doing the [Advent of Code 2017](https://github.com/rpalo/advent-of-code-2017) challenge this Advent, and I noticed that as I've been working on some of the harder challenges (number spirals, amirite?) I've started doing something that seems to really help me stay locked in to the problem.  It's definitely not something groundbreaking, but I figured that I'd share it, in case it helps somebody else.

## The Problem: Short Attention Spans and --

Stop me if this scenario seems like a personal attack:

You've just been handed a problem/assignment.  You know where you need to start, but as you begin to type the first outlines of your code, one of the things you need to do next pops into your head.  You quickly jump over and create a new file for that and try to get a brief sketch down so you won't forget later.  As you're doing that, you realize that the new thing that you're adding will need a test case, so you hop over and "just real quick" jot down the test case for what you were working on.  You run your tests to make sure everything's failing as expected, but you forgot to configure your tests and the output is all ugly and who could continue to work in that kind of environment?  You're not a *barbarian* after all!  And then two hours later… wait a minute, what was I originally working on?

Some of the solution is just self-discipline -- forcing yourself to finish what you're working on before you start the next thing.  However, one place I find these mental self-interruptions especially problematic is when I'm trying to solve a big problem and have to keep worrying about little parts of the solution.  This is where my tip can come in handy.

## One Solution: Use Methods You *Wish* You Had

This is probably best described with an example.

Let's say you're writing a script that controls an automatic treat dispenser for your dog.

![My dog Willy](/img/wishful-willy.jpg)

*This is Willy.  He's a very good boy.*

On your first pass through the code, you might write something like this.

```ruby
def train(dogs)
  dogs.each do |dog|
    if dog. # Pause here
```

Now you might think to yourself, *"Shoot!  Now I need to figure out when these dogs should get treats!"*  And just like that, your train of thought for the rest of the high-level function is gone.  

Here's my solution.  

I propose that you confidently carry on like nothing is wrong, and use the methods that you hope Future-You will write.

```ruby
def train(dogs)
  dogs.each do |dog|
    if dog.good_boy?
      dog.pat!
      give_treat(dog)
      @treats -= 1
    end
  end
end
```

*"But Ryan!  We haven't written methods like `good_boy?`, `pat!`,  or `give_treat` yet."*  EXACTLY.  That's a problem for Future-Us.  The important thing now is to keep you in that flow state and make sure you get your whole thought on the screen before you forget what you're supposed to be doing.  We'll come back and fill in the cracks later.

(For those of you that are really concerned, here's how `good_boy?` is implemented):

```ruby
class Dog
  # ...
  def good_boy?
    true
  end
end
```

😬

## Wrap Up

So that's the tip!  Write the code, and when you come to a section  that seems like it might bog you down **even a little bit**, just pretend you already have a method for that.  A secondary benefit of this is that it helps you identify where good places to pull code into separate methods are.  You can always come back and clean things up after everything's working a little better.

Got any other pro-tips for blocking out the distractions?  Let me know — I'd love to hear them!