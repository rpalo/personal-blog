---
layout: page
title: Optimal Primes
description: Coming up with a more efficient prime factors algorithm
cover_image: optimus.jpg
tags: algorithms python puzzle
---
If you like math, *and* you're learning how to program, I see absolutely no reason why you should not know about [Project Euler](https://projecteuler.net).  "Project Yooler?!" you ask incredulously.  "What outlandish nonsense is this?"  You're in for a treat.  It's an archive of puzzles that are math-based and generally not solvable by hand.  There's not a whole lot to it.  It asks a question like 'what is the 10001st prime number?' and you can submit your answer.  Once you get the answer correct, you get access to the question's forum, where you can discuss answers and see other people's solutions.

The reason I bring this up is because I was working on a few of the problems today and I had what I thought were some reasonably efficient solutions that used some not-your-every-day tricks.  I'll just show you what I mean.  **WARNING: SPOILER ALERT!**  Here's the first question:

> The prime factors of 13195 are 5, 7, 13, and 29.  What is the largest prime factor of 600851475143?

Let's talk about some options.  First, it's always best to think about the simplest, most naive solution.  We could list every number from 1 to 600851475143 and check if that number is both prime and a factor in our number.  Of course, that would require us to figure out if each number is prime, and that could require (again, in the most naive solution) looping from 2 through to whatever the current number was to see if any number in between divided evenly.  If not, then it's prime and we win.  This sounds like it could be *at least* O(n^2) in complexity.  

> For those that aren't familiar with Big-O notation, that's a topic for another time, but right now the important thing is that if we double the size of the number we're getting the largest prime factor of, the calculation time goes up by roughly 4x.  Triple is 9x, etc.  Not going to work for us.

Here's my solution:

{% highlight python %}
def largest_prime_factor(number):
    """Returns largest prime factor of a number."""
    # Start at 2 and walk upward.
    # The first number to divide into our number 
    # evenly has to be prime (I think).

    for i in range(2, number):
        if number % i == 0:

            # If we find a number, divide that out.
            # We've pulled out a factor.  Start the process over,
            # Nibbling away at the remaining factors until
            # only one remains.  This would be the largest prime!

            new_number = number//i

            # This is the fun part.  Recursive solution!
            return largest_prime_factor(new_number)

    # This is the implicit base case, when no number divides evenly,
    # we have found the last prime factor.  Cool, right??
    return number
{% endhighlight %}

If you thought that was cool, hold on to your knickers!  The next one builds on these concepts.

> 2520 is the smallest number that can be divided by all numbers between 1 and 10 (inclusive).  What is the smallest positive integer that can be evenly divided by all numbers between 1 and 20 (also inclusive)?

OK.  What are your first thoughts?  Here are mine.  My first snap intuition is to just multiply all of the numbers together.  Ah, but 10 already works if a number is divisible by 2 and 5.  We've got some repeating that is driving our final product up.  I guess we need to see how many prime factors are *really* required.  One other thought worth mentioning is again the naive solution.  Start at 21 and continue searching upward (`if i % 2 == 0, if i % 3 == 0, if i % 4 == 0`) until we find the answer.  I'm going to see if I can do better though, because there's no upper limit guarantee on that and I hate to leave a while loop to just run wild.  Here's my solution, which I will then explain.

{% highlight python %}
# First I'm going to need some help from the standard library
from collections import Counter
from functools import reduce

# I'll also need this helper function to get the
# prime factors of each number.
def prime_factors(number):
    """Returns a list of the prime factors of a number"""

    # You'll note that this solution looks eerily similar to the
    # previous section
    for i in range(2, number+1):
        if number % i == 0:

            # The only difference is that this time I want to hang
            # on to each of the values, so I'm using a GENERATOR!
            yield i

            # I'm also using the brand spanking new (ish)
            # yield from keyword which allows my GENERATOR to
            # delegate yielding to another GENERATOR
            # or, in this case, the same one on the next recursion!
            yield from prime_factors(number//i)

            # I use a break statement to simulate the multiple level
            # jump out that the return statement gave me.
            break

# Just for clarity, here's an example of the above function:
# prime_factors(24) => <Generator> [2, 2, 2, 3]

# Now the real meat of the problem.
def smallest_common_multiple(numbers):
    """Takes a set of numbers and returns smallest common multiple"""

    # I could do everything with a plain dictionary, but this will
    # speed up everything I want.  Counters also have some shwoopy
    # Binary operator capabilities.
    primes = Counter()
    # Start with a number.
    for number in numbers:
        # See if we have enough primes to make it
        # If not, add the missing primes
        these_primes = Counter(prime_factors(number))
        # if number was 12, this line would return {2: 2, 3: 1}
        # This is the required number of each prime to make up 12.

        # Fancy binary operator action.  Equivalent to doing this:
        # primes = max(primes, these_primes) for each key in primes.
        primes = primes | these_primes
        # Thus, if primes was currently {2: 1, 3: 1}, and we needed another
        # 2 to make 12, primes[2] would be updated to be 2: 2.
        # primes[3] would be left at 1.

    # Multiply all primes to get the smallest possible multiple!
    # Using a little functional programming instead of a multiline for loop.
    # The following line is the multiplication analog to sum().
    # primes.elements() spits out list of 'key' repeated 'value' times.
    # e.g. {2: 2, 3: 1} becomes [2, 2, 3].
    return reduce(lambda x, y: x*y, primes.elements())

{% endhighlight %}

Anyways, I thought these were some neat solutions.  I mean, come on!  Recursive delegating generators!  The drama!  The flair!  Anyways, if you can come up with a better way to do it, let me know at hello@assertnotmagic.com.  See you next time!