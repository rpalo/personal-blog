---
layout: page
title: Handling Arguments in Bash Scripts
description: Some basic tricks using built-in variables to add some extra power to your Bash scripts.
tags: bash scripting beginner
cover_image: bash-arguments.png
---

Using Bash scripts to automate a set of commands is the first step in a journey of building tools and making your life easier.  Simple, top-to-bottom scripts that run the same way each time are powerful, and can save you time.  There will come a point, though, when you want to customize the behavior of your script on the fly: making directories with custom names, downloading files from specific git repositories, specifying IP addresses or ports, and more.  That's where **script arguments** come in.

## Built-In Variables

Bash provides us with some variables that are present in any script you write.  Here are a few of the most useful:

### `$1, $2, $3, ...`: Positional Arguments

These are *positional arguments*.  They hold the arguments given after your script as it was run on the command line.  For example, if you have a script that gets run like this:

```bash
$ ./my_script 200 goats
```

The variable `$1` will hold the value `"200"`, and the variable `$2` will hold the value `"goats"`.

For example, I use positional arguments in one of my simplest scripts, but it's one that I run almost every day at work (simplified for the moment):

```bash
#!/usr/bin/env bash

project_name="$1"

mkdir -p "${project_name}/{CAD,drawings,mold,resources}"

echo "New project '$project_name' created!"
```

Do you see how I took the special variable `$1` and stored its value in an actual *named* variable?  You don't need to do that, necessarily.  I could have said `mkdir -p "$1/{CAD,drawings,mold,resources}"` and everything would still work fine.  However, I like to store positional arguments into named variables near the top of my script so that anyone who reads my script will have an idea of what the script is expecting.  Granted, it's no substitute for good documentation and robust error handling, but it's a nice little self-documenting readability bonus that helps out a little.  It's definitely a good practice to get into.

When I run it like this:

```bash
$ new_project "catheter-01"
```

It generates the directory structure:

```txt
- catheter-01
|- CAD
|- drawings
|- mold
|- resources
```

### `$0`: The Script Name

This provides the script name as it was called.  This is a nice shortcut that's especially helpful for things like outputting usage messages and help.

```bash
#!/usr/bin/env bash

function usage() {
  echo "Usage: $0 <name> [options]"
}

# Error handling omitted (for now)

if [[ "$1" == -h ]]; then
  usage
  exit 0
fi

name="$1"
echo "Hello, ${name}!"
```

Then, we can run it like this:

```bash
$ ./greeting -h
Usage: ./greeting <name> [options]

$ bash greeting -h
Usage: greeting <name> [options]

$ ./greeting "Ryan"
Hello, Ryan!
```

### `$#`: Argument Count

This one is great for error handling.  What happens when our script doesn't get the arguments it needs?  Let's update the greeting script above with some error handling.

```bash
#!/usr/bin/env bash

function usage() {
  echo "Usage: $0 <name> [options]"
}

### Hot new error handling!
# We expect one argument.  Otherwise tell the user how to
# call your script.
if [[ "$#" -ne 1 ]]; then
  usage
  exit 1
fi

if [[ "$1" == -h ]]; then
  usage
  exit 0
fi

name="$1"
echo "Hello, ${name}!"
```

### `$?`: Most Recent Exit Code

I don't personally use this one all that much in scripts, but I *do* use it on the command line a lot.  A lot of commands don't even give any output when they fail.  They just do nothing.  So how do you know if it failed?  The exit code of the last command run gets stored in the `$?` variable.

```bash
$ ls
test.txt	code	strudel.py
$ echo $?
0
$ ls lamedir
ls: cannot access 'lamedir': No such file or directory
$ echo $?
2
```

Here's an in-script example:

```bash
#!/usr/bin/env bash

dirname="$1"

mkdir "$dirname"  # This will fail if the directory exists already

if [[ "$?" -ne 0 ]]; then
  # If the directory is already created, that's fine
  # just print out a message to alert the user
  echo "Directory '$dirname' already exists.  Not making a new one."
fi
```

### `$@ and $*`: All the Args

These variables seem to cause the most confusion in Bash newbies—and reasonably so!  They do *almost* exactly the same thing, but the differences can be a big deal depending on your situation.  Here's the low-down.

When you *don't* quote these variables, they both do the same thing, dropping all of the arguments provided in at that location.

```bash
#!/usr/bin/env bash

echo "===================="
echo "This is dollar star."
echo "===================="
for arg in $*; do
  echo "$arg"
done

echo "===================="
echo "This is dollar at."
echo "===================="
for arg in $@; do
	echo "$arg"
done
```

Running this:

```bash
$ ./arg_printer abba dabba "dooby doo"
====================
This is dollar star.
====================
abba
dabba
dooby
doo
====================
This is dollar at.
====================
abba
dabba
dooby
doo
```

See how even the quoted argument got split up on spaces?  Sometimes this is what you want, but very often it is not.  The quoted version of these variables is where things get interesting.

When you quote `$*`, it will output all of the arguments received as one single string, separated by a space[^1] regardless of how they were quoted going in, but it will quote that string so that it doesn't get split up later.

```bash
#!/usr/bin/env bash

echo "===================="
echo "This is quoted dollar star."
echo "===================="
for arg in "$*"; do
  echo "$arg"
done
```

Running it:

```bash
$ ./arg_printer abba dabba "dooby doo"
====================
This is quoted dollar star.
====================
abba dabba dooby doo
```

See?  One argument!  You want to implement `echo` ourselves?

```bash
#!/usr/bin/env bash

printf '%s\n' "$*"
```

```bash
$ ./my_echo hello my name is Ryan
hello my name is Ryan
```

Neat, right?

In contrast, when you quote `$@`, Bash will go through and quote each argument as they were given originally.  This is probably the most useful version, in my opinion, because it lets you pass all the arguments to sub-commands while still retaining spaces and quotes exactly how they were without letting Bash's automatic string splitting muck things up.

```bash
#!/usr/bin/env bash

echo "===================="
echo "This is quoted dollar at."
echo "===================="
for arg in "$@"; do
  echo "$arg"
done
```

```bash
$ ./arg_printer abba dabba "dooby doo"
====================
This is quoted dollar at.
====================
abba
dabba
dooby doo
```

You'll see this one a lot in scripts that have a ton of functions.  It's traditional, if you've got lots of functions, to make the last function in the script a `main` function that handles all the arguments and contains the orchestration logic of the script.  Then, in order to run the main function, typically, the last line of the script is `main "$@"`.  Thus:

```bash
#!/usr/bin/env bash

function usage() {
  echo "Usage: $0 <first> <second> [options]"
}

function bigger() {
  local first="$1"
  local second="$2"
  if [[ "$first" -gt "$second" ]]; then
    echo "$first"
  else
  	echo "$second"
  fi
}

function main() {
  if [[ "$#" -ne 2 ]]; then
  	usage
  	exit 1
  fi
  
  local first="$1"
  local second="$2"
  bigger "$first" "$second"
}

main "$@"
```

## Looking Forward: Fancier Args

Hopefully now, you're starting to feel the power of customization.  You can abstract some tasks away using Bash scripts, even if they contain situationally specific logic, because you can provide arguments at call time!  But this is just the tip of the iceberg.  If you've been around the command-line long, you've probably seen some commands that have oodles of flags, options, settings, and subcommands that all need processed, and doing it with simple positional arguments won't be powerful enough to get the job done.

I'll have another post ready soon that goes over fancier argument parsing: how to handle many arguments, flags, `getops`, `shift`, STDIN, and more.

[^1]: Technically, separated by an [IFS](https://bash.cyberciti.biz/guide/$IFS).  Usually, that's a space, but it's good to know for times when that's not the case.