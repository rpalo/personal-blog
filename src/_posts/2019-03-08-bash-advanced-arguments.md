---
layout: page
title: Advanced Argument Handling in Bash
description: Techniques for processing more options and arguments for a more polished user experience.
tags: bash scripting advanced
cover_image: bash-advanced-arguments.png
---

In the last article, we covered [the basics of handling arguments in Bash scripts](https://www.assertnotmagic.com/2019/02/22/bash-basic-arguments/).  But those basics can only get you so far.  What if you want to build a script that has a really nice-feeling, polished user interface, with multiple long and short options, flags, and arguments?  This article will go through a few techniques for handling these more complicated cases in a robust, maintainable, readable way.

## Parameter Substitution

There is a whole category of features for enhancing your control over your parameters: requiring them, providing defaults, alternative values, and modifying the provided values.  They all take the form of `"${variable_name_with_funky_symbols}"`.  All of these are really handy to use with positional parameters like `$1, $2, ...`, but they can actually be used anywhere in your script for any variable.

### Required Values: `${1:?Error Message}`

It tries to evaluate the specified variable, but if the variable is unset *or empty*, it will exit the script with the provided error message.  The exit code will be a failure.

```bash
name="${1:?"A name is required."}"
echo "Hello, $name!"
```

I've seen some scripts combine this technique with the `:` command, which does nothing, as a way of making sure the arguments are there without storing them in a named variable.

```bash
# This script expects 3 side lengths of a triangle
: ${1?"Missing side 1"}
: ${2?"Missing side 2"}
: ${3?"Missing side 3"}

if [[ "$1" -eq "$2" && "$2" -eq "$3" ]]; then
  echo "Equilateral Triangle"
fi
```

In case this makes you anxious, [here is some more information about the `:` command.](https://www.gnu.org/software/bash/manual/html_node/Bourne-Shell-Builtins.html#Bourne-Shell-Builtins)

 > There's an alternative form of most of these operations that doesn't include a colon: `${1?Error Message}`.  This version works the same, but it won't raise the error message if the variable is empty, as long as its set.  This version often doesn't provide the safety that you're going to want, but I thought I'd mention it.

### Default Values: `${1:-default}`

This is nice when you want to help newer users make good choices by default and make life easier for the more common cases.

```bash
name="${1:-World}"
echo "Hello, $name!"
```

```bash
$ ./greet "Ryan"
Hello, Ryan!

$ ./greet
Hello, World!
```

### Assign a Default: `${var:=value}`

Very similar to the default values above.  The difference is that this will assign the value to that variable—the `:-` version only does a one-time substitution.  

```bash
$ echo "${username:=supercoolfriend}"   # username was undefined before this
supercoolfriend
$ echo "$username"   # Now it's defined!  The value sticks!
supercoolfriend
```

One caveat is that since you can't assign values to positional parameters in the normal way, you can't use this method with `$1, $2, ...`.  

```bash
# This won't work
$1=banana
# So, neither will this
echo ${1:=banana}
```

I haven't seen a really compelling use case for this yet, so if you've used this in a neat way, let me know!

### Alternative values: `${1:+value}`

This is another one that I've never really gotten much mileage out of.  But it *is* one of the more amusing operations, because it says "if the variable is provided, then ignore that value and use our value instead."

```bash
$ name="Ryan"
$ echo "${name:+Shaq}"
Shaq

$ unset name
$ echo "${name:+Shaq}"
# Empty string
```

### And More!

The examples above have to do with handling variables, whether or not they have been supplied, and if they have values.  There are a lot more of these variable/braces functionalities, but they focus more on modifying/manipulating the existing variable, so I think I'll leave them for a future "String Manipulation in Bash" article.  In the meantime, [this documentation is the reference I use whenever I forget the exact syntax.](https://www.tldp.org/LDP/abs/html/parameter-substitution.html)

## Let's Get `shift`y

On its own, `shift` is not all that impressive of a command[^1], but we're going to combine it with some of the ideas below, so I thought it would be good to introduce it now.  After going through my last article, you're clearly an experienced pro at using positional parameters: `$1, $2, $3, ...`.  No sweat!

`shift` takes these arguments and removes the first one, *shifting* each of the rest down by one place in line.

```bash
echo "$# arguments: $1 $2 $3 $4"
# 4 arguments: nick nack patty whack

shift
# drop the first one.  Now we have "nack" "patty" "whack"

echo "$1"
# nack

shift 2
# drop two more!  Now we have "whack"

echo "$1"
# whack
```

## Handling Options

At some point, you're going to want options and flags to tune how your script works.  Bash provides a nice builtin command called `getopts` that gives you a framework for defining which arguments have arguments and what to do in case of error.  It has some tradeoffs, because it can be a little more opaque/implicit than a plain ol' while/case, and it's a little less flexible.  So depending on your needs, you may choose to roll your own argument handling loop.  I'll show both options here so you can reference them when you need them.

### getopts

Here's the basic layout of a `getopts` loop.  I'll show you an example and then go through all of the bits one by one.

```bash
#!/usr/bin/env bash

function usage() {
  echo "Usage: $0 [-i] [-v*] [-h] [-f FILENAME] [-t TIMES] <word>"
}

VERBOSE=0
INTERACTIVE=  
FILENAME=memo.txt
TIMES=1

while getopts "ivhf:t:" opt; do
  case "$opt" in
  i) INTERACTIVE=1;;
  v) (( VERBOSE++ ));;
  h) usage && exit 0;;
  f) FILENAME="$OPTARG";;
  t) TIMES="$OPTARG";;
  esac
done
shift $(( OPTIND - 1 ))

name=${1?$( usage )}

if [[ "$TIMES" -le 0 ]]; then
  echo "TIMES must be a positive integer." >&2
  exit 1
fi

if [[ -n "$INTERACTIVE" ]]; then
  echo "Are you sure you want to party?"
  read -r -p"[yn] " answer
  if [[ "$answer" != y ]]; then
    echo "Exiting."
    exit 0
  fi
fi

printf "We are being "
for (( i=0; i<VERBOSE; i++ )); do
  printf "very "
done
printf "verbose.\n"

for (( i=0; i<TIMES; i++ )); do
  echo "Hello, $name!" >> $FILENAME
done

echo "Complete!"
exit 0
```

Whew!  Deep breath.

#### The Main Option Loop

OK!  There's a lot here to cover so let's get started.  The first few lines are setup, getting the placeholders for flags, variables, and functions we'll use in place.  The meat of this example is here:

```bash
while getopts "ivhf:t:" opt; do
  case "$opt" in
  i) INTERACTIVE=1;;
  v) (( VERBOSE++ ));;
  h) usage && exit 0;;
  f) FILENAME="$OPTARG";;
  t) TIMES="$OPTARG";;
  esac
done
shift $(( OPTIND - 1 ))

name=${1?$( usage )}
```

Within a while loop, we invoke `getopts`.  `getopts` processes arguments passed one by one.  The first argument to `getopts` is a string that lays out what options we're expecting and which of those options takes arguments.  If an option accepts/requires an argument, we place a colon after its letter.  The second argument is a variable name which will hold the letter option that is currently being processed.

#### Matching the Options

Now, let's talk about the case statement inside the loop.  

```bash
  case "$opt" in
  i) INTERACTIVE=1;;
  v) (( VERBOSE++ ));;
  h) usage && exit 0;;
  f) FILENAME="$OPTARG";;
  t) TIMES="$OPTARG";;
  esac
```

This is where we decide what to do depending on what the option is.  Notice how `getopts` drops the `-` before the letter for you.  The case statement itself can look intimidating.  There's a lot of weird syntax that you don't really see anywhere else.  [Check out these examples to see more on how to use the case statement.](https://bash.cyberciti.biz/guide/The_case_statement)

You'll also notice that, on any of the options that accept an argument, that argument will be stored in the variable `$OPTARG` automagically for you.

At the end of the current loop, `getopts` will skip over as many arguments as it used this round, but it *won't* `shift` them.  And the loop will continue as long as there are more arguments for `getopts` to find (anything starting with a single dash (`-`)).  Once there are no more options, the loop will end and we see the next line:

#### The Magic of `$OPTIND`

```bash
shift $(( OPTIND - 1 ))
```

`getopts` keeps track the next argument to be processed in another automagical variable called `$OPTIND`.  (These magic variables are a little of the reason I might prefer to roll my own argument handling, but more on that later.)  So, after parsing the options, if we want to continue with any regular arguments, we have to know where those start in the list!  We can either keep coming back to `$OPTIND` for that information, or, as is common, we could shift away all of the options that got processed so far, which are `$OPTIND - 1` arguments.

 > Long story short, this line allows us to continue our script as if none of the option parsing had to happen, where `$1` is the first positional argument passed to the script, and so on.

#### Handling Positional Arguments

You see us handling this positional argument in the very next line:

```bash
name=${1?$( usage )}
```

We even made use of our new fancy "Required Parameter" syntax—with a twist!  Did you know that you could interpolate command output into the error message?  You do now!

The rest of the script is us carrying on with dealing with any of the flags or constants that were set.  One thing I'd like for you to notice is that you can pass the same flag multiple times, as shown by the `$VERBOSE` variable.

#### Trying It Out

Here's an example of us running the script above:

```bash
$ ./args_example -i -vvvv -t 3 -f banana.txt GLOOMP
Are you sure you want to party?
[yn] y
We are being very very very very verbose.
Complete!

$ cat banana.txt
Hello, GLOOMP!
Hello, GLOOMP!
Hello, GLOOMP!

```

Because we provide the `-i` (interactive) option, it asks us if we're sure (we'll get to the `read` command a little later).  We pass 4 `-v` options, so we're being *extra* verbose, as you see from the output.  We change the default number of times to 3 and the default filename to `banana.txt`, and finally we pass `GLOOMP` as the first true positional argument.

Cool?  Cool.  That's the `getopts` command.

#### Handling Errors

In the previous example, we used `getopts` in what you might call the "loud" mode.  Any unrecognized options or options that require arguments that don't get them will cause an output of a warning.  Other than that, things will process like normal.

If you want a little more control over the output, or to silence it altogether, you'll want to use "silent" mode by adding a colon (`:`) to the front of your `getopts` options string:

```bash
while getopts ":ivhf:t:" opt; do
```

If this string starts with a colon, any unrecognized input will cause `$opt` to be set to a literal "?", `$OPTARG` will be set to the unknown character found, and no output will be written.  You can address this case by adding a case to your case statement:

```bash
  case "$opt" in
  # ...
  \?) echo "Invalid option $OPTARG" && exit 1;;
  esac
```

In this "silent" reporting mode, if you have an option that requires an argument, and that argument isn't provided, instead of a "?", the `$opt` will be set to a ":"[^2] and `$OPTARG` will be set to the option letter that's missing the argument.

```bash
  case "$opt" in
  # ...
  :) echo "Option '$OPTARG' missing a required argument." && exit 1;;
  esac
```

### Case Statement

Oh man, that was a lot.  Good work making it through the `getopts` example.  Get up and take a breather.  Walk around.  Tell all your friends how cool you are now that you are a `getopts` boss.

Back to work.

`getopts` is cool, but it *does* have its downsides.

1. It can't handle long options.  This is the main one.
2. There's a lot of magic.  From the semi-arcane opts-string to whether or not you're in "silent mode," to the magical `$OPTARG` and `$OPTIND` variables, at a certain point you'll probably write out a sweet script parsing options but have to check the docs (or this article!) again when you come back to modify it in six months.

Depending on your use case and how often this script will be read/updated/modified, it *may* make sense to write your own option parsing loop.  

Note: People on the Internet have Strong Opinions on Bash and argument parsing.  Bash scripts are some really low-hanging fruit for [bike-shedding](https://en.wikipedia.org/wiki/Law_of_triviality).  

 > Don't let it get you down if people express their opinions about your option handling loudly and/or badly.  Print them out a big ol' picture of a colon and tell them you set them to "silent" mode.

The fundamental process is the same as with `getopts`.  The difference is that we have to process and shift on our own.

To underscore the point that it's the same, let's rewrite the example above with our own version!  I *am* going to add long-options now—because we can!

```bash
#!/usr/bin/env bash

# ... Same setup code

while [[ "$1" == -* ]]; do
  case "$1" in
  -i|--interactive)
    INTERACTIVE=1
    ;;
  -v*)
    (( VERBOSE += ${#1} - 1 ))
    ;;
  --verbose)
    (( VERBOSE++ ))
    ;;
  -h|--help)
    usage
    exit 0
    ;;
  -f|--filename) 
    shift
    FILENAME="$1"
    ;;
  -t|--times) 
    shift
    TIMES="$1"
    ;;
  --)
    shift
    break
    ;;
  esac
  shift
done

# ... The rest is the same
```

Let's take a look at the differences.  Hopefully you're seeing an initial glimmer of the pro's and con's of doing your own loop: a little more flexible, but for some of the fancier features (combining flags into one blob, having arguments to options, etc.), you have to do a little more work and have a little more faith in your user.

#### The New Loop Condition

We'll start from the top:

```bash
while [[ "$1" == -* ]]; do
```

Because we have to drive our own loop, we have to manually check if there are any options present.  Here we're using "shell globbing" (a smaller, lighter version of regex) to check if the first parameter is a dash followed by any character at all.  This line could also read:

```bash
while [[ "$1" =~ ^- ]]; do
```

For those more comfortable with regex, this might seem a little more familiar.  It says "if the first parameter starts with a dash, then process it as an option."

If you don't want to have any additional arguments after your options, I've also seen people use the simpler:

```bash
while [[ -n "$1" ]]; do
```

This will process as long as there's an argument to process, but it doesn't bother to check if it starts with a dash or not.

#### Matching the Options

```bash
case "$1" in
  -i|--interactive) INTERACTIVE=1;;
```

So far not much changed.  We're matching directly to the first positional parameter.  No more magical stripping off of the dash for us.  But, we pick up the ability to do long options!

#### Handling Multiple Options on a Single Dash

```bash
  -v*) (( VERBOSE += ${#1} - 1 ));;
  --verbose) (( VERBOSE++ ));;
```

Here is where our life gets a little harder.  Where `getopts` handled the multiple `v` options for us seamlessly, we have to remember to handle it ourselves with the correct shell glob match.  Because of the complexity here, I ended up splitting the long and short options into multiple cases.  The short option matches `-v` followed by any more characters.  It will then add that many to `$VERBOSE`.  Ostensibly, we trust our user to typically do `-vvvv`, but our script would still allow it if they did `-vslfjadsfjadklsfjsl`.

If this is really bothersome, we can improve it with a judicious use of `shopt -s extglob`.  For now, [I'll leave it up to the you to research that if you want.](https://askubuntu.com/a/889746)

#### Handling Options with Arguments

```bash
  -f|--filename) 
    shift
    FILENAME="$1"
    ;;
```

Here, we `shift` the `-f` or `--filename` option out of the way and then save the *next* argument as the actual `$FILENAME`.  Here is where error handling gets a little tricky.  If you want to make sure that they've provided a filename for us, my recommendation is to do some error checking after the main options loop is done.  You might at least make sure that the filename argument doesn't start with a `-`, but then you'd be blocking your user from creating filenames that start with dashes.  Maybe that's what you want, and maybe it's not.  That part is kind of up to you.

However, this code snippet does show off the multi-line form of case matches.  You see how you might incorporate extra logic here if you can keep it from getting too long and unreadable.

Why do we not also `shift` away the argument after we're done with it?  You'll see in a moment at the bottom of the loop.

#### End of Arguments

```bash
  --)
    shift
    break
    ;;
```

It's reasonably common for commands to include a `--` option that signifies the end of flag options.  `getopts` does this for us behind the scenes.  Here we have do do it ourselves.  Because breaking the loop causes us to miss our final `shift`, we have to manually `shift` this `--` option out of the queue.

#### Finishing the Loop

```bash
  esac
  shift
```

After each iteration through, we must assume that we found a match, handled it, and are finished with the current argument in the queue.  So we shift it out of the way and the loop goes on to try evaluating the next one in line.

#### Handling Errors

In the code above, we don't really address errors at all.  There's really two types of errors: we could get an option that we're not expecting, and an option could be expecting an argument that it doesn't receive.

For options that we're not expecting, currently, our script lets them go by silently.  It reads them, they match nothing, and then it shifts them away, no harm and no foul.  That's probably OK.  If it's not, the main way to handle this is to add a catch-all case:

```bash
  *) echo "Unrecognized option $1." && usage && exit 1;;
```

Make sure that this is at the bottom.  It will match any case (thanks to the shell glob asterisk), but the cases are evaluated from top to bottom with no fall-through, so if it's on the bottom of the list, it will catch all cases that we haven't already caught/cared about, which is exactly what we want.

For options that don't receive their arguments, we've already discussed this a little.  I recommend handling that *after* the main loop.  In our current script, it will catch this:

```bash
if [[ "$TIMES" -le 0 ]]; then
  echo "TIMES must be a positive integer." >&2
  exit 1
fi
```

If the argument to `$TIMES` *isn't* a number, the `-le` will automatically cast that value to a zero to be compared.  For instance, if we ran 

```bash
$ ./case_example -t -f test.txt garbanzo
```

The value for `$TIMES` would actually be `-f` which comes after it.  Since this isn't a number, it gets cast to zero.  Zero is less than or equal to zero, so our script will throw an error.

This might be an issue if zero is a valid input for your particular use case.  In that case, perhaps a regex check might be better:

```bash
if ! [[ "$TIMES" =~ ^[[:digit:]]+$ ]]; then
```

### Comparison

By now, you've seen both methods.  

`getopts` has a lot of built-in niceness, but setting it up can be a little arcane and it can't handle long options.  It's a little more rigid in how the arguments have to be processed.  But sometimes that's a good thing!

A hand-rolled solution has added flexibility benefits, long options, and they tend to be more readable/immediately understandable.  You're not working *around* Bash's weirdness so much.  But, nice things like error handling, automatic shifting, and end-of-options flags aren't baked in by default.  You have to make sure they're handled and handled *right*.  This process can lead to more potential bugs if things get *really* complicated.

So it's up to you to decide, but now, at least you have a nice reference to look up when you're trying to figure it out.

And of course, no article on Bash would be complete without at least a mention that, if your application is large/complex/important/slow, it may be a good idea to look into converting this script into a more robust, powerful, faster language of your choice.  

But again, if you want to do it in Bash, at least now you know how!

## Looking Forward Some More

I wanted to include a section on reading from STDIN and accepting input from pipelines, but then I finished the above section and my word-counter hit 3400 words.  So maybe we've got enough here and we'll handle STDIN in the next article.

What I've got here is a good starting place and a synthesis of a bunch of different methods that I've seen people use.  I'm sure there are almost as many methodologies and cool use cases as there are shell users, though.  So if you've got some neat ways of handling inputs and options that I missed, definitely share them with me!

Happy scripting!


[^1]: It *is*, however, the easiest command to mistype with embarrassing results.

[^2]: This also makes it the *happiest* case!  Yay! :)