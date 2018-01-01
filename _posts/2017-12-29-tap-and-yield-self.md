---
layout: page
title: Ruby 2.5 - Tap and Yield Self
Description: A description of what these methods are, how they're different, and good times to use them.
tags: ruby
cover_image: yield.jpg
---

I was reading through [the Ruby 2.5.0 release blurb](https://www.ruby-lang.org/en/news/2017/12/25/ruby-2-5-0-released/), referred from [Ben Halpern's article here](https://dev.to/ben/ruby-ruby-250-was-released-b98), and I saw that one of the new features is the `#yield_self` method.

```ruby
# This is roughly what it is
class Object
  def yield_self(*args)
    yield(self, *args)
  end
end
```

When I went to do more research, some people mentioned that it was very similar to `#tap`.  "Super!" I thought, "… what is `#tap`?"  After doing a bunch of reading and searching for the different definitions, use cases, pros, and cons, I ended up with a blog post's worth of research, so I thought I should share my thoughts and see if anybody else had anything to add.

To get you in the right mindset, both of these methods find their use cases in the area that I like to call "method pipelining".

## Method Pipelining

One of my favorite things about Ruby (and one of the things that I wish Python did as nicely as Ruby) is that, since everything is an object, *and* most functions are methods, *and* the `.` (dot) operator works on method return values, you can chain methods out in one "sentence" to your heart's content.  This is especially useful for data manipulation like transforming, reducing, mapping, etc.  Code like this is possible:

```ruby
("a".."z")
  .map(&:upcase)
  .map(&:ord)
  .select { |num| (num % 3).zero? && num.even? }
  .sum
# => 390
```

Each step passes its output to the next step in the data pipeline, allowing us to go from the range `"a".."z"` to the number `390`  in a few lines of code.  For some reason, this way of working really clicks in my head and I've noticed this style creeping into my code all the time.  Both `#tap` and `#yield_self` have their own places in this ecosystem as well.

## Tap: Unix's Tee for Ruby

At first I was very confused by the name of `#tap`.  Unlike `#select, #map, or #reduce`, the name `#tap` didn't initially provide me any clues to what it does.  After some digging, the name actually makes quite a bit more sense.  `#tap` is a way of *"tapping"* into the method pipeline without disturbing the flow.  You call `#tap` on an object, it runs whatever code you want, and it returns the original object.  Since it returns the original object, you can insert it anywhere in the pipeline without causing any errors (mostly).  Let's work with the example above.  Say you needed to do some debugging.

```ruby
("a..z")
  .map(&:upcase).tap { |letters| puts "Uppercase: #{letters}"}
  .map(&:ord).tap { |nums| puts "Ascii: #{nums}" }
  .select { |num| (num % 3).zero? && num.even? }.tap { |nums| puts "Filtered: #{nums}" }
  .sum

# Uppercase: Uppercase: ["A", "B", "C", ... "Y", "Z"]
# Ascii: [65, 66, 67, ... 89, 90]
# Filtered: [66, 72, 78, 84, 90]
# => 390
```

As you can see, adding in the `#tap` didn't affect the steps in the pipeline, and it allowed us to do some good ole `puts` debugging on each step.

Another use case is to modify the object as it goes through the pipeline — although, I will admit that I had a harder time coming up with a realistic reason that you would want to do this.

```ruby
("a".."z")
  .map(&:upcase)
  .map(&:ord)
  .tap { |nums| nums << 6666666 }  # Modifying the array of ASCII ORD numbers in place!
  .select { |num| (num % 3).zero? && num.even? }
  .sum

# => 667056
```

In either case, the main point is that `#tap` returns the object that it received (whether or not it gets modified).

## Yield Self: Expanding Your Pipelines

`#yield_self` is a little bit different, because it returns *the result of the block* instead.  Here is an example that shows what it does but is a little pointless.

```ruby
2.yield_self { |num| num * 2 }
# => 4
```

When I saw this example, my first thought was, "What is the point?  Why not just do `2 * 2`?"  Where `#yield_self` really shines is when you're dealing with functions that are "un-pipeline-able".  You can find these functions in two main places: Procs and Class Methods.

```ruby
# Procs/Lambdas must be called in front of their arguments
shout = ->(phrase) { puts phrase.upcase }
puts shout
# => #<Proc:0x00007fcfac82bf80@(irb):1 (lambda)>
# Shout must be used via .call, .(), [], or .===
shout.call("hello, dear friends")
# => "HELLO, DEAR FRIENDS"

# Same with class methods
contents = File.read("test.txt")
# => "Test contents\n"
```

What if you want to incorporate these into a pipeline somewhere?  Here comes `#yield_self` to the rescue!

```ruby
"TXT.TSET"
  .downcase
  .reverse
  .yield_self { |filename| File.read(filename) }
  .yield_self(&:shout)
# => "TEST CONTENTS\n"
```

This saves you from having to do two steps.

```ruby
contents = File.read("TXT.TSET".downcase.reverse)
shouty_results = shout.(contents)
```

It also keeps your code looking vertical and pipeline-y instead of horizontally nested.  Also, imagine if you had several class methods or procs you wanted to use!  Nested functions very quickly become hard to read.

## Wrap Up

That's what I got from my research.  `#yield_self` is brand new, so I'm sure that as we work with it more, we'll come up with the "right" and "wrong" ways of using it.  While doing research I had to slog through a billion comments like "yield_self is dumb" and "I hate the name" and "F# is better", so I very specifically am not looking for any more of that, but if you've got some other use cases or ideas for `#tap` or `#yield_self`, I'd love to hear about them.

## Other Resources

- [Bogdan Denkovych's blog post](https://bogdanvlviv.github.io/posts/ruby/new-method-kernel-yield_self-since-ruby-2_5_0.html)
- [Michał Łomnicki's blog post](https://mlomnicki.com/yield-self-in-ruby-25/)
- [This StackOverflow Answer](https://stackoverflow.com/a/47890832/4100442)
- [This Post by Augustl](http://augustl.com/blog/2008/procs_blocks_and_anonymous_functions/)

