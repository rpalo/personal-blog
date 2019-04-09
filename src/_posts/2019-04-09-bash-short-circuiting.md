---
layout: page
title: Short Circuiting in Bash
description: Sharpen up your bash scripts with one-line conditionals!
tags: bash beginner basics
cover_image: bash-short-circuiting.png
---

In Bash, the `&&` and `||` (AND and OR) operators work via a "short-circuit" policy.  Here's what I mean.

It helps to think about it in terms of how you would use them in boolean comparisons:

```bash
if [[ "$1" -gt 5 ]] && [[ "$1" -lt 10 ]]; then
```

This checks the first condition.  If the first condition is true, then there's a possibility the whole thing could be true, so it checks the second condition.  If the second condition is true, then the whole thing is true!  However, if the first condition is false, then there's no reason to check the second condition, because the whole thing could never *possibly* be true with the first one false.

We can use this property with commands too!

```bash
[[ "$1" -gt 5 ]] && echo "It's such a big number!"
```

If the first comparison succeeds (exit code of 0 means success), then the second command runs and echoes (echos?  ecks?  does the echo)!  If, however, the comparison fails, then Bash doesn't bother to run the echo command at all.

The best part is that no `if` is required.  You can do this with mathematical comparisons and arbitrary code too.

```bash
(( "$1" % 17 == 0 )) && result+="Banana"
```

You can even do it with commands that can pass or fail!

```bash
$ mkdir "fish" && echo "Directory created"
Directory created
$ # Now let's try making it again, which will fail
$ mkdir "fish" && echo "Directory created"
# No output
```

## `||`: Do X or else!

In fact, this error-messaging is one good use case for the *other* symbol: `||`.  `||` does things the opposite way.  Again, let's think about this from the perspective of how it would get evaluated in a conditional:

```bash
if [[ "$1" -lt 0 ]] || [[ "$1" -gt 10 ]]; then
```

If the first condition doesn't get met, no problem.  We still have the second one that could be true, so we'll evaluate it.  But, if the first condition is true, then we don't even need to check the second condition, because we already know the conditional as a whole is going to be true.  So we skip it!

This works exactly the same way with regular commands:

```bash
$ mkdir "fish" || echo "There was a problem."
# Nothing printed.  'fish' dir got made, so the second condition
# had no need to run!
$ mkdir "fish" || echo "There was a problem."
There was a problem.
```

## Combining Them for Ternary Power

Now that we have these new super-powers, a gateway is opened to new patterns like the "bash ternary" pattern:

```bash
[[ "$1" == good ]] && echo "Good input!" || echo "Bad input!"
```

If the first command succeeds, we run the middle command.  Otherwise the first clause (`[[ ]] && echo`) fails, so the last command gets run.

However, one little caveat is that, if the middle clause is a command that *can potentially fail* and it *actually does fail*, the third command will get run as well.  This is a weird, unexpected edge case that a traditional ternary operation wouldn't expect: all three commands get run!

```bash
$ name="bob"
$ [[ "$name" == bob ]] && mkdir "fish" || echo "Name not bob"
# Makes a directory called 'fish', no output
$ [[ "$name" == bob ]] && mkdir "fish" || echo "Name not bob"
Name not bob
# Well, that's just confusing.  Name *is* bob!  But mkdir
# failed, so the "else" case gets run anyways, confusingly.
```

## Caveat

One more caveat.  Just like in any other languages, trying to get too fancy with one-liners can tend to lead to some dense, hard-to-read, "clever" code (with solid sarcastic air quotes) that will make anyone else who reads your code sad.  When you're using this "one-liner conditional," make sure that you take extra care to have empathy for the next person to read the code.  Try to keep it extra neat and readable, and if you can't do that, it might be time to go back to a multiline `if` or use a helper function.