---
layout: page
title: Built-In Methods
description: A quick tip to aid in off-line coding
cover_image: method.png
tags: ruby tricks
---

This is just going to be a quick one.  Recently, I was working on something (that I will discuss in an upcoming post) on an airplane.  I was using Ruby.  Obviously I'm not going to fork out five whole dollars for the onboard internet access, so I was roughing it.  I came across an error.

{% highlight ruby %}
if line.contains? "tags: "
    # Do stuff
{% endhighlight %}

Wham.  `undefined method contains? for String.`  Darnit!  I had just gotten done programming in Python and I hadn't programmed in Ruby for a little while, so I rewrote it.

{% highlight ruby %}
if "tags: " in line
    # Do stuff
{% endhighlight %} 

NOPE.  `Unexpected keyword_in`.  Bah!  I knew there was a method here, but I couldn't for the life of me remember what it was.  My first instinct was to immediately Google the Ruby String documentation, but -- remember -- no internet.  Out of hope and despiration, with a quick prayer to the coding gods, I entered the following into the terminal:

{% highlight ruby %}
$ irb
# Typical IRB headers
>>> "Potato".methods
[:include?, :%, :*, :+, :unicode_normalize, :to_c, :unicode_normalize!, :unicode_normalized?, :count, ...
{% endhighlight %}

There!  Right at the front was what I needed.  No Googling required.  So the next time you reach for Google for a question, try asking your code first!

{% highlight ruby %}
if line.include? "tags: "
    # profit
end
{% endhighlight %}

 > In case you're interested, you can do the same thing in Python via `dir("potato")`.