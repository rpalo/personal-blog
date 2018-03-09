---
layout: page
title: Intro to PowerShell (Especially for People Who Think They Hate PowerShell)
description: Why PowerShell is great, and what you might have missed if you got frustrated and quit because it wasn't Bash.
tags: powershell shell scripting console
cover_image: power.png
---

My relationship with the terminal has been a bit of a roller coaster.  I first discovered the terminal when I first heard about Python and didn't know anything about anything.  I heard about Python in a [a few](https://xkcd.com/353/) different [XKCD comics](https://xkcd.com/844/) and wanted to see what it was.  Like a normal person who used computers for games and applications like Excel and PowerPoint, I went to the site, downloaded the installer, installed it, and clicked the icon.  Imagine, to my horror, when this popped up.

![Python REPL](/img/python-repl.png)

*Where are the buttons?  What's with the old-timey font?  What do I do with my mouse?*

After beginning to program more and more, and learning about the terminal, I began to love Bash.  Is it archaic?  Yes.  Are the commands non-intuitive and difficult to remember?  Heck, yes.  For some reason, this just made me love it more.  I had to work hard at it, and typing a bunch of what appears to be gobbledey-gook (`du -sk * | sort -n | tail`, for example) that had powerful results made me feel like a wizard.  As I learned more, I was able to customize how it looked and get fonts and colors and prompts that made the terminal that much more inviting.

So I decided to take my newly found programming powers to work.  Except that I work as a mechanical engineer, and typically that means Windows and SolidWorks (although that seems to be changing a little bit).  So I opened up the recommended terminal, PowerShell.  And again, to my horror:

![PowerShell Terminal](/img/powershell-1.jpg)

*No problem,* I thought.  I'll just go to the Preferences screen.

![Customizing PowerShell](/img/powershell-customize.png)

Oh, no.  We're not in Kansas anymore.  Not exactly what I was used to.  So I went into powershell and tried to do some simple things.  Some things worked fine!  `ls`, `cd`, and `mkdir` all worked like I was used to.  But I couldn't figure out why setting the `$PATH` was so hard to do.  And what is with all these backslashes?  How come I can't `sudo`?  More and more little irritations that kept reminding me that I *wasn't using Bash* kept cropping up.  I gave up and installed [cygwin](https://www.cygwin.com/), which allowed me to have a bash experience on my Windows 7 computer.  Except not quite.  Everything I tried to do to get back to Bash on my Windows machine was just… not quite right.

Finally, recently, I threw in the towel and began to work on learning PowerShell the right way, from the beginning, as another language.  As I learned, I found myself buying into the whole PowerShell philosophy, and noticing the things that were a little bit nicer than when I was using Bash.  Now, just like everything, PowerShell is just another tool in the toolbox, and whether or not it's the best tool really depends on the situation.  My goal here is to show you the basics and get you started on your own PowerShell journey.

## Intro To PowerShell

There are a mental shifts away from how Bash-like shells do things that you need to make when you're starting to learn PowerShell.  If you can get past your initial gut reaction of disgust when you see these, you might start to see that they actually make you more productive.

I'm not going to spend a lot of time telling you how to install PowerShell.  [This set of docs](https://github.com/PowerShell/PowerShell/tree/master/docs/learning-powershell) is fairly comprehensive, and it's actually also a good cheat sheet for reference later.

This guide will assume that you're already familiar with some form of shell usage basics (most likely Bash).

### Everything Is An Object

This is probably the biggest difference that you have to get through your head.  In Unix shells, everything is plain text.  This makes things nice, because you can expect text input into all of your scripts, and you can know that if you output text, everything will probably be OK.  However, the downside is that this makes inspecting specific data a nightmare of text parsing and it makes working with anything other than text (floating point numbers, anyone?) a real pain.

In PowerShell, which is actually built on top of .NET, everything is an object.  This will feel very comforting if you're coming from a Python, Ruby, JavaScript, or similar language background.  Let's see some examples and get our hands dirty.  Open up your powershell interpreter.

```powershell
Get-Process
```

You should see a pretty long string of text.  We don't have to stand for that!  We're terminal folk!  Try this:

```powershell
Get-Process | Sort-Object CPU -descending | Select-Object -first 10
```

Now you should see a shorter list, reverse sorted by CPU time.  If you're already getting itchy because all of these commands and options are so long, skip ahead to [the next section](#predictable-command-structure).  Or be patient and stay with me.

The important thing to pay attention to here is the headers a the top of each column.  Each row of this table is actually a `System.Diagnostics.Process` *object*, not just a row of a table.  Don't believe me?  Just check!

```powershell
(Get-Process)[0] | Get-TypeData
```

See there, the `Get-Process` command returned a list of `Process` objects, and we were able to select the first one through indexing (without splitting the output by \n!) and shuffle that through the `Get-TypeData` command.  These items being objects gives us some power.  What if we only wanted their `ProcessName`?

```powershell
Get-Process | Sort-Object CPU -descending | Select-Object ProcessName -first 10
```

See how easy it was to access that?  We didn't have to cut the fields delimited by tabs or colons and count which field we wanted (1… 2… 3… 4… 5!).  We just told it that we wanted the `ProcessName` attribute!  No more parsing, splitting, joining, formatting output, etc.

### Predictable Command Structure

This was one of the first things I noticed when I started using powershell 

### Objects Have Types



### Some Useful Commands to Get Started





## Just Tell Me How to Do the Thing!

### Basic Unix Commands Translated



### Access the Path (And Other Environment Variables)



### Customize My Profile

### Get It To Not Look Ugly

### Install It on Not Windows



### Find More Resources



