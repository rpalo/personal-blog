---
layout: page
title: It's Ruby, There Must Be a Better Way
description: When you let the Ruby language work for you, it can speed up your code and save you a lot of headache.
tags: ruby exercism challenge
cover_image: robot-turtle.jpg
---

I was recently doing a challenge on [Exercism](https://exercism.io), on the Ruby track, and I struggled a lot, but when I ended up with a final solution, I was amazed at how much the power of Ruby let me simplify my code.  

It's a pretty cool challenge, so, I'll lay out the premise first, and then you can try it out.  If you're really into it, the Ruby tests for this exercise are [in the Exercism Ruby repo](https://github.com/exercism/ruby/blob/master/exercises/robot-name/robot_name_test.rb).  Most of the repos for the other languages have similar test suites for this exercise as well.  This exercise is called **Robot Name**.

## The Premise

You are creating a line of robots that each have a unique name.  Their names all follow the pattern `letter letter number number number`.  A couple of valid names might be `AB123`, `YE801`, or `RP100`.  This means that there are `26 * 26 * 10 * 10 * 10` possible names.  So here's the challenge. 

1. Write a class that creates Robots.
2. Each Robot created must have a unique name that matches the pattern above.
3. Robots must be able to be `reset`, wiping their memory and forgetting their name, receiving a new one that is still unique.  Don't worry about recycling their name and returning it to the pool.  We'll assume that once a name is taken, it's used up.
4. The name sequence **must be random**.  That means the sequence must not be predictable.
5. The Robot Class must have a `forget` method that makes it forget the current state of robots, resetting any shared state it may have.

Make sense?  OK, if you're going to attempt this challenge, off you go.  I'm going to share my journey below.

## My Journey

### 1. Naive Guess and Check

The difficulty of this exercise is mainly in the fact that *there are so many possibilities for names*.  Any attempt to build all of those strings and combinations through looping or appending to a list are just waaaay too slow.  I tried a bunch of different approaches, and there were actually several false-start versions before I reached version 1.  My first thought was to naively keep track of the names used, generate a random name, and check if it's in the list:

```ruby
class Robot
  LETTERS = ('A'..'Z').to_a
  NUMBERS = ('0'..'9').to_a
    
  @@taken_names = []
    
  def self.forget
    @@taken_names = []
  end
    
  attr_reader :name
    
  def initialize
      reset
  end
  
  def reset
    name = ""
    loop do
      name = LETTERS.sample(2) + NUMBERS.sample(3)
      break if ! @@taken_names.include?(name)
    end
    @name = name
  end
end
```

This works great for the first bunch of robots created, but as soon as you get high enough that there start to be collisions, you quickly realize you've got an algorithm that could, in theory, run infinitely long searching for a needle in a 676,000-strand haystack!

But this is Ruby!  There's got to be a better way!  Maybe we should do it the other way, starting with a list of possible names and then popping them out, guaranteeing no collisions.

### 2. Popping Names Off a List

So that's a great thought, but how to build the list of names?  Something like this?

```ruby
@@names = LETTERS
  .product(LETTERS, NUMBERS, NUMBERS, NUMBERS)
  .map(&:join)
# => @@names = ['AA000', 'AA001' ... 'ZZ998', 'ZZ999']
```

OK, that works.  The `product` method creates a "Cartesian Product" between all of its arguments.  For example:

```ruby
[1, 2, 3].product([4, 5])
# => [
# [1, 4],
# [1, 5],
# [2, 4],
# [2, 5],
# [3, 4],
# [3, 5],
# ]
```

That giant product above creates a list like this:

```ruby
[
  ['A', 'A', '0', '0', '0'],
  ['A', 'A', '0', '0', '1'],
  ...
```

That's why we join them all together into single strings via the `.map(&:join)` method.

Startup time for our class (as well as `forget` run time) is pretty long, but maybe that's allowable, seeing how much time it saves us on our algorithm.  Right?  Right?

Wrong.  When our list is huge, randomly choosing an index and then popping that out takes FOR.  EVER.  Because, each time we pop an item out, all of the items behind that item have to figure out what to do with the gap that it left.  This list of names is so huge, it's like trying to turn the Titanic.  And how'd that work out for Leo?!  (Too soon?)  

I even tried generating a giant list of integers instead and converting each integer to my own custom numbering system that was (base 26, base 26, base 10, base 10, base 10), but that was more confusing and not any better.

```ruby
class Robot
  LETTERS = ('A'..'Z').to_a
  NUMBERS = ('0'..'9').to_a
    
  @@possible_names = LETTERS
    .product(LETTERS, NUMBERS, NUMBERS, NUMBERS)
    .map(&:join)
    
  def self.forget
    @@possible_names = LETTERS
      .product(LETTERS, NUMBERS, NUMBERS, NUMBERS)
      .map(&:join)
  end
    
  def initialize
    reset
  end
    
  def reset
    next_index = rand(0...@@possible_names.length)
    @name = @@possible_names.pop(next_index)
  end
end
```

**This is Ruby!  There must be a better way!**

### The Final Solution

As it turns out, there is.  My fundamental idea of working from a pre-built list was the right idea, but I wasn't *letting Ruby work for me enough*.  There were a lot of things I could improve upon.

First, the building of the list of names.  I forgot how *awesome* ranges in Ruby are.

```ruby
@@names = 'AA000'..'ZZ999'
```

That's right.  Ruby knows how to increment each character in the string (even the letters) to fill in the gaps.  I'll be honest, when this was pointed out to me by the Ruby Track Mentor after all of that work, I only cried for like 12 minutes.

Next, random access.  Rather than randomly selecting each time, why not shuffle once, up front?  *But you can't shuffle a range in Ruby!*  Not a problem!

```ruby
@@names = ('AA000'..'ZZ999').to_a.shuffle
```

This crying session only lasted 7 minutes.

Lastly, dealing with modifying this great giant list over and over.  The solution?  *Don't.*  The best way to deal with a large dataset isn't to pop off of it.  It's to let Ruby work for you and use an **Enumerator.**  This lazily yields each element.  It's similar to having a pointer point at the element you want and then moving the pointer to the next element, but way less work.

```ruby
class Robot
  POSSIBLE_NAMES = 'AA000'..'ZZ999'
    
  @@names = POSSIBLE_NAMES.to_a.shuffle.each
    
  def self.forget
    @@names = POSSIBLE_NAMES.to_a.shuffle.each
  end
    
  attr_reader :name
    
  def initialize
    reset
  end
    
  def reset
    @name = @@names.next
  end
end
```

This way, you walk through the names until you run out.  Handily, when the `@@names` Enumerator runs out of names, a call to `@@names.next` will raise a `StopIteration` exception, telling the user that you're out of names.  If you want, you could catch that exception and raise your own `RobotNamesDepletedError` too.  And a call to `Robot.forget` renews the list of names with a new random shuffle.

What did you come up with?  Did you try the exercise in another language?  How did it turn out?  Let me know.