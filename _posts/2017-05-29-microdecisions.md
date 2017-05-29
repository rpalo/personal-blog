---
layout: page
title: Microdecisions
tags: soft-skills
---
The background for this post is actually coming mostly from my mechanical engineering experience, but the more I program, the more I'm starting to see that there are a lot of similarities between designing parts and designing software.  What I want to write about today is the importance of *microdecisions*.

Scenario:  You are asked to write a function that takes in a string and replaces all of the vowels with "x".  Why?  Because the manager told you to.  It'll come in handy later.  Stop asking questions.  Here's a first cut.

{% highlight python %}
def vowels_to_x(phrase):
    """Replaces all of the vowels with 'x' and returns the new string"""
    result = ""
    for letter in phrase:
        if letter in (a, e, i, o, u, A, E, I, O, U):
            result += "x"
        else:
            result += letter
    return result
{% endhighlight %}

It's a pretty simple function with a pretty simple solution -- so simple, in fact, that most of the decisions you have to make seem insignificant.  But here's another cut, done differently.

{% highlight python %}
VOWELS = "aeiouAEIOU"

def vowels_to_x(phrase):
    """Replaces all of the vowels with 'x' and returns the new string"""
    result_list = []
    for character in phrase:
        if character in VOWELS:
            result_list.append("x")
        else:
            result_list.append(character)
    return "".join(result_list)
{% endhighlight %}

Here's some of the decision changes:

 1) Pull the vowels out into an external constant to improve readability.
 2) Shrink the vowels tuple into a string, since it is easier to read and less spread out.
 3) Build the results as a list instead of a string.  This way you don't have to recreate the result with every new letter.  This could help if the phrases end up being thousands of characters.
 4) Change the variable `letter` to `character` which is more accurate considering it could be a space or punctuation.

Here's yet one other option:

{% highlight python %}
VOWELS = "aeiouAEIOU"

def vowels_to_x(phrase):
    """Replaces all of the vowels with 'x' and returns the new string"""
    result_list = ["x" if character in VOWELS else character
                for character in phrase]
    return "".join(result_list)
{% endhighlight %}

This one is essentially the same as the one above, but it's condensed down to a list comprehension.  Arguably, this is more "pythonic," and possibly easier to read.  I'm not 1,000% sure I like this better, but it *is* an option.

So, which one do you choose?   "Does it matter?" you ask.  "It's a stupid function.  Just pick one."  Here's what I think.  

I think that the teeny tiny decisions that don't really matter are actually some of the most important ones.  If there are no reasons to choose one version over another, take the time to find a reason to pick one.  There are a couple benefits to this.  First, if anyone comes to you questioning your code, you'll have answers ready and will be able to defend your decisions.  Second, the process of reasoning through each of your decisions will help you to catch mistakes.  Lastly, if you have a reason for everything you choose, it will minimize the WTF moments of the next person to look at your code.  They'll be less likely to shout, "Why the @!$% would they do things that way!?" and more likely to calmly say, "I see why they did this.  I may disagree, but it makes sense."  

When in doubt, try to look at it from the eyes of this next person.  Try to go with the least surprising path.  You can do a lot of this with the names of your variables and functions.  Good names will help other people intuit what your design intent was, and if they can do that, they'll be more likely to sympathize with you and your choices and not immediately write you off as incompetent.  For other ideas, take a look at the ["Zen of Python"](https://www.python.org/dev/peps/pep-0020/).  There's a lot there that will help choose one thing over another when there are a lot of similar options.  

Let me know if you can think of any other simple ways to make microdecisions easier and more clearly convey design intent!

> "It's the little details that are vital.  Little things make big things happen."
> - John Wooden