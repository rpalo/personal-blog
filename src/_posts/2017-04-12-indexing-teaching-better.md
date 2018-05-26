---
layout: page
title: Indexing - Teaching Things Better
description: Finding an intuitive way to describe why indexing starts at 0 in Python
cover_image: indexing.png
tags: teaching python
---

I want to talk about indexing.  More importantly, I want to talk about how we are explaining indexing to new programmers.  But first, I need to lay some background.

## Background 1

Right now I'm working as an engineer, but I'm a teacher at heart.  I love taking someone through the process of learning something, finding the analogy or way of looking at a concept that really makes it click for them.  Especially in the areas of math, mechanics, and programming, where things are very predictable and there's always concrete reasoning behind each concept.  I'm a firm believer that students should never just accept what the teacher says on faith, and there should definitely be *no magic*.

## Background 2

I'm taking another JavaScript course to try and fill in the blanks that I have and see if this new teacher explains anything in a new or different way that clicks better with me.  Everything was going well until we got to the section on indexing lists.  The teacher started off by saying, "In order to get the first item out of the list, you reference it like this: `items[0]`.  You'll just have to remember that computers always start counting at zero."  To which I replied:

![NOPE](/img/nope.gif)

There's got to be a better way.  You shouldn't have to *just remember* anything.  And so, without further background sections, I present to you:

## A Better Way

I'm also going to use Python for my explanation because I like it better and I do what I want.  Let us consider the string `beans`.  Not string beans, but-- you get it.

![Diagram of a String](/img/indexing.png)

The main thing to understand is that indices don't actually fall *on* a particular item in a list or character in a string (since they are accessed the same way).  They surround the letters. *They surround the letters.*  **They surround the letters.**  One more time for the people in the back.

# Indices surround the letters.

Thus, when you try this:

{% highlight python %}
>>> fruit = "beans"
>>> fruit[1:3]
"ea"
{% endhighlight %}

You get "ea" because those are the letters *in between* the two indices you specified.  When you only specify one index, the program defaults to making the second limit the next index.

{% highlight python %}
>>> fruit[4] # Is the same as fruit[4:4+1]
"s"
{% endhighlight %}

The benefit of understanding things this way is that negative indices get a lot less confusing.

{% highlight python %}
>>> fruit[-3:-1]
"an"
{% endhighlight %}

In Python, in order to say "all the way to the very end," you just leave the index off.  This is mostly convenience and because -0 doesn't make any sense as an index (since -0 technically equals 0).
{% highlight python %}
>>> fruit[1:5]
"eans"
>>> fruit[1:]
"eans"
>>> fruit[:-1]
"bean"
{% endhighlight %}

Cool right?

## Conclusion

A good number of the 2 people that read this post will have already learned (one way or another) about indexing strings and lists.  But do you see now that there is a good reason for starting at zero and ending our for loops at `len(string) - 1`?  It's not magic.  It's not because computers are weird and count from zero because that's how their culture does it.  There's no little gremlin decreeing new ways to count inside your computer.  Now go forth and spread the logical step-by-step teaching approach!