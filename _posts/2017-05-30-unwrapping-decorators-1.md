---
title: Unwrapping Decorators, Part 1
layout: page
tags: python pythonic functional
---

# Preface

I promised in an earlier post to talk about Python decorators.  A note for the smarty-pantses reading this: there is apparently something called the Decorator Pattern.  While you can use Python "lowercase d" decorators to implement the Decorator Pattern, that is only one possible use for them.  For a longer and more detailed discussion of the naming issues here, the Type A people should read the relevant [PEP](https://www.python.org/dev/peps/pep-0318/#on-the-name-decorator).  For the rest of this post, when I say decorator, I mean the Python decorator language feature.  Now.  Onward!

# Prerequisites

I have to lay a baseline so that everybody is on the same page.  If you're comfortable with functional concepts like functions as variables, parameters, returned objects, and functions within functions -- and you don't want to hear me yammer about it -- you can [skip to the good stuff](#Decorators).

## Functions as Variables

For those of you still with me, God bless you.  If you didn't know, in the same way you assign a literal value to a variable, you can assign a function without calling it.

{% highlight python %}
>>> a = "soup"
>>> b = 4
>>> def how_much_food(food, quantity):
...     return "I've got {} {}s!".format(quantity, food)
>>> gerald = how_much_food
>>> gerald(a, b)
"I've got 4 soups!"
{% endhighlight %}

## Functions as Parameters and Return Values

Cool, right?  Now, as a direct result of that, you can pass functions around in and out of other functions, just like any other variable.

{% highlight python %}
def call_this(f):
    f()
    print("Called it!")

def call_with_three(f):
    f(3)

def woof(times=1):
    return "Woof!" * times

>>> call_this(woof)
"Woof!"
"Called it!"
>>> call_with_three(woof)
"Woof!Woof!Woof!"
{% endhighlight %}

## Defining Functions within Other Functions

You can even define functions within other functions!  This can be *super* powerful.  Which leads to one of my favorite coding puzzles of all time: make the following test pass.

`assert five(plus(three())) == 8`

{% highlight python %}
def three(operator=None):
    if operator is None:
        return 3
    else:
        return operator(3)

def five(operator):
    if operator is None:
        return 5
    else:
        return operator(5)

def plus(second_number):
    def inner(first_number):
        return first_number + second_number
    return inner

# Get it?
# five(plus(three()))
# five(plus(3)) -> def inner: return first_number + 3
# five(inner) -> inner(5) -> 5 + 3 -> 8
{% endhighlight %}

Like I said, that one's a puzzle, so if you don't get it the first time, try writing in out on paper, and doing the substitutions like a math problem.  Anyways, long story short, functions are neat little objects that you can sling around and define pretty much anywhere you could use literals.  A function doesn't get called until you slap some () on the end.  Now, the main event.

<h1 id="Decorators">Decorators</h1>

Decorators are used to wrap other functions to add separate functionality without polluting the function in question.  This helps each function retain a Single Responsibility™.  I believe in learning the crappy way to do something first, so you appreciate the beauty of the pretty way, so let's look at how we would do that...

## The Crappy Way

Imagine we have a function that barked everytime its inner function was called.  Why?  Because examples are hard.

{% highlight python %}
def pre_bark(func):
    def inner():
        print("Woof!")
        return func()
    return inner

def hello():
    print("Hello!")
{% endhighlight %}

In order to wrap `hello` in the woofing functionality, we'd have to do this:

{% highlight python %}
>>> hello = pre_bark(hello)
>>> hello()
"Woof!"
"Hello!"
{% endhighlight %}

Do you see what happens?  We replace `hello` with `inner`, which prints "Woof!" before calling the original `hello` function.  Not beautiful.  Not beautiful because you have to wrap `hello` after it is defined.  Someone could possibly glance at the function definition before calling it, blithely expecting `Hello!` but getting an unexpected `Woof!`.  The path of least surprise is usually the best one.  What if it looked more like this:

## The Pretty Way

{% highlight python %}
@pre_bark
def hello():
    print("Hello!")
{% endhighlight %}

You would be able to quickly see what the function did and that it was slightly modified by something called `pre_bark`.  Now we're talking.  And then there was evening, and there was morning -- your first decorator.  And it was good.

## But What About My Arguments?

In order to snag any arguments passed to your function, the inner function will accept those arguments in the form of *args, **kwargs.  I won't go into that now, but [this](https://stackoverflow.com/a/3394898/4100442) has a pretty good explanation if you are not familiar.  Short version: think of *args as a list of all the positional arguments passed and **kwargs as a dictionary of all of the keyword arguments passed.  That's not quite accurate, but it's close enough for government work.

{% highlight python %}
def print_them_args(func):

    def the_name_of_this_one_doesnt_matter(*args):
        print("{} called with {}".format(func.__name__, [*args]))
        return func(*args)
    return the_name_of_this_one_doesnt_matter

@print_them_args
def add(a, b):
    return a + b

>>> add(5, 8)
add called with [5, 8]
13
{% endhighlight %}

# Conclusion of Part 1

I was going to go on, because we still have to talk about passing arguments to decorators, stacking decorators, and we haven't even *begun* to cover what you can do with decorators and classes!  But then I looked at my word-count-o-meter which informed me that I was well beyond even the bravest of attention spans.  I'll finish up with the rest of this next week.  I'm sure everyone will be mashing their refresh button, anxiously waiting for the dramatic conclusion.

![Dog mashing keyboard pillow](/img/cliffhanger.gif)