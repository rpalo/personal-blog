---
layout: page
title: Using Python to Make Art with Math
description: A tutorial on generating art using the Recaman Sequence,  a surprisingly complex integer sequence built with some simple rules.
tags: math python art generative
cover_image: art-math-python.png
---

*Originally published on [Simple Programmer](https://simpleprogrammer.com/python-generative-art-math/).*

[Math](https://simpleprogrammer.com/need-learn-math-programmer/) can be intimidating.

Depending on the teacher and how it is taught, it can be an infuriating combination of inscrutable and boring.

But, there’s a beauty to math—a symmetry to the intelligence and logic behind numbers. I love math, and I want other people to love it too.

One neat way to make math more approachable and show its beauty visually is to combine it with something called “[generative art](https://en.wikipedia.org/wiki/Generative_art_).” Generative art is where you create a few, usually simple rules which are often math- or geometry-based, and then you tell a computer to process these rules.

Since computers are great for processing instructions quickly, and on a much greater scale than a human could, the designs that are created are often more complex and interesting than you might expect from such simple rules.

[This example](https://codepen.io/ashleymarkfletcher/full/eRrWZL) shows a bunch of floating particles that move with a mesmerizingly natural motion. They float around, link up with other particles, and change directions all on their own. It’s a variation on a “flocking algorithm,” and the amazing thing is that most of this natural motion comes from simply having each particle follow the rules of “don’t run into anybody,” “stay with the flock,” and “go in roughly the same direction as those near you.”

[Python](https://simpleprogrammer.com/7-reasons-why-you-should-learn-python/) is a great option for creating these generative art projects; it is used by data scientists, mathematicians, and engineers (among many others) as an open source option for processing numerical calculations and generating visualizations.

It is also extremely easy to read and write clear code, which makes it an ideal language for outlining the simple rules needed to create this generative art.

One of the simplest mathematical constructs you can create with these rules is an [integer sequence](https://en.wikipedia.org/wiki/Integer_sequence), which is an ordered list of integers (whole numbers, including: positive, negative, and zero). Usually, the relationship between these integers is spelled out in some sort of logical way with a set of rules in order to help someone figure out what the next number in the pattern is.

In this article, we are going to take the mathematics of integer sequences, supercharge them with the power of programming in Python, and use them to create some interesting and beautiful generative art.

It is a fun exercise, and the calculations and code samples are simple enough that they should be engaging for programmers, mathematicians, and artists alike.

This is not a beginner’s Python article, though, so I will assume you have some familiarity with Python’s syntax—or, at least, a willingness to pick it up as you go along—as well as how to run Python programs. If you’re not sure how to run them, and you’d like to write code in an application with a big giant “Play” button, the [Mu text editor](https://codewith.mu/) is great for beginners.

The particular sequence I want to talk about this time is the **Recamán sequence**. The rules are deceptively simple, but when the numbers are given visual or auditory shape, the results can be interesting and even a little spooky.

## The Recamán Sequence

Here are the rules:

 1. Start at zero.
 2. Every step you take will be 1 bigger than the last step you took.
 3. If it’s possible to step backward (negatively), do so. Otherwise step forward.
 4. Backward steps are only allowed if the resulting location is positive (greater than zero) and if we’ve never been to that number before.

Let’s do the first few as examples.

We start at zero.

- 0

The next step size will be 1. Stepping backward would put us at -1, which is not allowed, so we’ll step forward.

- 0 -> 1

The next step size is 2. Stepping backward would put us at -1. That’s still not allowed, so forward we must go.

- 0 -> 1 -> 3

The next step size is 3. Stepping backward puts us at 0. Since we’ve already been to 0 (our first starting point), this is not a valid move. I promise the sequence gets interesting soon, but for now, we step forward.

- 0 -> 1 -> 3 -> 6

The next step size is 4. Stepping backward lands us at 2. Since 2 is positive, and we haven’t seen it yet, we can take our first legitimate backward step!

- 0 -> 1 -> 3 -> 6 -> 2

Hopefully you’re beginning to see how the rules work. Now, this is kind of interesting to think about, but I’m not sure I would call a list of five numbers beautiful. That’s where we’ll lean a little bit harder on art and code. Luckily Python provides both of these to us in a fun and adorable module in its Standard Library: **Turtle**.

## Introducing Turtle Graphics

Turtle Graphics was originally a [key feature of the Logo programming language](https://en.wikipedia.org/wiki/Turtle_graphics).

It’s a relatively simple Domain-Specific Language (DSL) where there is an avatar—traditionally shaped like a little turtle—on the screen, and you give it instructions on where to go: forward, left, or right. As it moves, it draws a line wherever it goes with its tail, although you can tell it to pick its tail up or put it down as necessary. It can even jump positions and change colors!

Python also includes a “turtle” library packaged along with it in its standard library. Let’s take a look at a sample program to see how it works. Create a file called “example1.py” with the following contents.

```python
import turtle

window = turtle.Screen()
joe = turtle.Turtle()

joe.forward(50)
joe.left(90)
joe.forward(100)

turtle.done()
```

Here are the important bits:

- On line 1, we import the “turtle” module. This will have many of the functions that we’re going to use, and we couldn’t use them unless we imported the module first. We’ll use these functions by writing “turtle.function_name,” as you’ll see.
- On line 3, we create a Window. This is the window that will pop up when you run your code. It holds all of the stuff we’re going to be drawing.
- On line 4, we actually create our Turtle. We are going to call him “joe” and store him in a variable so that we can give him commands later.
- Lines 6-8 are us giving “joe” commands. You see the “dot” syntax that should be getting pretty familiar.
- Line 10 just keeps the window from closing when “joe” is done with his drawing.

If you run your code, you should see something like the following:

![Our first turtle example.  He goes straight and turns left.](/img/turtle-1.png)

*Side note: If you want the real, old-fashioned Logo experience, you can add “joe.shape(“turtle”)” to your code, right under the line where you define “joe.” Isn’t he cute?*

Okay, now that you’ve seen what “turtle” is all about, let’s get back to the sequence we were working on.

## Coding the Sequence

Like anything good, we’re definitely not going to get a perfect result on the first go. We’ll need to do some iteration. I’ll take you through three passes at this art project, and each one will get a little more complicated and a little more visually interesting. After that, I have some potential ideas for further iteration that you can try if this gets your creative spark going. Let’s get to it!

### First Try

The code that we write will be very similar to the English we would use to describe the steps for the sequence. Remember the two rules: Go backward when possible, otherwise go forward, and increase the step size by one after each step.

Create a new file named “recaman1.py.” We’ll start with those basic rules and then figure out how to make it actually work. I’m naming our new turtle Euler, after [some guy](https://en.wikipedia.org/wiki/Leonhard_Euler).

```python
import turtle

window = turtle.Screen()
euler = turtle.Turtle()  # A good mathy name for our turtle
euler.shape("turtle")

current = 0   # Here's how we know where we are
seen = set()  # Here's where we'll keep track of where we've been

# Step increases by 1 each time
for step_size in range(1, 100):
    
    backwards = current - step_size
    
    # Step backwards if its positive and we've never been there before
    if backwards > 0 and backwards not in seen:
        euler.backward(step_size)
        current = backwards
        seen.add(current)
        
    # Otherwise, go forwards
    else:
        euler.forward(step_size)
        current += step_size
        seen.add(current)
        
turtle.done()
```

However, when we run it, it doesn’t look very good. In fact, it looks like maybe somebody gave Euler too much coffee.

![Our turtle runs back and forth along a line.](/img/recaman1-results.png)

### Second Try

So, that was pretty reasonable. The code seems to read just like we might explain it to someone, which is good.

I’m afraid that the linear motion is just a little boring, though. This is when we want to put our artists’ caps on (do artists wear caps?) and figure out a little more creative way to get Euler from point A to point B.

Luckily turtles don’t have to move in straight lines! They can also move in arcs and circles. Let’s have him bounce from spot to spot on the number line! To make a turtle draw a circle or partial arc, we’ll use the “circle” command, which causes the turtle to follow a circle where the imaginary center is “radius” units to the turtle’s left.

That means we’ll have to orient our turtle before drawing, depending on whether he’s going forward or backward, using the “setheading” command.

Remember that you can find all the turtle commands [in the official documentation](https://docs.python.org/3.3/library/turtle.html?highlight=turtle#turtle-methods), just in case you’re curious.

```python
import turtle

window = turtle.Screen()
euler = turtle.Turtle()  # A good mathy name for our turtle
euler.shape("turtle")

current = 0   # Here's how we know where we are
seen = set()  # Here's where we'll keep track of where we've been

# Step increases by 1 each time
for step_size in range(1, 100):
    
    backwards = current - step_size
    
    # Step backwards if its positive and we've never been there before
    if backwards > 0 and backwards not in seen:
        euler.setheading(90) # 90 degrees is pointing straight up
        euler.circle(step_size/2, 180)  # 180 degrees means "draw a semicircle"
        current = backwards
        seen.add(current)
        
    # Otherwise, go forwards
    else:
        euler.setheading(270)  # 270 degrees is straight down
        euler.circle(step_size/2, 180)
        current += step_size
        seen.add(current)
        
turtle.done()
```

![Our second attempt.  Our turtle spirals around the canvas, but the picture is tiny.](/img/recaman2-results.png)

That’s neat, but for the first little while, it seems like he just wiggles around in one place and the lines are very close together. Also, he’s not going to be using the whole left half of the screen!

Let’s do one more iteration together, where we make it even nicer to look at.

### Third Try

The goals for this iteration are to make the picture bigger, and to give him more room to work.

```python
import turtle

window = turtle.Screen()
window.setup(width=800, height=600, startx=10, starty=0.5)
euler = turtle.Turtle()  # A good mathy name for our turtle
euler.shape("turtle")
scale = 5  # This isn't a turtle module setting.  This is just for us.

# Move the little buddy over to the left side to give him more room to work
euler.penup()
euler.setpos(-390, 0)
euler.pendown()

current = 0   # Here's how we know where we are
seen = set()  # Here's where we'll keep track of where we've been

# Step increases by 1 each time
for step_size in range(1, 100):

    backwards = current - step_size

    # Step backwards if its positive and we've never been there before
    if backwards > 0 and backwards not in seen:
        euler.setheading(90)  # 90 degrees is pointing straight up
        # 180 degrees means "draw a semicircle"
        euler.circle(scale * step_size/2, 180)
        current = backwards
        seen.add(current)

    # Otherwise, go forwards
    else:
        euler.setheading(270)  # 270 degrees is straight down
        euler.circle(scale * step_size/2, 180)
        current += step_size
        seen.add(current)

turtle.done()
```

As you can see, we’ve added a scaling factor which you can tune to whatever you think works best. I arrived at this value by trying a couple and picking my favorite. We also shifted him over so he starts at the left side of the screen. Since he can never go negative, we know he will only go right from wherever he starts.

![Our turtle spirals in beautiful, large, interesting circles.](/img/recaman3-results.png)

### Further Tweaking

By now, I think you get the gist, and you’re hopefully starting to see the magic of integer sequences: out of a few simple rules (and with the help of a tireless reptile assistant), you can make some truly interesting and captivating results.

You’ve got all the tools you need to do something even cooler. Here are some ideas to get your creative juices flowing:

- What if you change the color of the lines? What if you change it continuously?
- What if you skew the drawing to an angle to take up more of the screen?
- What if you have multiple turtles drawing sequences in tandem?
- What if you vary the predictable sequence with a little bit of randomness?
- What if you incorporate user input (mouse clicks, key presses, etc.) to affect how the turtles behave?
- What if you make a turtle that draws but is driven by something really slow, like the cycle of the moon?
- Is there a way you could incorporate a turtle with an IoT project or a web application?

## Other Incarnations of the Sequence

If you found the Recamán sequence *particularly* fascinating, you’re not alone. There are a ton of different incarnations out there people have created, combining the lines with color, sound, and more. Here are a few of my favorite.

This slightly spooky version with sound:

<iframe width="560" height="315" src="https://www.youtube.com/embed/ebvW-sqL5yY" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

This Numberphile video about the sequence is really interesting:

<iframe width="560" height="315" src="https://www.youtube.com/embed/FGC5TdIiT9U" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

The Coding Train also did a couple videos on coding this up if you want a cool video walkthrough with an amazing teacher and don’t mind writing JavaScript:

<iframe width="560" height="315" src="https://www.youtube.com/embed/DhFZfzOvNTU" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

In fact, [P5.js](https://p5js.org/) (and its Java-based predecessor, [Processing](https://processing.org/)) are both great alternatives for making art and animations with code; they come with dedicated editors to help you do that, and they allow support for sound and other add-ins!

## Get Your Turtles in Gear

Hopefully this tutorial was enough to spark your interest in using code to generate art, and hopefully (if you were before), you are no longer too intimidated to look to mathematics as a source for your artistic ideas.

Geometry, never-ending constants, golden ratios, Fibonacci spirals, fractals, and number theory are all goldmines of awesome visual projects just waiting to be programmatically generated, and now you have all the tools you need to get your own set of turtles and start generating!