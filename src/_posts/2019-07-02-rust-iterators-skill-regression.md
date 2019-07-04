---
layout: page
title: Rust, Iterators, and Skill Regression
description: Some cool Rust code and how I learn code the same way my dog learns things.
tags:
 - rust
 - python
 - learning
 - iterators
cover_image: pug.jpg
---

*Cover image by Matthew Henry on Unsplash.*

Our dog training instructor taught us that a situation becomes harder for a dog to handle—based on the 3 D’s: distance from you, distraction, and duration of the activity.  As you increase any of these three D’s, those high-level skills that you’ve worked on so hard with your pet become harder, and when they become too hard to manage, they regress to an easier level of skill.  If they can’t *heel*, maybe they can handle *sit*.  And if they can’t handle sit, maybe they can handle *look at me* or, at the very least, *find the treat I’m throwing*.

This seems like about how my brain handles problems in code.  Except, instead of the 3 D’s, I have the 3 L’s: language, logic, and level of focus.  If I’m working in a language I’m super comfortable in, the logic of what I’m trying to do is straightforward, and I’ve had adequate food/sleep/coffee/quiet/non-anxiety, I’m pretty proud of the fact that I can come up with some pretty, readable, idiomatic code.  However, when working in a language I’m not as familiar with, the logic of something is a little more complex, or I’m beyond the point of focus no-return, I regress to simpler, easier to process skills.

Wired:

```python
return [value*2 for value in values]
```

Tired:

```python
result = []
for value in values:
    result.append(value * 2)
```

Fired:

```python
result = []
for i in range(len(values)):
    result.append(values[i] * 2)
```

And that’s usually how the progression goes:

1. Do I know a slick language-specific trick/builtin/standard library module that could solve my problem succinctly and clearly?
2. Do I know a 3rd party library that can do what I want (and am I OK with the cost of importing/installing/using that library)?
3. Fine.  We’ll do it the hard way.  I’ll just for-loop through all the values.
4. OK, that’s not working or too complicated.  I’ll add some more helper variables and make my loop more verbose, but simpler on each line.
5. OK, you know what?  Screw it.  I’m going nuclear and resorting to integer indexing.

Invariably, as I wallow further and further from my comfort zone, I end up looping over collections by indices.  Why?  Because it’s usually pretty much consistent behavior in all languages, it works, and it’s not *that* bug-prone and hard to read (or, at least, that’s what I convince myself when I’m in this deep, dark place).

So, that’s why, anytime I can find my way back *up* the ladder, it feels really good and means I’m learning something good.  That happened to me yesterday.  Here’s the problem I was trying to solve (a smaller sub-problem in the main problem):

> Decide whether or not a string has a set of double-letters (e.g. ll, rr, aa, ee).

Seems simple enough.  I just want to compare each consecutive pair!  But I was a little tired, and I was working in Rust, which I’m still learning the ins and outs of—especially in terms of writing idiomatic code.  I started right at the bottom of the ladder… indices:

```rust
fn has_double(s: &str) -> bool {
    for i in 0..s.len() {
        if i == s.len() - 1 {
            return false;
        }
        if s[i] == s[i + 1] {
            return true;
        }
    }

    false
}
```

**Not pretty.**  I know.  Also, it doesn’t work.

That’s right!  Due to the fact that Rust handles strings responsibly, it’s unfortunately and frustratingly hard to index to a single character in the middle of a raw string.  For UTF-8/ASCII/encoding reasons.  This is actually a good and responsible thing.  But it means my code doesn’t work.

And then, as careened around my search engine, opening tabs left and right, searching for some sort of an answer, something showed up on an otherwise unrelated thread that made everything clearer like someone had lifted a curtain: iterators.

And my Python brain fired and connected to my dumb little Rust brain (with maybe a little help from my existing-but-out-of-shape Ruby brain) and the gears meshed, and I came up with:

```rust
fn has_double(s: &str) -> bool {
    s.chars().zip(s.chars().skip(1))
        .any(|(a, b)| a == b)
}
```

Yes!  Anytime you can iterate on items and not indices, it’s almost always cleaner and less error prone.  In this case I’m making use of four fabulous iterator methods:

1. `chars`: Turns a string into an iterator of its characters.
2. `zip`: iterates over two or more iterators in parallel.  Almost always the right choice when trying to go through multiple collections or views of the same collection at the same time.  It stops when any collection runs out, which helps us avoid index errors and off-by-ones.
3. `skip`: skips our iterator forward one item so that it is ahead of the other one.  This, coupled with the “stop-on-shortest” behavior of `zip` gives us exactly what we need.
4. `any`: searches the iterator for any instance of a case that would cause its **lambda/anonymous function argument** to return true.  Short circuits if it finds a true, because it’s extra awesome.

So, when I run this on the string `"banana"`:

```txt
ba
an
na
an
na
# => false
```

but when I run it on `"apple"`:

```txt
ap
pp
# => true
```

and my faith is restored in humanity, myself, and that I’m actually *learning some Rust* as I’m writing this code.  I’m happy that Rust is a lot like Python in this respect.

> If you’re trying to iterate using indices, you’re probably not doing it the Rusty way.  There’s probably a better way, and it’s probably a slick combination of shwoopy iterator methods.
