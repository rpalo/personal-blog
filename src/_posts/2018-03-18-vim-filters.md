---
layout: page
title: Vim Filters
description: A quick Vim tip to run an external command on a file.
tags: vim tricks
cover_image: filter.jpg
---

Quick tip time!  Let's talk about Vim filters.  This is a way to execute any external command and pipe the results into your current buffer.  This is a great way to get the power of your shell into vim without having to learn much VimScript.  Here are the basics:

## Reading command input into the current buffer

This is the simplest method:

```vim
:r !ls
```

This command will read the results of `ls` into your buffer at your cursor location.  You can also specify the specific line to insert after.  The next command will read the results of the `ls` command into your current buffer after line 4.

```vim
:4r !ls
```

## Sending buffer contents as input to an external command

You can also send lines of your buffer out to be replaced with the results of the command.  A common thing to do is to operate on the whole buffer you're working on.

```vim
:%!sort
```

The `%` selects the whole buffer, and then the `!` sends the selected lines out to the external `sort` command.  The whole buffer contents will be replaced with the results of the command.

For example.  Let's say you're working on a text file.

```markdown
# Attention, Everyone!

This markdown file contains some **pretty interesting** stuff.

I __mean__ it.
```

But something's just not quite there.  It needs some more zoom -- some more whammy!  Try combining it with a [slick Ruby one liner!](https://assertnotmagic.com/2017/10/05/smooth-one-liners/)

```vim
:%!ruby -ne 'puts $_.upcase'
```

And suddenly, the contents of your buffer is:

```markdown
# ATTENTION, EVERYONE

THIS MARKDOWN FILE CONTAINS SOME **PRETTY INTERESTING** STUFF.

I __MEAN__ IT.
```

This will work with any command.  You can use shell commands, or you can run it through a Python or Node script.  It gives you the power to select the best (or your favorite) tool for the job, instead of locking you into Vim's capabilities alone.  And you can use other motions if you just want to replace a portion of your buffer.

```vim
:!!ruby -ne 'puts $_.upcase'
```

Two exclamation points will operate on the current line.

It also works on visually selected lines.  Select a couple lines in visual mode:

```vim
v         " Visual mode activated
jj        " Select next two lines
:!sort    " Sorts the lines that were selected.
```

*Protip: If you accidentally run a command and blow away your file somehow, don't panic.  Simply press `u` in Normal mode to undo the operation.*

Hope this comes in handy!