---
layout: page
title: AI with Pacman
tags: algorithms python ai
---

I did it!  I know this post is late, but that's because I wanted to conquer this project so I could post about it.  So that's what I'm doing.  One of the courses I'm taking (of the many -- I've got a short attention span.  I'm working on it) is an AI course on edX.  So far, it's one of the most interesting courses I've taken.  It's also one of the hardest classes (including my M.E. undergrad) I've ever taken.

Let me talk about the project.  The course provided a lot of the infrastructure for the Pacman game: displaying it, running it, testing it, grading it, etc.  Part of what made the project so hard was all of the files that were included -- over 20!  I kind of imagine this is what getting a job at a tech company feels like, in micro-version.  I had to hunt through all of the files and figure out what did what and which classes got used where.  Luckily, the documentation and variable/function/class naming were on point, which made it fairly intuitive.

The main assignment was for me to build the brain for PacMan in various stages.  I'll go through my solutions, which could definitely be improved, but they worked and I got the grade, so nyeh.  I was able to accidentally abstract quite a bit out, which ended up making much of the repetitive work super easy.  The first few questions asked me to implement various search algorithms, but as it turns out, they are basically all the same with a different sorting function.  You'll see what I mean.

## Generic Search Algorithm

{% highlight python %}
def genericSearch(problem, fn):
    # Inputs are a search problem - infrastructure provided by the class
    # It has all the information about the current state, goal state, etc.
    # They also made the util module available, which contains a Priority Queue
    # which is the basis for the search.  Priority Queue is a queue that arranges by
    # a given priority value.  Popping the lowest priority value can be done in O(1).
    fringe = util.PriorityQueue()
    closed = set()

    # My main piece of information I'm passing around is a tuple.
    # (state, actions) -- state is the current game state
    # containg relevant info like pacman's location, food locations, etc.
    # Actions is what we eventually return, a list of 'N', 'S', 'E', 'W' directions
    # to follow to win.
    fringe.push((problem.getStartState(), []), 0)
    while True:
        if fringe.isEmpty():
            # Fringe should never be empty.  That's why we throw an exception
            raise Exception("Fringe was empty!")
        current = fringe.pop()
        if current[0] in closed:
            # I implemented a graph search, which doesn't expand nodes more than once for
            # efficiency's sake.
            continue
        closed.add(current[0])
        if problem.isGoalState(current[0]):
            # return the list of actions if we end up declaring victory
            return current[1]

        # Otherwise, expand this current state, evaluate priorities based on the fn
        # and add them to the fringe.
        successors = problem.getSuccessors(current[0])
        for successor in successors:
            nextOne = (successor[0], current[1] + [successor[1]])
            fringe.update(nextOne, fn(nextOne))
{% endhighlight %}

## Search Algorithms

Once that was complete, I could roll through the search algorithms fairly easily:

{% highlight python %}
def depthFirstSearch(problem):
    """Search the deepest nodes first"""
    def priorityFn(item):
        return -1 * len(item[1])    # Make sure the deepest nodes have the lowest priority
                                    # so that they are popped off the queue first
    return genericSearch(problem, priorityFn)

def breadthFirstSearch(problem):
    """Search the shallowest nodes in the search tree first."""
    def priorityFn(item):
        return len(item[1])     # Make sure the shallowest nodes have low priority
    return genericSearch(problem, priorityFn)

def uniformCostSearch(problem):
    """Search the node of least total cost first."""
    def priorityFn(item):
        return problem.getCostOfActions(item[1])
    return genericSearch(problem, priorityFn)

def aStarSearch(problem, heuristic=nullHeuristic):
    """Search the node that has the lowest combined cost and heuristic first."""
    def priorityFn(item):
        g = problem.getCostOfActions(item[1])
        h = heuristic(item[0], problem)
        return g + h
    return genericSearch(problem, priorityFn)
{% endhighlight %}

## Heuristics

The next (and harder) thing is to implement heuristics for the A* search shown above.  A heuristic is an estimate of the cost from a state to the goal state.  When using a graph search, in order to guarantee optimal solutions, the heuristic needs to be "admissible" and "consistent."  Admissible means that the heuristic never over-estimates the cost to the goal.  This is a delicate balance, though, because the larger the heuristic values, the faster the algorithm goes.  Consistency means that the cost from node to node is never less than the heuristic.  Luckily, consistency implies admissibility, and if you can get an admissible heuristic, it usually ends up being consistent.  The hard part is proving admissibility.

I used two main heuristics: a greedy Nearest Neighbor approach that worked really well but would not be admissible in certain geometries, and a really simple manhattan distance (x distance + y distance) heuristic that didn't work as good but was definitely admissible.

{% highlight python %}
def manhattanHeuristic(position, problem, info={}):
    "The Manhattan distance heuristic for a PositionSearchProblem"
    # Provided by the class
    xy1 = position
    xy2 = problem.goal
    # Add up the city grid distance you would drive from point to point
    # abs x distance + abs y distance
    return abs(xy1[0] - xy2[0]) + abs(xy1[1] - xy2[1])

def shortestDistance(start, points, fn=util.manhattanDistance, initial=0, ):
    # Inspired by stackOverflow
    if len(points) == 0:
        return initial
    # Get the point that is closest to the start point.
    # Then leapfrog to the next closest point to that one, adding up the distance.
    # Return the full distance to get the the closest point and then loop through the rest of the points
    # Recursively

    # I could have probably done something more efficient by popping off of a list rather than recreate the list each time
    shortest = min(points, key=lambda x: fn(start, x))
    return shortestDistance(shortest, [p for p in points if p != shortest], fn=fn, initial=initial + fn(start, shortest))
{% endhighlight %}

The other things were just expanding these concepts, working with problems of more than one dot, or four dots separated into the four corners, etc.  I could have gotten deeper into optimizing the shortest distance heuristic to work in all cases, but as I started to research this, I found out that that is a pretty standard CS problem without an easy solution.  I didn't want to work that hard if the Manhattan heuristic would work just fine.  My only regret is that I couldn't come up with one that automatically detected the worst-case behaviour of greedy Nearest Neighbor and regressed to the simple Manhattan heuristic.

# Fun Link Time!

I know this has been a thing for a long time, but [CodeWars](https://www.codewars.com) is super neat.  The [CodeNewbie](http://www.codenewbie.org) podcast put me onto it!  I've been using it to help me cultivate idiomatic grasps of Python (which I kind of already had) and Ruby and Javascript (which I definitely didn't/still don't/still working on it/don't judge me/FOR-LOOPS).  That's all for me though.  Talk more next time.





