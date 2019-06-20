---
layout: page
title: Seeing Context with `grep`
description: Some neat tricks to help understand where in the file your match is showing up.
tags: bash linux tricks
cover_image: grep-context-cover.png
---

Have you ever searched for some text in a file on the command line only to realize that `grep`'s output isn't quite enough for you to understand what is happening in the file?  Sometimes you want to see some extra lines or even the whole file with your search terms highlighted.

## To See a Few Lines

You can use the -A, -B, and -C flags to see a few lines of context.  `-A <number>` will show "number" lines after each match, `-B <number>` will show "number" lines before a match, and `-C <number>` shows "number" lines both before and after.  It helps to remember **A**fter, **B**efore, and **C**ontext.  `grep -C 5 ...` is equivalent to `grep -A 5 -B 5 ...`.  I actually like to add the `-n` flag as well to show 1-indexed line numbers, because it helps me find the spot in the file later.

Here they are in action:

```txt
# inside example.txt
If you are a dreamer, come in,
If you are a dreamer, a wisher, a liar,
A hope-er, a pray-er, a magic bean buyer…
If you’re a pretender, come sit by my fire
For we have some flax-golden tales to spin.
Come in!
Come in!

- Shel Silverstein
```

```bash
$ grep -A 3 "fire" example.txt
If you’re a pretender, come sit by my fire
For we have some flax-golden tales to spin.
Come in!
Come in!

$ grep -B 2 -n "golden" example.txt
3-A hope-er, a pray-er, a magic bean buyer…
4-If you’re a pretender, come sit by my fire
5:For we have some flax-golden tales to spin.

$ grep -C 1 -n "bean" example.txt
2-If you are a dreamer, a wisher, a liar,
3:A hope-er, a pray-er, a magic bean buyer…
4-If you’re a pretender, come sit by my fire
```

## To See the Whole File

A trick to see the whole file is to match a non-printing character that is in every line, like the line start or end.

```bash
grep -e '^' -e 'magic' example.txt
```

![Results showing the whole file but with the word "magic" highlighted in color.](/img/grep-whole-file.png)

Although, that's abusing `grep` a little bit.  A better way might be to use the neat search functions of `less`.  Run `less example.txt` and then type `/` followed by your search term.  If you type `/magic<Enter>`, you see something like this:

![Less showing the whole file with the word "magic" highlighted.](/img/less-highlight-search.png)

 > Nobody: ...
 > 
 > Vim users: YoU cAn Do ThE sAmE tHiNg In ViM!

*I'm kidding.  I love vim and use this feature all the time.

## But There's No Color on Mine!

There's a `--color` option for grep.  In fact, there's even a `--colour` convenience option for those so inclined!  It can take the values "never", "always", or "auto".  "Auto" will colorize the output if it is being output to a terminal, but drop the colors if the output is getting piped to another command or a file.  This is because the colors are coded as characters right into the output text, and they'll show up in plaintext output files and other programs like `less`.  You'll see a lot of StackOverflow answers recommending `--color=always`, but that will give you those weird color code characters and is not probably what you want.  

So try running:

```bash
grep --color=auto -e '^' -e 'my search term' data.txt
```

If that works, you might consider putting this line in your `.bashrc` file:

```bash
export GREP_COLORS="auto"
```

This will keep you from having to type it every time.
