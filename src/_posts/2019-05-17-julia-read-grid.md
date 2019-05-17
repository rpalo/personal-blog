---
layout: page
title: Read a Delimited File Into a 2D Array in Julia
description: Getting warmed up to work on Advent of Code challenges using Julia's powerful multi-dimensional array syntax.
tags: julia beginner practical
cover_image: julia-read-grid.png
---

This is a neat trick that took me a little while to figure out.  A lot of the Advent of Code challenges start by reading in a text file that is a 2D grid of characters.  I wanted to figure out how to do that in Julia.  There's a couple of cases I want to show.

## First Case: Delimited

This case is much simpler and more satisfying.  Let's say you have a text file called data.txt that looks like this:

```txt
A B C A
D B A C
C C C B
D A B B
```

How do we read this into a 2D array (matrix) in Julia to capitalize on the parallel processing power of Julia's syntax?

As it turns out, there's a function for that in the standard library: [the `DelimitedFiles` package.](https://docs.julialang.org/en/v1/stdlib/DelimitedFiles/index.html#DelimitedFiles.readdlm-Tuple{Any,AbstractChar,Type,AbstractChar})

```julia
using DelimitedFiles

grid = readdlm("data.txt", Char)

@show grid
```

`readdlm` is a cool function that takes a bunch of optional arguments for types, delimiters, eol chars, and more.  Here's the output of running the script:

```bash
~/temp
▶ julia delim.jl
grid = ['A' 'B' 'C' 'A'; 'D' 'B' 'A' 'C'; 'C' 'C' 'C' 'B'; 'D' 'A' 'B' 'B']
```

See how easy it makes it?  Handles line-endings and more!

## Second Case: Smooshed Chars

Now, what happens if the characters are *not* delimited and are all smooshed together?  Things get a little harder and we actually have to do some processing.  I'll show you the final solution and then discuss each of the key pieces.

Here's `smooshed_data.txt`:

```txt
ABCA
DBAC
CCCB
DABB
```

And here's what we need to do to process it:

```julia
lines = map(collect, readlines("smooshed_data.txt"))

grid = permutedims(hcat(lines...))

@show grid
```

And running it:

```bash
~/temp
▶ julia smooshed.jl
grid = ['A' 'B' 'C' 'A'; 'D' 'B' 'A' 'C'; 'C' 'C' 'C' 'B'; 'D' 'A' 'B' 'B']
```

A little more complicated, but still only 3 relatively short lines.  Let's talk about how it's working:

1. We use `readlines` to read all of the text from the text file into an array.  This is a handy shortcut for opening the file and reading one line at a time.  One nice feature of this is that it handles removing the newline characters for us--less to clean!

2. We `map` over that array of lines, `collecting` each of them.  `collect` takes it's argument and iterates over it, collecting the individual pieces into an array.  In our case, since each line is a string, we get a bunch of characters when we iterate over it.  So, in full, this line converts our array of strings representing each line of the file and converts it to an array of arrays of characters.

3. Unfortunately, 1-D arrays are held as columns, not rows, meaning Julia considers them N x 1 rather than 1 x N in shape.  For this reason, it's actually easier to combine the arrays of characters column by column next to each other, which we do using `hcat`.  `hcat` concatenates arrays side-by-side, and it takes an arbitrary number of arrays as its arguments.  For this reason, we need to *spread* the `lines` array into `hcat` using the `...` syntax.

4. Same line.  Because we now have the lines of characters in our data file, concatenated side by side, the current representation is this:

```txt
A D C D
B B C A
C A C B
A C B B
```

The first column matches the first row of our text file, etc.  This is "sideways-ish" from what we want.  We use `permutedims` to flip the rows and columns.  In other languages, you might consider this a "transpose."  For reasons that are understandable but frustrating, in Julia, the actual `transpose` function is recursive and for linear algebra, so `transpose(matrix)` only seems to work on numbers.

It's important to note that we could have also `permutedims(line)` for each line in order to convert from N x 1 to 1 x N before using a `vcat` call to concatenate them in rows.  This is more intuitive, but I'm not sure about the performance implications.  It seems like it should be a little slower.

In any case, we finally end up with what we were hoping for, a 2D array of characters ready for processing.  And hopefully a better understanding of some practical Julia basics!

## Looking for Help

I'm learning Julia and I'm to the point where I know a few ways to do the things I want to do, but I don't really know what's idiomatic or the best way to go.  If anybody has some helpful Julia resources beyond the official docs (great) or beginner "Intro to Julia" type resources, let me know what they are!