---
layout: page
title: "Bash If Statements: Beginner to Advanced"
description: Learn how to supercharge your Bash branching!
tags: bash scripting
cover_image: bash-branches.jpg
---

Bash is an interesting language.  It's designed primarily to be used interactively on the command line, essentially in a REPL (Read-Evaluate-Print-Loop), working on one user command at a time.  It's designed to handle plain text powerfully and succinctly.  This has the side-effect of causing it to be a little more difficult to do things that aren't interactive or text-based, like arithmetic, control flow, and manipulating variables.

In this article, we'll go through one of those slightly confusing topics: `if` statements.  We'll dive into how they work and how we can use those mechanics in really neat ways.

*Note: This article is specifically about Bash, although most things will translate to Zsh and other shells.  Some of this isn't POSIX compliant.  That's a thing some people have Opinions about.  I won't address that at all in this article.  If you're thinking about being pedantic about it, you can just `sh`.*  🤫

## The Basics

An if-statement in Bash works pretty similarly to most other languages.  It follows the basic form:

```bash
if [[ "$some_variable" == "good input" ]]; then
  echo "You got the right input."
elif [[ "$some_variable" == "ok input" ]]; then
  echo "Close enough"
else
  echo "No way Jose."
fi
```

The added syntax of the keyword `then`, along with the slightly strange closing keyword of `fi` make it seem a little more exotic than other languages[^1], but the fundamentals are the same:

*If something is true, then do this thing.  Otherwise check these other conditions in order and do the same thing.  If none of them work out, then do the last thing.*

You can leave out one or all of the `elif` branches, and you can even leave off the `else` branch if you don't need it!

The boolean operators `!` (not), `&&` (and), and `||` (or) can be used to combine booleans, just like other languages.

```bash
if [[ "$name" == "Ryan" ]] && ! [[ "$time" -lt 2000 ]]; then
  echo "Sleeping"
elif [[ "$day" == "New Year's Eve" ]] || [[ "$coffee_intake" -gt 9000 ]]; then
  echo "Maybe awake"
else
  echo "Probably sleeping"
fi
```

But here's the confusing thing.  Sometimes you'll see these with double square brackets like I showed above.  Or sometimes they'll be single square brackets.

```bash
if [ "$age" -gt 30 ]; then
  echo "What an oldy."
fi
```

Or sometimes they'll be *round!*

```bash
if (( age > 30 )); then
  echo "Hey, 30 is the new 20, right?"
fi
```

And sometimes they won't be there at all!

```bash
if is_upper "$1"; then
  echo "Stop shouting at me."
fi
```

How do you know which ones you're *supposed* to use?  When do you use each version?  Why won't certain ones work at certain times?

## What's Really Happening

Here are the magic words that drive everything about how `if` works in Bash: **exit codes**.  What's really happening here is the pattern:

```bash
if ANY_COMMAND_YOU_WANT_AT_ALL; then
  # ... stuff to do
fi
```

That's right: the stuff immediately after the `if` can be any command in the whole wide world, as long as it provides an exit code, which is pretty much always.  If that command returns with an exit code of 0, which is the Bash exit code for success, then the code inside the `then` branch gets run.  Otherwise Bash moves on to the next branch and tries again.

*But wait, does that mean--*

Yep.  "`[`" is a command.  It's actually syntactic sugar for the built-in command `test` which checks and compares its arguments.  The "`]`" is actually an argument to the `[` command that tells it to stop checking for arguments!

```bash
if [ "$price" -lt 10 ]; then
  echo "What a deal!"
fi
```

In this example, the `[` command takes arguments `"$price"` (which gets substituted right away with the value of the variable), `-lt`, `10`, and `]`.  Now that you know that `-lt`, `-gt`, and similar numerical comparisons are actually arguments, doesn't the strange syntax make a little more sense?  They kind of look like options!  That's why `>` and `<` get weird inside single square brackets -- Bash actually thinks you're trying to do an input or output redirect inside a command!

### What About the Double Square Brackets?

Strangely enough, the `[[ double square brackets ]]` and `(( double parens ))` are not *exactly* commands.  They're actually Bash language keywords, which is what makes them behave a little more predictably.  That being said, they still return an exit code depending on their contents.  The `[[ double square brackets ]]` work essentially the same as `[ single square brackets ]`, albeit with some more superpowers like more powerful regex support.

*If you want to find out more about the different bracket punctuation in Bash and what they do, check out [this reference I put together](https://www.assertnotmagic.com/2018/06/20/bash-brackets-quick-reference/).*

### What About the Double Parentheses?

The `(( double parentheses ))` are actually a construct that allow arithmetic inside Bash.  You don't even need to use them with an `if` statement.  I use this a lot to quickly increment counters and update numeric variables in-place.

```bash
count=0
(( count++ ))
echo "$count"
# => 1
(( count += 4 ))
echo "$count"
# => 5
```

What you're not seeing is that the arithmetic parens are actually returning an exit code each time they're run.  If the results inside are zero, it returns an exit code of 1.  (Essentially, zero is "falsey.")  If it's any other number, it'll be "truthy" and the exit code will be 0.  Here's a weird example:

```bash
if (( -57 + 30 + 27 )); then
  echo "First one"
elif (( 2 + 2 )); then
  echo "Second one"
else
  echo "Third one"
fi
# => "Second one"
```

Luckily for us, the greater and less-than symbols work just fine inside arithmetic parens.  If the comparison is true, the result will be a 1.  Otherwise, it'll be a zero.

```bash
if (( 5 > 3 )); then
  echo "Numbers make sense."
elif (( 3 <= 2 )); then
  echo "3 is less than or equal to 2. wat."
else
  echo "Hwwaaa"
fi
# => "Numbers make sense"
```

A weird but fun offshoot of that functionality is this:

```bash
echo $(( (5 > 3) + (0 == 0) ))
# => 2
# Each comparison is true, so we're effectively echoing
# 1 + 1.  Fun, right?
```

## Using Commands Instead of Brackets

Much of the time, you'll be using some kind of brackets with your `if` statements.  However, since commands and their exit codes can be used, the entire power of the command line stands behind your `if`s.

Let's say we only wanted to do something only if a line was found in a file.  What command would you normally reach for to search files for text?  `grep`!

```bash
echo "Hello, welcome to bean house." >> dialogue.txt
echo "Would you like some coffee?" >> dialogue.txt

if grep -q coffee dialogue.txt; then
  echo "Found coffee, boss."
else
  echo "No coffee."
fi
# => "Found coffee, boss."
```

If `grep` finds what it's looking for, it exits with exit code 0 for success.  If it doesn't, it exits with exit code 1 for failure.  We use that to drive our `if` statement!  The `-q` option to `grep` stands for `--quiet`, and it keeps `grep` from outputting any lines it finds.  If we take it off, our output will look like this:

```txt
Would you like some coffee?
Found coffee, boss.
```

> Do you have other commands that you use this way?  Let me know!  I had a hard time thinking of examples, and I'm sure there's some really powerful use cases out there.

### Using Your Own Functions

The best part about this whole thing is that you can write your own functions!  This helps you encapsulate your logic into something with a higher-level name that makes your scripts more readable and clarifies your intent.  And if there's somewhere where we could use some extra clarity, it's in the "throwaway" script that Jerry wrote last year that we're still using in the build pipeline.

I need to write a whole 'nother post about writing functions in Bash, because they're great and I love them.  For now, the Spark Notes version is that they work just like little mini-scripts of their own.  Any arguments you pass them can be accessed positionally by the special variables, `$1`, `$2`, `$3`, etc.  The number of arguments is in the variable `$#`.

```bash
function is_number {
  if [[ "$1" =~ ^[[:digit:]]+$ ]]; then
    return 0
  else
    return 1
  fi
}
```

Notice that we use `return` here instead of `exit`.  They do the same thing, except that `exit` will kill the whole script instead of just finishing the function.  This function can be used like this:

```bash
function is_number {
  if [[ "$1" =~ ^[[:digit:]]+$ ]]; then
    return 0
  else
    return 1
  fi
}

age="$1"

if ! is_number "$age"; then
  echo "Usage: dog_age NUMBER"
  exit 1
fi
```

See how the programmer's intent and logic becomes way more clear without the implementation details and bulky regexes getting in the way?  Bash functions are Good Things.

In fact, if a function doesn't explicitly `return` a value, the return value of the last command in the function is used implicitly, so you can shorten your function to:

```bash
function is_number {
  [[ "$1" =~ ^[[:digit:]]+$ ]]
}
```

If the regex works out, the return code of the double square brackets is 0, and thus the function returns 0.  If not, everything returns 1.  This is a really great way to name regexes.

## `if` is Good

There you go!  Go forth, cleaning up your Bash scripts with your newfound powers of sane, idiomatic branching.  And share your use-cases with me!  I love seeing other people's neat Bash-isms.

[^1]: Also, it's fun to read in your head.  FI!