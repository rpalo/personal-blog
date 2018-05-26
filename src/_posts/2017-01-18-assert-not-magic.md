---
layout: page
title: Assert Not Magic
description: Programming isn't magic.  It's logical, learnable, and you can do it too.
cover_image: logo.png
tags: not-magic soft-skills
---

First post on the new layout with the new domain name!  Woo!  I'd like to take a minute to explain the significance behind the name.  See, my criteria for selecting a good name came down to two things.  I wanted it to be significant in my life -- something that reflected my experience and point of view, and something that is somewhat of a theme in my life.  The second thing is that it had to be a <del>domain name that was available</del> unique name.

So, "assert_not magic?" you say.  "What does it mean?" you say.  Well, at the most literal level, it comes from testing in Ruby.  Much like the snippet on my blog's banner, you might see something like this:

{% highlight ruby %}
def test_this_thing_that_should_be_true
    answer = 4 + 4
    assert answer == 16, "You did the math wrong, dummy"
end

# And the inverse, which is more relevant to our purposes:

def test_something_that_should_be_false
    dinner = "Mac and Cheese and Spam"
    assert_not dinner == "Yucky", "Spam is delicious you heathen."
end
{% endhighlight %}

As is hopefully clear, assert_not, as the opposite of assert, just checks to make sure something is false.  

The second part is a play on a Ruby idiom: methods that return boolean values generally end in a question mark.  Things like `list.empty?` or `number.even?` are common.

Altogether, the phrase generally means, "make sure there's no magic afoot."  And this leads to the heart of the meaning.  There *is* no magic!  (As far as you know.)  And that is a very comforting fact.  "Why?!" you ask, disappointedly.  Because, if there is no magic, then everything that happens has a distinct and find-out-able cause.  This is a mantra that has popped up in every aspect of my life.  Math classes?  No, there's no magic rules or mystery.  This equation was derived from somewhere.  There is a logic behind it and I don't have to memorize anything.  Engineering?  *This mold won't assemble right.*  That's not the end of the investigation.  There is a reason, somewhere in the design, for it not assembling right.  We just have to figure out what that is.  *The code won't run!  I've checked everything and it must just be a glitch.*  Not possible.  There's still an explainable error somewhere.  

Anyways, I just wanted to share that and explain the name of the blog.  Keep `assert_not magic?` in mind with me as I keep learning!


