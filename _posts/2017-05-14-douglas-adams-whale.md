---
title: Douglas Adams's Whale
layout: page
tags: python physics fun scientific
---

## Intro

I think it is important to find ways that your background or experience specifically help you to stand out in any given group.  If you can pinpoint those areas, the group can optimize its tool set and have a better idea of who would be best suited to a specific task.  Personally, while programming is one of my favorite pastimes, I have a degree in Mechanical Engineering and some experience teaching Calculus and Physics.  Because of this, I thought I would share some insight into an area that I know everyone has some questions about: the whale in Douglas Adams's *Hitchhiker's Guide to the Galaxy*.

What whale, you ask?  In chapter 18, two missiles get randomly transformed into a whale and a potted plant, respectively.  Here's the excerpt:

> Another thing that got forgotten was the fact that against all probability a sperm whale had suddenly been called into existence several miles above the surface of an alien planet.
> And since this is not a naturally tenable position for a whale, this poor innocent creature had very little time to come to terms with its identity as a whale before it then had to come to terms with not being a whale any more.
> This is a complete record of its thoughts from the moment it began its life till the moment it ended it.
> Ah … ! What’s happening? it thought.
> [...]
> And wow! Hey! What’s this thing suddenly coming towards me very fast? Very very fast. So big and flat and round, it needs a big wide sounding name like … ow … ound … round … ground! That’s it! That’s a good name – ground!
> I wonder if it will be friends with me?
> And the rest, after a sudden wet thud, was silence.

This excerpt leads me to ask: can we simulate it?  With a little help from Python, we can find out.  I'm going to write this assuming the reader has a working knowledge of basic programming principles and what the difference between the Imperial and Metric system are, but has very little physics background beyond that.  Although I'm generally more comfortable using Imperial units like feet and pounds, I'm going to stick to metric units this time, for the sanity of our international friends and because the math works out a little easier.

## The Forces Involved

Let's start with the forces at play here.  Basically, the only two I'm going to worry about are gravity acting on the whale and drag working against the whale as it falls.  Let's assume this whale is falling from a geosynchronus orbit (orbit in space that would allow it to keep pace as the earth rotates) -- approximately [3.5786 x 10^7 meters elevation](https://en.wikipedia.org/wiki/Geostationary_orbit).  For those that are interested, I'm going to plop the only real in-depth equation here.

![Sketch of Forces](/img/whale-sketch.jpg)

Turning the equations into code isn't super difficult.  We just need to fill in some of the variables above first.  Since getting data on an alien planet and alien whale is more difficult, let's use Earth and an Earthly Blue Whale.  The mass of the earth is roughly [5.97 x 10^24 kg](https://en.wikipedia.org/wiki/Earth), and its radius is approximately [6.37 million meters](https://en.wikipedia.org/wiki/Earth).  Blue whales live in the region between about [80-120 metric tons](https://en.wikipedia.org/wiki/Blue_whale).  To make the math nice, let's use 100 (100,000 kg).  Fun fact: the largest known dinosaur came in at around [90 metric tons](https://en.wikipedia.org/wiki/Blue_whale)!  Anyways, with these constants, and the Universal Gravitational Constant -- [6.674 x 10^-11 m^3/kg s^2](https://en.wikipedia.org/wiki/Gravitational_constant) -- let's turn this into code.

{% highlight python %}
def gravity(altitude):
    """Returns the force of gravity [N] at a given altitude [m]"""
    earth_mass = 5.972e24 # [kg]
    earth_radius = 6.367e6 # [m]
    whale_mass = 100000 # [kg]
    universal_grav_constant = 6.67384e-11 # [m^3/kg s^2]

    radius = altitude + earth_radius # [m]
    # Assumption: the 'radius' of the whale is negligible compared to
    # the other sizes involved

    # Here's the important bit:
    result = universal_grav_constant * whale_mass * earth_mass/(radius**2)
    return result
{% endhighlight %}

Drag gets a little more interesting.  Because there is a startling lack of data on the aerodynamic characteristics of belly-flopping whales, we'll assume the whale is diving towards the ground head-first.  [This article](http://jeb.biologists.org/content/jexbio/214/1/131.full.pdf) is chock-full of informational goodies, such as the drag coefficient of a swimming whale (0.05) and the approximate projected cross-sectional area (10 m^2).  The projected cross-sectional area is sort-of like the size of the shadow the whale would cast if light was shone on it head-on.

It is important to note that the density of the atmosphere decreases with elevation, but not in a nice linear fashion.  We'll need to model the following relationship in our code (approximately):

![Density Graph](/img/whale-density.gif)

In order to keep your interest, I'll do some handwaving and leave that code out.

Here is the code for drag:

{% highlight python %}
def drag(altitude, velocity):
    """Given altitude [m] and velocity [m/s], outputs the force of drag [N]"""
    whale_drag_coefficient = 0.05 # [unitless]
    whale_crossectional_area = 10 # [m^2]
    result = .5 * whale_drag_coefficient * density(altitude) # VIGOROUS HAND-WAVING!
    result *= whale_crossectional_area * velociy**2

     # Drag always is opposite of the direction of motion.
     # i.e. if whale falls down, drag is up and vice versa
    if velocity > 0:
        result *= -1
    return result
{% endhighlight %}

Great!  Two more steps before we get results.  First is to get acceleration of the whale.  Good ole' `F = m * a`.  

{% highlight python %}
def net_acceleration(altitude, velocity):
    """Sums all forces to calculate a net acceleration for next step."""
    gravity_force = gravity(altitude) # [N]
    drag_force = drag(altitude, velocity) # [N]
    net_force = drag_force - gravity_force # [N] assuming gravity is down.
    
    # Since F=ma, a = F/m!
    acceleration = net_force / WHALE_MASS # [m/s^2]
    return acceleration
{% endhighlight %}

## The Simulation

Now we need to simulate the whole fall.  We'll do this by getting each data point one by one.  If we know altitude and velocity at a given time, we can find acceleration with the function above.  In order to get the next velocity and position from a given acceleration, we'll need the following function:

{% highlight python %}
def integrate(acceleration, current_velocity, current_altitude, timestep):
    """Gets future velocity and position from a given acceleration"""
    new_velocity = current_velocity + acceleration * timestep # Sort of a y = mx + b situation
    new_altitude = current_altitude + current_velocity * timestep # Same, but for altitude
    return new_velocity, new_position 
{% endhighlight %}

This set of code is probably the least intuitive, but it basically boils down to the idea that if you go 20 miles per hour for 6 hours, you will have travelled 120 total miles (20 * 6).  Blah blah blah science handwaving.  You can see the full code and comments [here](https://github.com/rpalo/whale-drop).  I'm still working on cleaning it up and factoring out the constants.  Let's get to the whale.

## The Results

{% highlight python %}
from matplotlib import pyplot as plt
import pandas as pd

results = pd.read_csv("results.csv", header=0)
plt.plot(results["Time"], results["Height"])
plt.show()
{% endhighlight %}

![Graph of height vs time](/img/whale-height-plot.png)

Looks pretty much like we would expect.  First he was up.  Then he came down and it was fast.  So?  Let's look at the forces he felt.

{% highlight python %}
results["Force"] = results["Acceleration"] * 100000 # whale mass [kg]
plt.plot(results["Time"], results["Force"])
plt.show()
{% endhighlight %}

![Graph of force vs time](/img/whale-force-time-plot.png)

Woah!  Let's get a better look at that spike.

![Zoomed in plot of force](/img/whale-force-plot.png)

You can see he is feeling some crazy gravitational forces in the downward direction until WHAMMO!  Checking the height of the whale right around this point shows that he's where we are splitting the upper and lower Stratosphere: [~25000 m](https://www.grc.nasa.gov/WWW/K-12/airplane/atmosmet.html).  Basically, our whale is faceplanting onto our atmosphere.  Realistically, I'm pretty sure that, if our whale hadn't burned up already, we would have a localized whale-splosion and whale-shower.  

So that's it for now.  That's probably all you can stand.  For future work, I recommend evaluating the heat generated from drag and estimating the ignition point of an airborne sea mammal to find out if he disintegrates or explodes first.  Too gruesome?  Yeah, probably.  Don't worry.  He had a very exciting time on the way down.

> Never mind, hey, this is really exciting, so much to find out about, so much to look forward to, I’m quite dizzy with anticipation! - The Whale