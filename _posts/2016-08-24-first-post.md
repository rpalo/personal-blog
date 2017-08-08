---
layout: page
title: First Post
description: My first blog post ever!
tags: python django rails
cover_image: first-post.jpg
---

I want to make this first post mostly just to get through the paralysis and procrastination, so I can get these posts rolling.  That's the goal of this post.  If it's actually interesting and engaging, that's a bonus.

For the last couple of months, I've been progressing along the [OSSU](ossu.firebaseapp.com) (Open Source Society University) CS degree.  I finished up (for the most part) the first class -- Harvard's CS50, which was awesome and also how I found out about Cloud9.  I dabbled in a couple of the other courses, which I will come back to later, but then I settled on the software testing course, which is run by a couple of guys on Udacity.  It's really interesting!  Being primarily a self-taught programmer, testing is really something that gets missed in most of the tutorials and I've had to pick it up on my own from other sources.  Side note: the [Rails Tutorial](https://www.railstutorial.org/) has testing integrated into every part of every project, and it's brilliant.  Anyways.  The class isn't quite as trendy or fast-paced as CS50 was, but there is a lot of good content, and *bonus* all of the code is in Python.

The most interesting homework for this class so far is one of the ones in the Random Testing (Fuzzing) section.  They want you to simultaneously build a Sudoku Solver and a Sudoku Solver Tester.  My thoughts during the short problem introduction video:

> Oh neat!  This should be fun, and a nice little warm up.
> What's an efficient way for a computer to solve a Sudoku puzzle?
> Wait... how do I usually solve Sudokus?
> Wait......
> ..........

So, long story short, I'm still working on it.  There's the clear answer of brute force approach, using an iterative, recursive method to guess and dive deep until that guess fails until you hit on the right solution.  That seems like it should take too long.  However, my current method involves 5.3 million `for` loops, which probably isn't the best either.  I'm still grinding on it. I'll keep you posted.  You can see my current solution progress [here!](https://rpalo.github.io/sudoku)

In other news, I finished my first Django project.  This is a big deal because this is not the first or second or even eighth Django project I have started.  It's the first one that I have gotten over the initial hump of setup and remembering how things work and actually pushed through until I have a meaningful application that actually has data and does something.  More on that in the next post!  Hopefully between then and now, I'll have time to clean it up a little.  Current progress at [here!](https://rpalo.github.io/pq-portal)