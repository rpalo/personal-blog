---
layout: page
title: Command Not Found... Dum Dum
description: A neat little shell customization feature I found while reading through a Bash book.
tags: bash shell quicktip
cover_image: not-found.jpg
---

Do you know what time it is?  That's right.  It's time for a 

## QUIIIIICK TIP

This tip comes from the [Bash Pocket Reference, 2nd Ed.](https://amzn.to/2t7Fp1i) by Arnold Robbins.

Do you know how Bash (and similar shells) look for commands when you give it a command?  Here's the list:

1. First, it checks to see if what you've typed is a language keyword like `for` or `while`.

2. Next, it checks your aliases.  Interestingly, the book above states (and cites other sources that agree) that you should basically never use aliases!  It says writing a function should almost always be preferred -- contrary to a lot of StackOverflow answers I've seen.  I think I agree, actually.  Writing functions seems much cleaner and easier to come back to and modify later.

3. Then, it checks for special built-in functions like `break`, `exit`, or `export`.  These aren't needed for the internals of the Bash language, necessarily, but they're needed for scripting and interactive shells.

4. After that, it looks at any functions you have defined.

5. Next are non-special built-ins.  These are commands like `cd` and `test`.  Since functions are checked before these, you could feasibly override `cd` with your own function!

```bash
function cd() {
  echo "You're the best!"
  command cd "$@"  # Actually calls the real `cd`
}

$ cd ~/code
# => You're the best!
# Now in ~/code
```

Lastly, it hunts through the `$PATH` to try to find scripts that match.

Here's the tip: if Bash can't find the command you typed in any of these places, it runs a function called `command_not_found_handle`.  Aaaaand, if you so happen to override this function, it will call *your* version instead!

Sooooo, if your terminal experience is just not quite hostile enough, you could feasibly put the following into your `.bash_profile`.

```bash
function command_not_found_handle() {
  options=(
    "no."
    "No!"
    "NO."
    "OMG NO."
    "Mother ****!"
    "WHAT ARE YOU DOING?"
    "Success!  JK, you're still a dum dum."
  )
  option_choice=$(( $RANDOM % 7 ))
  echo "${options[$option_choice]} '$*' command not found."
  # The command that you tried is passed into
  # this function as arguments, so $* will contain
  # the entire command + arguments and options
  
  return 127   # 127 is the canonical exit code for
  						# "command not found" 
}
```

Then, when you open up your terminal, you should see this:

```bash
$ hwaaaa
# => NO. 'hwaaaa' command not found.
$ but why not tho
# => Success!  JK, you're a dum dum.  'but why not tho' command not found.
```

All kidding aside, hopefully, you start to see how you could write some scripts to provide slightly more helpful/friendly error messages that maybe even show some possible options that were close to what you typed?

**Quick Tip Over.**