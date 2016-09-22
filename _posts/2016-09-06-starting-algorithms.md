---
layout: page
title: Starting Algorithms
---

This week I am starting a class on algorithms (as part of the OSSU cousework).  I currently know three things.  Thing one: I am actually (pretty much) on schedule for blog posts!  Booyah for every two weeks!  It works great, because I tell myself that I'm actually going to be a go-getter and post an extra one in my off week, but by the time that I get to doing that, it's the second week and I'm just regularly on time.  So that works out.  Thing two: I have a really hard time focusing on just one thing for very long, especially when learning coding things.  Thing three: I'm trying really hard to limit the number of classes I'm doing.  Currently, I'm only working on

 * Program Design
 * Databases
 * Algorithms
 * Discrete Mathematics

And on the side:

 * Improving Ruby-ness
 * More practice with idiomatic Python
 * Wrestling Jekyll to make this blog look like how I want
 * [The in-house Django apps for work](https://github.com/rpalo/pq-portal)

Anyways.  To what I wanted to talk about: this algorithms class!  It's really, _really_ interesting!  I think the first couple lessons are just warm-ups to get your feet wet and your mind thinking in algorithm mode, but they are still making me think really hard.  The main thing I've learned about so far is the "Dynamic Connectivity Problem."  This is the idea that, given some number of nodes, is there some _efficient_ way of checking if two are connected?  Yes.  Yes there is.

It's called union find.  You lump all of the connected entities into a blob, and then when you connect two more entities, you combine the blobs that they are in.  Here's the basic setup:

{% highlight python %}
class UF:

    def __init__(self, infile):
        with open(infile, "r") as f:
            # Infile is of the form:
            # <length of mesh>
            # <union target> <union target>
            # ...
            # ...
            self.nodes = None
            for line in f:
                if not self.nodes:
                    self.nodes = [i for i in range(int(line))]
                else:
                    a, b = [int(i) for i in line.split()]
                    self.union(a, b)

    def union(self, a, b):
    	# Connects node a to node b
        pass

    def connected(self, a, b):
    	# Returns true if node a is connected to b.  False otherwise
        return False

    def __str__(self):
        return str(self.__class__) + str(self.nodes)

{% endhighlight %}

So essentially, we lay each node out into a single array.  Here's one way to connect them called quick-find.  It makes finding out whether or not two nodes are connected really easy, but both setup and unions are linear (N) time, meaning that if you have 10x as many inputs it will take ~10x as long to run.  I'll talk more about this N notation in a different post.  The take away is that loading is slow, but accessing is fast later.

{% highlight python %}
class QuickFindUF(UF):
    # Quick find works by making the groups into a tree
    # with a root node.  If two nodes point at a root,
    # they are connected.

    def union(self, a, b):
        # Make any node pointing at the root of a point at b,
        # thus making b the root of the flat tree.
        # Union is slow, looping through all nodes everytime
        if self.connected(a, b):
            return True
        root_a = self.nodes[a]
        root_b = self.nodes[b]
        for i in range(len(self.nodes)):
            if self.nodes[i] == root_a:
                self.nodes[i] = root_b

    def connected(self, a, b):
        # This makes 'connected' simple and fast!
        # Simply see if the root of the nodes are the same with an array access
        return self.nodes[a] == self.nodes[b]

{% endhighlight %}

This is great, but can we improve performance?  The next one is called Quick-Union.

{% highlight python %}
class QuickUnionUF(UF):
    # Quick Union works by simply pointing the root
    # at the new root.  Now we have a non-flat chain
    # of nodes.  This makes the trees possibly
    # really tall, which isn't great for performance either

    def union(self, a, b):
        # union is also not that quick,
        # possibly traversing a tall tree!
        # If the trees were flattish, this would be
        # quicker.
        if self.connected(a, b):
            return True
        root_a = self.find_root(a)
        root_b = self.find_root(b)
        self.nodes[root_a] = root_b

    def connected(self, a, b):
        # for this, quick union is slow, because
        # you have to traverse a tree two times
        return self.find_root(a) == self.find_root(b)

    def find_root(self, a):
    	# New find root function.
        # Find the root node that a belongs to
        # assume a is an index in self.nodes for simplicity
        root = self.nodes[a]
        while self.nodes[root] != root:
            root = self.nodes[root]
        return root

{% endhighlight %}

The way to fix the problems with Quick Union is to provide some weighting!  If we make sure that we always make the bigger tree the root, then we'll end up never placing an already tall tree below a smaller one.  We should have a much flatter structure.  In order to do this, we have to keep track of a size or depth for each connected blobtree.  This is just a second array that keeps track of the depth.  Since each union (by definition) makes that tree one step deeper, you just increment the size of the new root by 1!

{% highlight python %}
class WeightedQuickUnionUF(QuickUnionUF):
    # Weighted quick union UF is similar to QUUF,
    # but it attempts to flatten the trees by
    # appending the smaller tree to the larger one
    # on each union
    def __init__(self, infile):
        with open(infile, "r") as f:
            self.nodes = None
            self.size = []
            for line in f:
                if not self.nodes:
                    self.nodes = []
                    for i in range(int(line)):
                        self.nodes.append(i)
                        self.size.append(1)
                else:
                    a, b = [int(i) for i in line.split()]
                    self.union(a, b)

    def union(self, a, b):
        if self.connected(a, b):
            return True
        root_a = self.find_root(a)
        root_b = self.find_root(b)
        if self.size[root_a] > self.size[root_b]:
            self.nodes[root_b] = root_a
            self.size[root_a] += 1
        else:
            self.nodes[root_a] = root_b
            self.size[root_b] += 1
{% endhighlight %}

Through some math, it turns out that this gets us from `N^2` time to setup and union things to `M*lg(N)` time, which is an awesome improvement.  I know this was kind of heavy, but I think it was good for me to do it out and explain it some.  More in the next post.