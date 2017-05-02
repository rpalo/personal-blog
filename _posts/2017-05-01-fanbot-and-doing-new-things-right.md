---
title: Fanbot, and Doing New Things Right
layout: page
tags: python soft-skills
---

I came up with a project about a week ago, and before I started, I decided that, regardless of who else sees it, I wanted to do things the *right* way.  The main purpose of this post is to lay things out and get some feedback (hopefully) on things that I could do right-er.  There are a few things in particular I wanted to highlight about the project as well: the structure, the tests, using the Twitter API, and another cool Python package.  I'll try to keep it relatively short for everyone's sanity.

## Overview

The project is called [FanBot](https://github.com/rpalo/fanbot).  It's a pretty simple Python bot that runs continuously and can tweet random compliments at a target user.  Additionally, I just finished a feature that allows someone to tweet @ the bot, which prompts it to compliment the target user quasi-immediately (in addition to its standard daily compliment).  Right now the deployment isn't anything fancy, because the application is whatever the opposite of critical is.  I just set it running on a [PythonAnywhere](https://pythonanywhere.com) shell and restart it manually whenever they bounce their servers.  I know I could do more if I wanted.  In this aspect, I don't really see the need.

## The Structure

In terms of "doing things right," I made sure to setup the project from the beginning as a git repository.  It's got a LICENCE file, a .gitignore file, requirements.txt (for those who don't Python, this is similar to a Gemfile in Ruby or a package.json in JavaScript), a tests directory, and a project directory.  There is also a sample main user file, `main.py`.  I made sure my README has short but effective sections including Features, Installation and Use Instructions, Contribution suggestions, and a Code of Conduct.  I'm not sure how much I'll need to use the last two, but if I'm going to **do things right**, I'm going to **do things right**.

## The Tests

It took me a bit to get the tests all hooked up right since this is one of the first projects I was determined to do via a relaxed version of Test-Driven Development.  I went with Pytest.  Within my tests directory is an `__init__.py` file (blank) and a `test_fanbot.py` file.  As I add more functionality, I may have to break that into multiple test modules.  The nice thing about using Pytest is that I don't have to pull any shenanigans with the python path.

{% highlight python %}
from fanbot import fanbot # i.e. from .. (top level) import fanbot

class TestFanBot:
    """Tests for the FanBot class"""

    def test_example(self):
        assert 2 + 2 == 4

    # Actual tests...
{% endhighlight %}

Pytest's autodetection makes everything work, and you can use simple assertion statements.  I actually had trouble because it was significantly simpler than I thought it was supposed to be.

## Twitter API

The Twitter API is suuuuuper easy to use once you get into it.  You can find the basic instructions within the project README or by googling "twitter api python".  There are also several good Python Twitter API clients that simplify things.  I used [Tweepy](http://tweepy.readthedocs.io/en/v3.5.0/getting_started.html), and Tweepy's documentation will help you get started as well.  Once you've authenticated, you can basically ask for whatever you want.  Just be prepared for printing anything to the terminal to basically be pointless, due to the sheer volume of information.

This is the example from the Tweepy Getting Started page.
{% highlight python %}
import tweepy

auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)

api = tweepy.API(auth)

# This is the cool tech hipster way to check your twitter
public_tweets = api.home_timeline()
for tweet in public_tweets:
    print tweet.text
{% endhighlight %}

## Schedule

OK.  Last thing, I promise.  I made strong use of the `schedule` package.  It was easy to just `pip3 install schedule`.  They make it amazingly easy to write human-readable task scheduling.  Check it.

{% highlight python %}
import schedule

def bark():
    print("Woof")

schedule.every(10).minutes.do(bark)
schedule.every(4).days.at("12:15").do(bark)

while True:
    schedule.run_pending()
    time.sleep(30) # seconds

{% endhighlight %}

And like that, you get a barking terminal every ten minutes and/or 4 days around lunchtime.  SO.  EASY.  TO.  READ!  I love it.

## Wrap Up

So that's where I'm at now.  I'd like to think that I'm doing ok, but one of the downsides of being self-taught and also not having a developer job yet is the lack of a team to yell at me and show me when I'm not doing things the *right* way.  That's where my adoring fanbase comes in.  If you take a look and see where I've done something weird or bad or the harder way unnecessarily, or where I'm missing an opportunity, please let me know.  Thanks in advance!