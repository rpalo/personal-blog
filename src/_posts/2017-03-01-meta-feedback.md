---
layout: page
title: Meta Feedback
description: Wherin I cry like a little baby because the bad man was mean to me
cover_image: feedback.jpg
tags: soft-skills
---

## The Intro

If you don't know about [Exercism](https://exercism.io), you should.  To clarify, I definitely mean Ex**e**rcism as in "exercise" and not Ex**o**rcism as in "Satan come out!"  It's a website/service that is currently free and provides a set of exercises in a *ton* of languages.  The cool thing is that these exercises are all provided in the "Test-Driven Development" model, so it forces you to practice good habits.  All you have to do is install a command line client and you are off to the races.  `$ exercism fetch ruby` from within whichever directory you want your files to go.  It will see what the current puzzle you are on is and make sure you have the most updated version.  These puzzles come with a readme that explains the ideas and a `puzzlename_test.rb` (or equivalent in your language of choice) file containing the unit tests.  All you have to do is run the tests, see where they break, and code until the tests pass.  Once all the tests pass, you can `$ exercism submit puzzlename.rb` and it pushes the code to the Exercism website.  Once your puzzle is submitted, other users can comment on your code and provide feedback.  There's even an automated feedback bot that will check in every so often!  It's really neat.  OK, intro over.

## The Code

The point of this article is that I received some feedback on some code that, while quite valid, was maybe handled a bit poorly, and had the opposite effect of what I think the service is trying to provide.  I'll show you and you can judge for yourself.  Here's the code.

{% highlight python %}
import re

def hey(what):
	"""Sassy teenager.  If question: replies 'Sure.'
						If exclamation and all caps: replies 'Whoa, chill out!'
						If blank: replies 'Fine. Be that way!'
						Otherwise: replies 'Whatever.'"""

	# Get rid of extra whitespace
	entry = what.strip()

	# If you say nothing, return Fine.
	if len(entry) == 0:
		return "Fine. Be that way!"
	# If you use all caps and at least one letter, return Whoa
	elif entry.upper() == entry and len(re.findall("[a-zA-Z]", entry)) > 0:
		return "Whoa, chill out!"
	# if you end in a question mark, return Sure.
	elif entry[-1] == "?":
		return "Sure."
	# otherwise return Whatever
	else:
		return "Whatever."
{% endhighlight %}

The idea of the puzzle was to make a function that responded to conversation in various ways.  As you can see, There are definitely places to improve.

## The Feedback

Here's the feedback I received from one user.

> The only useful comment is in line 16. The rest are just telling obvious things about trivial code. Line 22 is especially bad.

Let me start by saying that this is totally valid.  I agree!  With a caveat.  If I was presenting this code at a contest, or a job interview, or professionally for code review, I would expect nothing less.  I also appreciate the effort.  This stranger took time out of his/her free time to go online and give me feedback to make me a better programmer, and that is valuable.  I do, however, think that this user forgot one important thing: context.

## The Context

Context is really, really important for any interaction with other people.  As I mentioned before, in a professional setting, where the feedback giver has a working relationship with the receiver, this feedback is probably par for the course.  That being said, Exercism is a site dedicated to learning and practice.  It has many features geared specifically to making a welcoming and patient atmosphere for new coders, helping to get them up to speed by exposing them to more experienced coders.  Also, it is likely that most users don't have a personal relationship with the other users.  In this context, I believe that the feedback provided could have been formulated to align more closely with these guiding principles.  Instead of encouraging growth, learning, and cooperation, it comes off as dismissive and "you should know better, why would you waste our time"-ish.

## The Conclusion

In the end, I'm a big boy.  If I get feedback in any form, I'll pull the usefulness out of it and shake the rest off (with only minimal crying and sniffles, and maybe a blog post).  I just thought it would be good to remind folks to consider the context of their comments, give people the benefit of the doubt, and try to work with them to increase their skill and confidence.  Graceless criticism without explanation or suggestion for improvement only really makes the critic feel good.