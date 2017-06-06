So this is about one of those things that I knew existed, but I kind of thought "Oh, this is just for scientists and data people to do science and data things."  And then I used it to write interactive code snippets for a lecture (that I hope to give some day) and now my mind is blown and I'm probably going to write all of my blog posts this way from now on.  So without further ado:

# Jupyter Notebooks

You may know about these.  If you're a data scientist or have done some amount of Python you may have seen these, and you may know it by its previous name: IPython Notebooks.  For those of you who don't know, it looks like this.

![first look at Jupyter Notebook](/img/jupyter-introduction.png)

It's awesome.  It has individual cells that can be code or markdown.  The code cells run independently, but in the same namespace, so you can carry variables and data from one cell to the next.  You can do something like this:

![notebook cell demonstration](/img/jupyter-1.png)

Note how the cells will output the last evaluation without a print statement required, just like a REPL.  Here are some other cool things.

## Pretty Data Output

If you *are* working with a lot of data, notebooks will inline pretty table and chart outputs.

![different cell outputs](/img/jupyter-2.png)

## Internal Links

This:

![Raw table of contents](/img/jupyter-3.png)

Renders to this:

![Rendered table of contents](/img/jupyter-4.png)

And the internal links work!

## No More Cleanup Scripts

Again, if you're working with data, you don't have to have a separate script to clean the data and re-output it into a csv (or whatever).  Each cell remembers its state, so you can run the cell at the top that takes forever to clean the data once and then re-run and re-modify the cells below without having to rerun the cleaning cell.

## Lots of Inputs and Outputs

While I found out about it through Python -- and I think initially it only supported Python -- the community now provides about a billion different kernels you can run.  See the full list [here](https://github.com/jupyter/jupyter/wiki/Jupyter-kernels).

For my purposes, I like that it outputs directly to markdown for blog posts, but it also outputs into python files, restructured text, latex, pdf, and html!

## More

I also just discovered something called [nbgrader](https://github.com/jupyter/nbgrader) that is essentially an assignment/automated grading framework for Jupyter Notebooks.  I haven't used it yet, but it looks like the things that dreams are made of.  There's also support for converting a notebook into a html slideshow.  [This plugin](http://bollwyvl.github.io/live_reveal/#/) allows for a powerpoint-like feel while still being able to execute cells, for prestructured quasi-live-coding demos.  Honestly, as I keep finding these features, I keep getting more and more excited.

Long story short, Jupyter Notebooks are the business.  [Get it today.](http://jupyter.org/install.html)
