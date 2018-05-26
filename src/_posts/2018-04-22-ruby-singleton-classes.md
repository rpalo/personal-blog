---
layout: page
title: Ruby Concepts - Singleton Classes
description: An indepth user's guide to Ruby Singleton Classes for newbies.
tags: ruby singleton basics
cover_image: singleton.jpg
---

*Cover Image credit: [Samier Saeed](https://www.sitepoint.com/author/ssaeed/) and [SitePoint](https://www.sitepoint.com/javascript-design-patterns-singleton/).*

Have you ever wondered what a "singleton class" is?  Have you ever been talking to someone or reading a blog post and "singleton class" or "singleton method" got used, and you just smile and nod, making a mental note to look it up later?  Now is your time.  Now is your moment.  I'm hoping to explain this concept in more intuitive language and show you how handy it can be.

Side note: a lot of this information came from reading [The Well-Grounded Rubyist](https://amzn.to/2K7hneD) by [David A. Black](http://www.davidablack.net/).  This book has a ton of great information and is currently one of my favorite books on Ruby.

## The Code

If you've written much Ruby, you've used these "singleton classes" already without knowing it!  First, I'll show you the code that you've probably already written, so you have some context.

```ruby
class Config
  def self.from_file(filename)
    Config.new(YAML.load_file(filename))
  end
end

dev_config = Config.from_file("config.dev.yaml")
# => Config object with dev settings
```

You may have also seen it like this:

```ruby
module Geometry
  class << self
    def rect_area(length, width)
      length * width
    end
  end
end

Geometry.rect_area(4, 5)
# => 20
```

Up until now, you've probably referred to these as "class methods."  You are mostly right.  But why do they work?  What's happening here?

## Individualization

This is a concept that is central to what makes Ruby so awesome.  Individual objects, even of the same class, are different from each other, and they can have different methods defined on them.  I'm going to shamelessly use our pets to aid in this example.

```ruby
class Pet
  def smolder
    "Generic cute pet smolder"
  end
end

succulent = Pet.new
momo = Pet.new
willy = Pet.new

def momo.smolder
  "sassy cat smolder"
end

def willy.smolder
  "well-meaning dingus smolder"
end
```

Now, when we call `smolder` on `succulent`, which we haven't changed, things go as planned.

```ruby
succulent.smolder
# => Generic cute pet smolder"
```

![Our succulent](/img/singleton-succulent.jpg)

But when we call `smolder` on `willy` or `momo`, something different happens!

```ruby
momo.smolder
# => "sassy cat smolder"
```

![Momo is our cat](/img/singleton-momo.jpg)

```ruby
willy.smolder
# => "well-meaning dingus smolder"
```

![Willy is our dog](/img/singleton-willy.jpg)

So, how does this work?  Did we re-define `smolder` for each pet?  Do me a favor and check out the output of the following:

```ruby
succulent.singleton_methods
# => []
momo.singleton_methods
# => [:smolder]
willy.singleton_methods
# => [:smolder]
```

That's right!  You're using a **singleton method**!  Now, I think, we're ready to talk about what a **singleton class** is.

## What is a Singleton Class?

First, a more general programming, less Ruby-specific question: what is a singleton?  While there are various definitions that might be more specific for different cases, at its core, a **singleton** is just something that there is only one of.  It is the only one of its kind.

What does that mean in the context of Ruby?  Here it is: when you instantiate an object from a class in Ruby, it knows about the methods that its class gives it.  It also knows how to look up all of the ancestors to its class.  That's why inheritance works.  

>  "Oh, my class doesn't have that method?  Let's check its parent class.  And that class's parent class.  Etc."

One of the cool things about Ruby is that the ancestry chain is very unambiguous by design.  There is a specific set of rules by which objects search their ancestors, such that there is never any doubt which method gets called.

In addition to knowing about its class, each object is created with a **singleton class** that it knows about.  All the singleton class is is a kind of "ghost class" or, more simply, a bag to hold any methods that are defined *only for this particular object*.  Try this out:

```ruby
momo.singleton_class
# => #<Class:#<Pet:0x00007fea40060220>>
```

In the inheritance hierarchy, it sits invisibly, just before the objects actual class.  However, you can't see it by looking at the object's ancestors.

```ruby
momo.class.ancestors
# => [Pet, Object, Kernel, BasicObject]
```

But if we look at the ancestry tree for the *singleton class itself*:

```ruby
momo.singleton_class.ancestors
# => [#<Class:#<Pet:0x00007fea40060220>>, Pet, Object, Kernel, BasicObject]
```

You can see that it comes in right at the beginning.  Thus, when `momo` goes to look for the `smolder` method, it looks *first* in its singleton class.  Since there is a `smolder` method there, it calls that one, instead of looking further up the tree to the one defined in the `Pet` class.

## What Does This Have to Do with Class Methods?

Now is when we start to see the power of the singleton class.  Don't forget that every class is just an object of the class `Class`.  If that sentence made you start to hyperventilate, don't worry.  I'll explain.

```ruby
Pet.class
# => Class
```

And `Class` is just a class that provides some methods to every instance of it (classes) you create, just like any other class.

```ruby
Class.instance_methods(false)
# => [:new, :allocate, :superclass]
```

So, really, when you're defining "class methods" that you plan to call directly on the class, what you're actually doing is defining methods on that particular Class object — in its singleton class!

```ruby
class Pet
  def self.random
    %w{cat dog bird fish banana}.sample
  end
end

Pet.singleton_methods
# => [:random]
```

*And…* if the singleton class exists, it becomes the parent class to singleton_classes of classes that inherit from the main class.  An example should help.

```ruby
class Pet
  def self.random
    %w{cat dog bird fish banana}.sample
  end
end

class Reptile < Pet
  def self.types
    %w{lizard snake other}
  end
end

Reptile.singleton_methods
# => [:types, :random]
Reptile.singleton_class.ancestors
# => [#<Class:Reptile>, #<Class:Pet>, #<Class:Object>, #<Class:BasicObject>, Class, Module, Object, Kernel, BasicObject]
```

See how `Reptile`'s singleton class inherits from `Pet`'s singleton class, and thus the "class methods" available to `Pet` are also available to `Reptile`?

## Other Tidbits

I think so far, we've pretty much covered all of the important bits.  There are, however, a couple more interesting details that I thought were cool that are sort of tangentially related: the somewhat hard to decipher `class << self` syntax, the different ways of creating class methods, and the use of `extend`.  Feel free to read on if you're interested.

### `Class << self`

There are actually two ways to use the `class` keyword: directly followed by a constant (a la `class Gelato`), or followed by the "shovel operator" and an object (a la `class << momo`).  You already know about the first one — it's the way you usually declare a class!  Let's focus on the second one, which is the syntax to directly open up an object's singleton class.  You can think about it as essentially the same as defining methods like we were doing above.

What I mean is this:

```ruby
# This:
def momo.snug
  "*snug*"
end

# is the same (pretty much) as this:
class << momo
  def snug
    "*snug*"
  end
end
```

You do this all the time when you re-open regular classes to add more functionality.

```ruby
class Gelato
  attr_reader :solidity

  def initialize
    @solidity = 100
  end

  def melt
    @solidity -= 10
  end
end

# And re-open it to add one more method

class Gelato
  def refreeze
    @solidity = 100
  end
end

dessert = Gelato.new
5.times { dessert.melt }
dessert.solidity
# => 50
dessert.refreeze
# => 100
```

The syntax `class << object; end` is just another way of re-opening the object's singleton class.  The benefit here is that you can define constants and multiple methods all at once instead of one at a time.

```ruby
# Instead of:
def momo.pounce
  "pounce!"
end

def momo.hiss
  "HISS"
end

def momo.lives
  9
end

# We can do
class << momo
  def pounce
    "pounce!"
  end

  def hiss
    "HISS"
  end

  def lives
    9
  end
end

momo.singleton_methods
# => [:pounce, :hiss, :lives, :smolder]
```

It's a common pattern when adding multiple class methods to a class to see the following:

```ruby
class Pet
  class << self
    def random
      %w{cat dog bird fish banana}.sample
    end
  end
end

# Which, since "self" is inside of the class
# declaration, means that 'self == Pet', so you could
# also do this:

class Pet
  class << Pet
    def random
      # ...
    end
  end
end
```

Maybe you've seen this pattern and not known what it is, or maybe you knew it adds class methods but didn't know what why.  Now you know!  It's all thanks to the singleton class!

## `class << self` vs `def self.method` vs `def Pet.method`

There are a few different ways to declare class methods.

```ruby
# 1. In global scope
def Pet.random
  %w{cat dog bird fish banana}.sample
end

# 2. Inside the class definition, using 'self'
class Pet
  def self.random
    %w{cat dog bird fish banana}.sample
  end
end

# 3. Inside the class definition, using the shovel
class Pet
  class << self
    def random
      %w{cat dog bird fish banana}.sample
    end
  end
end

# 4. Outside the class definition, using the shovel
class << Pet
  def random
    %w{cat dog bird fish banana}.sample
  end
end
```

So what's the difference??  When do you use one or the other?

The good news is that they're all basically the same.  You can use whichever one makes you the happiest and matches the style of your codebase.  The only difference is with #3, and how it deals with constants and scope.

```ruby
MAX_PETS = 3

def Pet.outer_max_pets
  MAX_PETS
end

class Pet
  MAX_PETS = 1000

  class << self
    def inner_max_pets
      MAX_PETS
    end
  end
end

Pet.outer_max_pets
# => 3
Pet.inner_max_pets
# => 1000
```

See that the `inner_max_pets` function has access to the scope inside the `Pet` class and the constants there?  That's really the only difference.  Feel free to carry on using your favorite syntax with confidence.

## Using Extend to Safely Modify Built-In Classes

Hopefully, at some point, you've read a blog post or had someone warn you about the dangers of re-opening built-in Ruby classes.  Doing something like the following should be done veeeery carefully.

```ruby
class String
  def verbify
    self + "ify"
  end
end

"banana".verbify
# => "bananaify"
```

The dangers include accidentally overwriting built-in methods, having methods clash with other libraries in the same project, and generally making things not behave as expected.  The `extend` keyword can help with all of that!

### What is Extend?

The `extend` keyword is a lot like `include` in that it allows you to load functionality into your class/module from other classes/modules.  The difference, however, is that `extend` puts these methods onto the target object's singleton class.

```ruby
module Wigglable
  def wiggle
    "*shimmy*"
  end
end

willy.extend(Wiggleable)
willy.singleton_methods
# => [:wiggle, :smolder]
```

Thus, if you use `extend` inside a class definition instead of `include`, the methods will get added to the class's singleton class as class methods instead of being added to the class itself as instance methods.

```ruby
module Hissy
  def hiss
    "HISS"
  end
end

class Reptile
  extend Hissy
end

snek = Reptile.new
snek.hiss
# => Error!  Undefined method hiss for 'snek'
Reptile.hiss
# => "HISS"
```

### How Does That Help Us?

So, let's say that we really needed to have that `verbify` method on the strings we were using.  While you could create and use a subclass of `String`, another option would be to extend individual strings!

```ruby
module Verby
  def verbify
    self + "ify"
  end
end

noun = "pup"
noun.extend(Verby)
noun.verbify
# => "pupify"
```

## Cheesy Wrap Up

So remember, singletons aren't just an intimidating-sounding but not-super-complicated Ruby topic.  *You* are the *real* **singleton** — yes, you're a human, but there's nobody else quite like you.  You've got **class** and your own **methods** of doing things, and that's valuable.  And now we've just added a little more functionality to you.

```ruby
class << you
  def use_singletons_for_fun_and_profit
    # ...
  end
end
```
