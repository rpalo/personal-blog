---
layout: page
title: 'Returning Multiple Values (“Tuples”-ish) from Bash Functions'
description: Python can return tuples from functions.  Learn how to do the same in a nice, clean, and idiomatic way in Bash.
tags:
- bash
- scripting
---

Let’s say you need to return three values from a function in Bash for some reason.  How do you do that?  There are a few options, but my favorite is using Bash’s built-in field separating powers and `read` command.  It makes the code really clean and crisp and lets you use your functions as streams of text, just like any other command line utility, which is _always_ a good thing.

Here’s our example:

We want a function that mimics Python’s `partition` function.  This takes an input string and a splitting character and returns the part before, the delimiter, and the part after as a tuple.

Here’s the function.

```bash
# Splits up a string based on the first occurrence of a
# character in a string.
# Returns <part before delim>, <delim>, <part after delim>
function partition() {
  local string="$1"
  local delim="$2"
  local before after

  before=${string%%$delim*}
  after=${string#*$delim}
  echo "$before"
  echo "$delim"
  echo "$after"
}
```

Now, how we handle this depends on a few different cases and there are a few different gotchas to look out for along the way.

## The Less than Ideal Way

In the simplest case, your outputs are very controlled and you know for _sure_ that you won’t ever have any character that could be construed as part of the default `IFS`—essentially, whitespace.  In that case, you can get them all in one read command.

```bash
local before delim after
read -r -d '' before delim after <<< "$( partition 'youtube.com' '.' )"
echo "$before | $delim | $after"
# => youtube | . | com
```

Here’s what we did:

* We’re using the read command which is typically used to read some amount of input from the user or a file into a variable.
* We’re using `<<<` to pass a string as the input to the `read` command.  By default, `read` reads from STDIN, and that’s not what we want here.  We want it to read from the lines of the output of our function.
* We use `-r` (like you should pretty much do 100% of the time) so that `read` passes through any backslashes into the string we get rather than parsing escape characters and doing weird things.
* By default, `read` reads until it hits its default delimiter, a newline.  Then it stops.  This is why you press enter when you’re giving input into a user-interactive script.  We want it to read multiple lines, and then split those lines up based on whitespace and pass each piece to the subsequent variables.  That’s why we tell it not to use a delimiter by telling it `-d ‘’`.  (Note here that the space is mandatory between the `d` and the quotes.  This way, `read` will keep reading until it can’t read any more before it does the splitting and the distribution of text to variables.

This method has one major downside.  If `read` gets to the end of the file and doesn’t see the delimiter you told it to look for, it returns an exit code of 1 (i.e. an error).  Since we made the delimiter _nothing_, we’re guaranteed for that to happen.  It’s what we want to happen.  However.  If you’ve got `set -e` or `set -o errexit` (which do the same thing) at the top of your script, which is _usually_ a good and safe thing to do, this “error” will cause your script to die with no useful error message and you’ll tear your hair out debugging the issue.

So, if we want to read all three lines with one `read`, we either have to take out the `set -o errexit` option (not great) or change our partition function to return something with spaces instead of newlines (maybe OK, depending on your use case, but less flexible for later.

If we wanted to, it would be even cleaner to replace the last three lines of our function with this:

```diff
- echo "$before"
- echo "$delim"
- echo "$after"
+ echo "$before $delim $after"
```

Then our main function can receive it like this:

```bash
local before delim after
read -r before delim after <<< "$( partition 'youtube.com' '.' )"
```

Getting rid of the extra `-d ''` option cleans things up a little.

## A Better Way: Multiple Lines into Specific Variables

OK, that’s great!  But what if you _really, really_ want your function to output line by line.  Not a problem.  `read` is really the most ergonomically set up to read one line per call.  But who says we need to stick to one `read` call?

We’re back to our three-line return that we had originally:

```diff
- echo "$before $delim $after"
+ echo "$before"
+ echo "$delim"
+ echo "$after"
```

Now let’s read!

```bash
{
  read -r before
  read -r delim
  read -r after
} <<< "$( partition 'youtube.com' '.' )"
```

We’ll just group our reads together inside a block of grouping braces and those lines will proceed using the output of our partition function as their input.  The neat thing about this is that you don’t have to process all of the arguments!

```bash
{ read -r before; } <<< "$( partition 'youtube.com' '.' )
# Bash just drops the other two outputs!
```

## Reading an Unknown Number of Lines

OK, this is the last scenario.  What if your function kicks out an unknown number of lines?

```bash
function laugh() {
  local times
  times=$(( RANDOM % 8 ))
  for ((i=0; i<times; i++)); do
    echo "HA!"   # Just an example to show some unknown number of lines returned.
  done
}

readarray laughs <<< "$( laugh )"
echo "There were ${#laughs[@]} laughs."
# => There were 6 laughs.
```

`readarray` is an exceptionally useful command and it does exactly what we want really cleanly.

## Functions are Just Mini-Commands

It’s amazing how often I am reminded that Bash functions are essentially just miniature commands or scripts, and that the neatest, cleanest answer to a question of “how do I do this in Bash” is often “stop fighting against Bash and use its strengths.”

How do we return multiple arguments?  The same way we output anything in any Bash command.  Kick it out as output and assume the calling code knows what to do with it.  How do we retrieve multiple things being emitted from a function?  Read it line by line and process it a line at a time like most other command line utilities.

There shouldn’t be that much of a difference in usage between your internal functions and commands like `grep`, `sed`, or `awk`.  If an idiom was good enough for the authors of the classics, you should probably have a darn good reason why it’s not good enough for you.

Happy scripting!
