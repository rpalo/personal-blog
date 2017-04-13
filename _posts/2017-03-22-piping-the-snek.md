---
layout: page
title: Piping the Snek
tags: python tricks bash
---

This is going to be just a quick one.  I discovered something the other day that I feel like I should have already known about, but it just made me so happy that I had to write it down.  Scenario: You are working in the command line.  You have a list of files you want to do some jimmy-jacking with.  A little string substitution here.  Adding/removing a file header.  It's not too complicated, but it is just complicated enough that your standard bash commands start to fail you.  You (if you are like me) begin to slowly realize with dread that you will have to go get the big guns: awk, sed, and others.  Granted, it would probably make you a better person to have a confident control of those commands.  That being said, I do not.  I'm cool with `ls, cd, pwd`.  Me and `cat and echo` are buddies.  `Grep and find` come over for dinner once a month.  Beyond that, I need a couple (ten) tabs of documentation open to get much done.  Until now.

You probably know about piping if the previous paragraph made any sense to you.  A pipe looks like this: `|`.  A pipe is the way you can pass the output of one command to the input of another.  You can do useful things such as find all of the files in the current working directory with "cheese" in their name like this: `ls | grep cheese`.  Piping is the secret to really getting big things done.  And until a little while ago, piping and Python programs were seperate in my brain.  Then I found out **you can pipe in and out of Python programs**.  Consider the following:

{% highlight python %}
# flip.py

import sys

def flip_word(word):
    """Simply takes the input string and returns the reverse."""
    return word[::-1]

if __name__ == "__main__":
    for line in sys.stdin.readlines(): # sys provides stdin that is a readable file-like object
        word = line.strip() # Each line from stdin comes with a hidden newline
        sys.stdout.write(flip_word(word)+"\n") # stdout does not add a newline like print does

{% endhighlight %}
Imagine for a moment that you have a file named foods.txt that contains:
{% highlight text %}
cheese
soup
steak
sushi
meatballs
more sushi
{% endhighlight %}
You could then do the following:
{% highlight bash %}
$ cat foods.txt | python flip.py | grep ihsus
ihsus
ihsus erom
{% endhighlight %}

And thus, if you get stuck in bash, just bang out a quick Python program and pipe to it.