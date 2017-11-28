---
layout: page
title: Thunder-Struct
description: Ruby Structs are the objects you didn't know you needed.
tags: ruby tricks design-intent struct
cover_image: thunder-struct.jpg
---



I just found out about this super handy built-in class in Ruby called a `Struct`, and I wanted to share.

## What is a Struct

 Very simply put, a `Struct` is a data object that is simulates a quick way to declare a class.  A common need in a program is to glue a bunch of related data together.  You can think of our options for that as a sort of continuum.

![Different data types and how flexible vs. how structured they are](/img/struct-continuum.png)

Let's say, for example, that you have a student grade that you want to keep track of.  You could define a class to explicitly lay out your data structure.

```ruby
class Grade
  attr_reader :assignment, :number_grade, :letter_grade
  
  def initialize(assignment, number_grade, letter_grade)
    @assignment = assignment
    @number_grade = number_grade
    @letter_grade = letter_grade
  end
end

jerrys_grade = Grade.new("Physics Quiz #3", 85, "B")
```

Or, seeing all of the typing, you could violently overreact and go in the opposite direction.

```ruby
jerrys_grade = ["Physics Quiz #3", 85, "B"]
```

For a simple data object like this where there aren't really methods to define yet, I think a lot of people's first thought is to try to be more in the middle of the spectrum.

```ruby
jerrys_grade = {
  assignment: "Physics Quiz #3",
  number_grade: 85,
  letter_grade: "B"
}
```

But there's another, even awesomer (yeah, I said it) way: the `Struct`.

```ruby
Grade = Struct.new(:assignment, :number_grade, :letter_grade)

jerrys_grade = Grade.new("Physics Quiz #3", 85, "B")
```

## What Do I Do With It?

`Structs` are cool because they give you a lot of flexibility in how you access and use the data without giving up any explicit-ness.

```ruby
jerrys_grade.assignment
# => "Physics Quiz #3"
jerrys_grade["number_grade"]
# => 85
jerrys_grade[:letter_grade]
# => "B"

# Jerry must have done some extra credit
jerrys_grade.number_grade += 10
jerrys_grade["letter_grade"] = "A"
```

They also come pre-built with some of the features that you'd have to build yourself if you used an actual `class` definition.

```ruby
# Equality
doras_grade = Grade.new("Physics Quiz #3", 95, "A")
doras_grade == jerrys_grade
# => true

# Can be enumerated
jerrys_grade.each { |datapoint| puts datapoint }
# => Physics Quiz #3
# => 95
# => A

# Or enumerated like a hash with key and value
doras_grade.each_pair { |key, value| puts "#{key}: #{value}" }
# => assignment: Physics Quiz #3
# => number_grade: 95
# => letter_grade: A

# Can be converted to an array or hash
jerrys_grade.to_a
# => ["Physics Quiz #3", 95, "A"]
doras_grade.to_h
# => {assignment: "Physics Quiz #3", number_grade: 95, letter_grade: "A"}
```

And if you need your own methods, you can add them via a block when creating them.

```ruby
Grade = Struct.new(:assignment, :number_grade) do
  def letter_grade
    case number_grade
    when (0..64)
      "F"
    when (65..69)
      "D"
    when (70..79)
      "C"
    when (80..89)
      "B"
    when (90..100)
      "A"
    else
      "WTF"
    end
  end
end
```

Neat, right?  I bet right now, you're feeling… inde-**struct**-ible?

![Waka waka!](/img/waka-waka.gif)

But now, you might have the same questions that I did once I got to this point.

## What's the Benefit?

Why would I want to use a `Struct` instead of a `Class` or a `Hash`?  When is one better than the other?  It's all a matter of what you're trying to do.  

### Static vs. Dynamic Attributes

You can't easily add attributes to a `Struct`, so in applications where your keys/attributes need to be dynamic or you don't know what they'll be ahead of time (think "word-counter"), you might be better suited with a `Hash`.  On the other hand, if you know exactly what keys you'll need, the object-based "dot access" looks nice, and having a constructor can save you a lot of time typing.  It can be a good, clean way of signaling your design intent.  A good example of having well-defined attributes is if you work with an Address.

```ruby
# This is nice and clear, and you don't have to retype the keys
# for every new address
Address = Struct.new(:street, :city, :postal_code, :country)

the_worlds_greatest_place = Address.new(
  "211 Main St.",
  "Savanna, IL",
  61074,
  "USA"
)

# This is ok, but more typing, harder to discern intent,
# and more prone to typos and misinterpretation
more_typing = {
  street: "211 Main St.",
  city: "Savanna, IL",
  postal_code: 61074,
  country: "USA"
}
```

### Less Error Prone

`Structs` tend to be more rigid, which can help protect from errors and uncaught typos.

```ruby
whoops_i_made_a_typo = {
  stroot: "211 Main St.",
  # Forgot that I commented out this one: city: "Savanna, IL",
  postal_code: 61074,
  country: "USA"
}
# And no errors get thrown
whoops_i_made_a_typo["street"] = "309 Main St."

# And if I access a key that doesn't exist
whoops_i_made_a_typo["city"]
# => nil

# But if we construct an Address with too many keys:
big_ole_error = Address.new(
  "123 Fake St.",
  "Fake, FK",
  12345,
  "USA",
  "BLARGLFLURB"
)
# => ArgumentError: Struct size differs

# And if we try to access a key that doesn't exist?
the_worlds_greatest_place["potato"]
# => NoMethodError: undefined method 'potato'
```

### They're Fast

`Structs` can also be much faster to create than hashes.

```ruby
require 'benchmark'

Benchmark.bm 10 do |bench|
  bench.report "Hash" do
    1_000_000.times do { name: "Ryan", coolness: 27 } end
  end
  
  bench.report "Struct" do
    Dev = Struct.new(:name, :coolness)
    1_000_000.times do Dev.new("Ryan", 27) end
  end
end

#                  user     system      total        real
# Hash         0.750000   0.010000   0.760000 (  0.762069)
# Struct       0.270000   0.000000   0.270000 (  0.272200)
```

### They're Compact

*And*, because they don't have all of the methods that come with `Hashes`, they end up using less memory.  This isn't a huge savings, but maybe it counts if you're working in a constrained environment or with a bazillion data points.

```ruby
require 'objspace'

Dev = Struct.new(:name, :age)
p = Dev.new("Ryan", 25)
q = { name: "Ryan", age: 25 }

puts ObjectSpace.memsize_of(p)
# => 40
puts ObjectSpace.memsize_of(q)
# => 232
```

However, if you need some of those methods, maybe you're better off with a `Hash`.

## But Don't Go Crazy

If you have a lot of methods and custom functionality, or if the object is a larger part of your application, it's probably better to stick with our good old friend, the Class.  While the upside of `Structs` is that they are quick and easy to create on the fly, that's also their downfall.  Having too many `structs`, or ones that are too large, can be hard to read and might miss out on the benefits of defining a Class the normal, idiomatic way.  Just like most things in programming, it all comes down to trade-offs.

## One Last Thing: OpenStructs

I thought I should add this in because, when I initially started researching, I thought `OpenStructs` were the same as regular `structs`.  Some StackOverflow answers can be misleading.  `OpenStructs` get created in a similar manner to regular ones, except for the fact that they're essentially anonymous.

```ruby
require 'ostruct'

me = OpenStruct.new(name: "Ryan", blog: "assert_not magic?")
```

The main difference is that you can dynamically add attributes to this kind.

```ruby
me.favorite_food = "chorizo breakfast burrito"
```

![Breakfast burritos…mmmm…](/img/struct-chorizo.jpg)

If you tried that with a regular `struct`, you'd get a `NoMethodError`.

What's the trade-off here?  You don't get to name it.  Also, OpenStructs are **outrageously slow and memory intensive** .  Check out [these benchmarks](https://stackoverflow.com/a/5440064/4100442).

## Wrap-Up

So that's it.  I thought it was a super handy tool — kind of like a `NamedTuple` in Python, but with even nicer syntax!  Now we're one trick closer to Ruby mastery!

**More Resources**:

- [Class vs. Struct](https://stackoverflow.com/questions/25873672/ruby-class-vs-struct)
- [Hash vs. Struct](https://stackoverflow.com/questions/3275594/when-to-use-struct-instead-of-hash-in-ruby)
- [OpenStruct vs. Struct](https://stackoverflow.com/questions/1177594/when-should-i-use-struct-vs-openstruct)
- [Working with Structs - Philip Brown](http://culttt.com/2015/04/15/working-with-structs-in-ruby/)

