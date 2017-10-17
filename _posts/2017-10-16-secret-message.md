---
layout: page
title: Secret Message
description: My solution to a coding challenge and the plot twists that ensued.  "Optimize for efficiency," they said.  "It'll be fun," they said.
tags: ruby puzzle interview performance
cover_image: secret-blob.png
---



Today I was reading through an article on Dev.to by [Ben Greenberg](http://www.bengreenberg.org/) about an interview coding challenge, and I got hooked and had to try it for myself.  I highly recommend you read [his original post](https://dev.to/benhayehudi/solving-a-job-application-code-challenge-30d) before you read this so you have some background.  That being said, for the lazy ones, let me give you...

## Some Background

The challenge is this (copied from the original post):

 > Sort the characters in the following string:
 > `abcdefghijklmnopqrstuvwxyz_`
 >
 > by the number of times the character appears in the following text (descending):
 >
 > … [String omitted for brevity]
 >
 > Now take the sorted string, and drop all the characters after (and including) the _. The remaining word is the answer.

You can find the super long string in the comments section of his post (where I asked for it 😁) if you want to try it yourself.  You should!  And share your solution!  Anyways, on with the story.

## My Solution (Part 1)

If it's not abundantly clear, I'm about to share my solution.  If you want to work it out for yourself without spoilers, go ahead and stop reading until you're done.  I won't write anymore until you're finished. 😄

Finished?  Great!  **ONWARD.**

I decided to use Ruby because Ruby is fun and great.  Initially, I just wanted to knock out the first solution I could think of -- regardless of how inefficient or slow it was -- and come back to clean it up after.

```ruby
# I stored the huge string in a separate file called
# `blob.txt` so as to not clutter my main script

blob = File.read('blob.txt')
letters = 'abcdefghijklmnopqrstuvwxyz_'.chars

def naive_message(letters, blob)
  letters
    .sort_by { |letter| blob.count(letter) }
    .reverse  # to get desc. order
    .join
    .split('_')
    .first
end

puts naive_message(letters, blob)
```

I won't spoil the answer, but let's just say that I "pray, plead, beseech, urge" you to try it on your own.  Possibly in the past tense.  I think the markdown format of the initial text blob may have skewed the number of "_" characters, causing my answer to have slightly more characters on the end than should actually be there.  UPDATE: That's totally what happened.  [Accurate text blob here](https://repl.it/MivX).

## My Solution (Part 2)

Anyways, I looked back at my solution and thought to myself, "Ryan, that doesn't look very performant.  I have to imagine that running `blob.count(letter)` for each letter is the worst case performance for this scenario (27 'letters' * n chars in the blob, looping through the whole blob for each letter).  It seems like it should be more efficient to do it the way Ben did it, which is by looping through the blob once and counting each letter along the way.  So I tried that.

```ruby
def efficient_message(letters, blob)
  # counter = {a: 0, b: 0, c: 0...}
  counter = letters.product([0]).to_h

  # run through blob once only
  blob.each_char { |c| counter[c] += 1 }

  # sort and trim off everything after _
  counter
    .sort_by(&:last)	# sort by the count
    .map(&:first)		# grab just the letter key into an array
    .reverse
    .join
    .split('_')
    .first
end
```

Not as pretty, in my opinion, but hopefully faster.  Ruby, being interpreted, is slower than most compiled langauges, so this should help.  (So I thought...)

## Comparing Performance

Was this optimization worth it?  I needed to find out.  Luckily Ruby comes with an awesome Benchmarking library built-in.  (Oh Ruby, what is there that you can't do?)

```ruby
require 'benchmark'

# ... My code above

Benchmark.bmbm do |bm|
  bm.report("Naive: ") { 1000.times { naive_message(letters, contents) } }
  bm.report("Efficient: ") { 1000.times { efficient_message(letters, contents) } }
end
```

`Benchmark` has a method called `bmbm` that runs one trial run and then a second real run.  This helps shake out any overhead performance drains from the garbage collector.  And to my horror:

```
~\desktop> ruby .\secret_word.rb
Rehearsal -----------------------------------------------
Naive:        0.047000   0.000000   0.047000 (  0.039974)
Efficient:    0.484000   0.000000   0.484000 (  0.481631)
-------------------------------------- total: 0.531000sec

                  user     system      total        real
Naive:        0.031000   0.000000   0.031000 (  0.038011)
Efficient:    0.483000   0.000000   0.483000 (  0.478715)
```

**The "Efficient" version is ~10x slower than the "Naive" version!**  Noooo!  "But, why?" you ask.  "How can this be?"  I had the same questions.

## Algorithmic Profiling

Ruby has a built-in profiler, but a short Google search told me that there was a better option: `ruby-prof`.  After a quick `gem install ruby-prof`, I was back at it again with the white vans.  (Check out the [Ruby-Prof Documentation](https://github.com/ruby-prof/ruby-prof) to learn more).

```ruby
require 'ruby-prof'

# ... The previous code

RubyProf.start
1000.times { naive_message(letters, contents) }
result = RubyProf.stop

RubyProf::FlatPrinter.new(result).print(STDOUT)

RubyProf.start
1000.times { efficient_message(letters, contents) }
result = RubyProf.stop

RubyProf::FlatPrinter.new(result).print(STDOUT)
```

I added titles below for clarity.

```
Naive:
===================
Measure Mode: wall_time
Thread ID: 3259000
Fiber ID: 20752200
Total: 0.066000
Sort by: self_time

 %self      total      self      wait     child     calls  name
 50.00      0.033     0.033     0.000     0.000    27000   String#count
 18.18      0.059     0.012     0.000     0.047     1000   Enumerable#sort_by
 10.61      0.007     0.007     0.000     0.000   136000   Integer#<=>
 10.61      0.040     0.007     0.000     0.033     1000   Array#each
  3.03      0.002     0.002     0.000     0.000     1000   Array#reverse
  3.03      0.066     0.002     0.000     0.064     1000   Object#naive_message
  1.52      0.001     0.001     0.000     0.000     1000   Array#first
  1.52      0.001     0.001     0.000     0.000     1000   Array#join
  1.52      0.001     0.001     0.000     0.000     1000   String#split
  0.00      0.066     0.000     0.000     0.066        1   Global#[No method]
  0.00      0.066     0.000     0.000     0.066        1   Integer#times

* indicates recursively called methods

Efficient:
==============
Measure Mode: wall_time
Thread ID: 3259000
Fiber ID: 20752200
Total: 0.688000
Sort by: self_time

 %self      total      self      wait     child     calls  name
 93.60      0.644     0.644     0.000     0.000     1000   String#each_char
  2.04      0.025     0.014     0.000     0.011     1000   Enumerable#sort_by
  1.16      0.008     0.008     0.000     0.000   136000   Integer#<=>
  0.58      0.005     0.004     0.000     0.001     1000   Array#map
  0.44      0.688     0.003     0.000     0.685     1000   Object#efficient_message
  0.44      0.003     0.003     0.000     0.000     1000   Array#reverse
  0.44      0.003     0.003     0.000     0.000     1000   Array#product
  0.44      0.003     0.003     0.000     0.000     1000   Array#to_h
  0.29      0.003     0.002     0.000     0.001     1000   Hash#each
  0.29      0.002     0.002     0.000     0.000     1000   String#split
  0.15      0.001     0.001     0.000     0.000    27000   Array#last
  0.15      0.001     0.001     0.000     0.000    28000   Array#first
  0.00      0.688     0.000     0.000     0.688        1   Global#[No method]
  0.00      0.000     0.000     0.000     0.000     1000   Array#join
  0.00      0.688     0.000     0.000     0.688        1   Integer#times

* indicates recursively called methods
```

From what I can tell, the `String#count` method is super-optimized, and `String#each_char` is a relatively expensive operation (it has to create an array the length of the blob!).  So, in the long run, looping through the blob string a bunch of times using the faster `String#count` ends up being more performant.  So much for going through the trouble to generate an *efficient* solution.

## Wrap Up

Anyways, I hope you're able to get your heart rate back to normal after such a roller-coaster ride.  Be sure to share your solution on [Ben's post](https://dev.to/benhayehudi/solving-a-job-application-code-challenge-30d).  Also, since this was originally a kind of interview code puzzle, if you're someone that has interviewed people, **I would love any feedback on my solution or the surrounding presentation**!  Is it similar to what you would expect from an applicant, or am I missing something important?

Thanks for reading!

