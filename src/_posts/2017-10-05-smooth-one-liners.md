---
layout: page
title: Smooth Ruby One-Liners
description: Don't have time to look up that awk/sed syntax?  Too rushed to write a full script?  Let these Ruby one-liners do the heavy lifting for you.
tags: ruby bash sysadmin
cover_image: one-liner.png 
---

When I first started learning Ruby, the first book I read had a chapter at the front about all of the command line options and flags for the `ruby` command.  Missing the point as usual, I flipped quickly through that section without reading much.  "Yeah, yeah, yeah," I said to myself as I pulled open my editor.  "Whatever.  Just get to the good stuff.  Show me those *objects*!  Those *classes!*"  Well, I'm here to say: I Missed Out.  A chapter on a different book I'm now reading ([Practical Ruby for System Administration](http://www.apress.com/us/book/9781590598214) by Andre Ben-Hamou) also had a section about this, and this time I paid attention.  Now I want to share the highlights with everybody else!

## The Good Stuff

### Simple Execution

Let's start simple.  The `-e` flag will have the Ruby interpreter execute a command string inline and output the result to `stdout`.  Useful if you can't remember that darn Bash command for doing floating point math (*hint: it's `bc`*)!

```bash
$ ruby -e 'puts (Math.sqrt(32**2/57.2))' > calc.txt
```

A note about quotation marks.  Many of the useful Ruby one-liners contain special variables like `$_, $<, and $.`.  This is all fine and dandy until you add Bash string interpolation into the mix.  Since you interpolate variables like this in Bash:

```bash
echo "That's no $silly_thing, that's my wife!"
```

If you surround your Ruby command with double quotes, your special variables will have unpredictable results.  It's best to stick to single quotes around the command at all times.

The first example is a bit useful if you're stubbornly refusing to Google Bash commands, but only slightly more convenient.  But stay with me, because we're just getting warmed up.

### Line-by-Line Processing

The `-n` flag wraps your executed one-liner in an implicit `while gets ... end` block.  When you combine this with the usage of Ruby's special global variable `$_`, which stores the result of the most recent `Kernel.gets` command, you can do some nice (**and readable**) file processing!

```bash
$ ruby -ne 'puts $_.strip if $_ =~ /soup/' /home/rpalo/recipes
```

Which will strip out excess whitespace and print me every line that contains the word 'soup'.  I don't know about you, but a script like that would be critical to my infrastructure.

If you get tired of typing `puts $_.something.something` after a while, don't worry.  The `-p` flag drops an implicit `print $_` at the end of your command, so you can just modify the variable.  We can clean up the previous example like this:

```bash
$ ruby -pe '$_strip! if $_ =~ /soup/' /home/rpalo/recipes
```

You're saving at least 4 whole characters there.  Don't spend it all in one place.

### In-Place File Editing

"I feel like I'm not a real developer because I haven't taken the time to learn to use the `sed` or `awk` command!"  Firstly, that's silly.  You should disregard anyone who begins any sentence with the phrase, "You're not a real developer if...".  Additionally, you can make them feel sad when you edit files in place (like `sed -i` does)!  Here's four ways to do this, in order of increasing levels of shwoopiness.  Let's say you wanted to remove the default comments from a configuration file (not recommended unless you promise to add your own back in).

```bash
$ ruby -pe '$_.gsub!(/#.*$/, "")' .myconfig > .myconfig
```

Redirect the modified lines to overwrite the file instead of printing to `STDOUT`.  You can leave that off if you use the `-i` flag.

```bash
$ ruby -i -pe '$_.gsub!(/#.*$/, "")' .myconfig
```

This works great when you want to run this command against multiple files.

```bash
$ ruby -i -pe '$_.gsub!(/#.*$/, "")' *.conf
```

The glob match will run through each of the files ending in .conf and overwrite them.

Lastly, if you're paranoid and risk averse (i.e. you've been using the terminal long enough to know the pain of overwriting a file with an error in your script and losing everything -- #GodBlessGit), you can add a file extension to your `-i` flag like this: `-i.bak` and it will save the old version with that file extension before writing; `.myconfig` won't have comments, but there will be a new `.myconfig.bak` that still does.

> There MUST be NO space between the `-i` and the backup file extension or it won't work.  You have been warned.

### Farming the Rows and Fields

I want to talk about two more special global variables: `$< and $.`.  The first one refers to the file that was input.  The second one refers to the current line number.  (Note that this means that `$. and $<.lineno` are synonymous).  You can implement a rough version of `head` like this:

```bash
$ ruby -ne 'puts $_ if $. <= 10' test.txt
```

To use fields in files that might be delimited, such as csv's or system files like `/etc/passwd`, you might first try doing this:

```bash
$ ruby -ne 'puts $_.split.first + $_.split.last' test.txt
```

That works, but you can have the heavy lifting done for you with `-a`, which stands for "autosplit".  It drops the pre-split fields into a special variable called `$F`.

```bash
$ ruby -a -ne 'puts $F.first + $F.last' test.txt
```

The above example only works with spaces as delimiters, though!  you can specify *that* with `-F`.

```bash
$ ruby -a -F: -ne 'puts $F.first' /etc/passwd
```

### Setup and Teardown

If you *have* used `awk`, then this next part may be familiar.  You can do some initializing before you run through the input file and teardown/final output after, using `BEGIN` and `END` blocks.  Useful for things like counting the total number of lines that match a pattern.

```bash
$ ruby -ne 'BEGIN { ducks = 0 }; ducks += 1 if $_ =~ /ducks/; END { puts ducks }' duckfile.txt
```

Using this setup and teardown, your one-liners get quite a bit more powerful.

### Requiring Modules

You've probably actually used this in other ways, but you can require gems and modules from the standard library with the `-r` command.  For instance, to list out your machine's IP addresses, you could do this:

```bash
$ ruby -rsocket -e 'puts Socket.ip_address_list.map(&:inspect)'
```

Play with primes!

```bash
$ ruby -rprime -e 'puts Prime.first(20)'
```

## Wrapping Up

Overall, these may not give you a 10x productivity boost, but they are fun and I feel like they provide an interesting approach.  They seem especially useful if you've been deep into a Ruby project and switching your brain over to Bash is too much work.  Halfway through writing this post, I went to Google, and there are an amazing number of blog posts about this topic.  (Kind of made me feel lame for posting about it, to be honest).  But it's a fun topic, and it's just one more of those things that makes Ruby fun to use, so I thought it would be good to share.  Anyways, tweet/message me if you've got any cool Ruby one-liners that you use all the time!  I'll add them to this list:

## Submitted by Awesome People

```bash
# First two submitted by me to avoid a sad empty list here
# Delete trailing whitespace
$ ruby -pe 'gsub(/\s+$/, "\n")'

# Prints too long lines
$ ruby -ne 'puts $_ if $_.length > 80'
```

