---
layout: page
title: Java Programs, Packages, and Class Paths Explained… Plus a Bonus Mystery
description: In the midst of trying to figure out how projects work in Java and how to run my darn code, I run into an error that makes me doubt everything I'd learned.
tags:
- java
- bash
---

It was a dark and stormy night…

Actually, strike that.  It was a Tuesday and it was lunch time.  I was working through some of Part Two of [Crafting Interpreters](http://craftinginterpreters.com/)by Bob Nystrom.  It’s amazing, and really interesting, and he walks you through building a fully functional programming language—twice!  In part two, you build this language, Lox, in Java as a tree-walking interpreter.  In Part Three, you turn around and build it *again* in C, taking over the memory management responsibilities and writing it as a bytecode interpreter.

Anyways.  Back to the mystery.

I am not a Java programmer.  I’ve had to write it a couple times in my Computer Science classes, and luckily, the syntax is verbose/conversational enough that I’ve been able to hand-wave my way through with some really strong Googling skills.  My background is in Python, Ruby, JavaScript, and Bash.  Needless to say, the first time I went to run this small, but still multi-file, project, it was not quite as simple as running `java lox.java` in the terminal.

## Part 1: The Groundwork

### Basic Java Usage

See, in Java, each source file (with a .java extension) contains one class.  As in, object-oriented class.  Even your main program that does something is a class with, at the very minimum, a `main` method.  Even if you know nothing about Java, you may have heard the phrase `public static void main` uttered in passing by a Computer Science student who hasn’t had enough sleep.  This is why the files usually actually are named with upper-case letters, `Lox.java`, as opposed to `lox.java`.  And each of these .java files that are one class per file get compiled into binary files with a .class extension via the `javac` command.

```bash
javac Lox.java
```

This .class file is what actually gets run when you want to actually *run* your code:

```bash
java Lox  # Note: no .class, no .java extension for this.
```

And when you have multiple source files, everything works magically hunky-dory as long as everything is all piled into the same directory.  You can reference other classes from other files as if they are in the same package (more on that in a minute) by just using their contents.  For example, if you’ve got a Builder class and a Manager class in the same package, then, in your Manager class code, you can use:

```java
Builder bob = new Builder("Bob", 42);
```

And Java will know about it like magic without having to “import” it.

### Packages

Java projects are combined into “packages” that are mirrored by directories on your system.  You’ll see lines at the top of projects that look something like this:

```java
package com.assertnotmagic.decepticon;
```

This will be mirrored by a directory structure somewhere on your system that looks like:

```Plaintext
some_parent_dir
|--com
|  |--outsidesource
|  |--othersource
|  |--assertnotmagic
|     |--autobot
|     |--otherproject
|     |--decepticon
|        |--Megatron.java
|        |--Starscream.java
|        |--Barricade.java
|--org
   |--apache
      |--acrobatmaybe
```

The recommended way to name your packages is to make sure they are globally (as in “the entire world”) uniquely named.  The way most people/companies manage this is by using a reversed version of their internet domain name to prefix their packages.  So, for example, since the Apache Foundation is actually at apache.org, you can see them in a totally separate second-level directory.

### Classpaths

So how does the `java` command know where to find the relevant packages and their class files?  Well, if you’re just working with a pile of Java files all in a single directory, then you don’t have to give it another thought.  Java defaults to searching your current directory for any classes it needs.  But if you want to point it somewhere else, you have a couple of options:

1. Use the `-cp|--classpath` option when running the `java` and `javac` commands from the command line.
2. Set the `CLASSPATH` environment variable.

### Output Directories

By default, when you run `javac`, it stores the .class file right alongside your .java source code file.  This may be fine.  Or you may decide that all these class files are cluttering up your workspace.  Luckily, `javac` has an option to override the default output directory: `-d`.  Using the `-d` flag with a new directory as an argument will let you output .class files wherever you want.

## Part 2: The Mystery

So back to the mystery that made me bash my head against my desk for way too long.  See if you can spot my mistake before I get to the end.

----

As I’m figuring out all of these pieces, I decided for myself that I wanted to move the .class files out into a separate directory to clean up my working tree.  Also, I decided that I was tired of typing so many long arguments to the `java` and `javac` commands.  Also, I my favorite thing about the command line is making small changes to make your experience better all the time.  And so, my initial project structure looked like this:

```Plaintext
|--code
   |--com
      |--assertnotmagic
         |--lox
            |--Parser.java
            |--Parser.class
            |--Interpreter.java
            |--Interpreter.class
            |--Lox.java
            |--Lox.class
```

And I wanted a structure more like this:

```Plaintext
|--code  <== Current Directory
|  |--com
|  |  |--assertnotmagic
|  |     |--lox
|  |        |--Parser.java
|  |        |--Interpreter.java
|  |        |--Lox.java
|  |--bin
|     |--build  # To replace javac +ARGS
|     |--run    # To replace java +ARGS
|     |--lox    # To easily do build+run Lox
|--java-build
   |--com
      |--assertnotmagic
         |--lox
            |--Parser.class
            |--Interpreter.class
            |--Lox.class
```

And so I set to preparing my scripts:

```bash
#!/usr/bin/env bash

# bin/build

javac -d /home/ryan/java-build/ "$1"
```

```bash
#!/usr/bin/env bash

# bin/run

java -cp /home/ryan/java-build/ "$*"   # passes all args thru
```

```bash
#!/usr/bin/env bash

# bin/lox

bin/build /home/ryan/code/com/assertnotmagic/lox/Lox.java
bin/run com.assertnotmagic.lox.Lox "$*"
```

And so (after `chmod`-ing my scripts to let them run), feeling very clever and proud of myself for how many keystrokes I’d saved, I kicked off my script to interpret a file written in Lox.

```bash
$ bin/lox example.lox
Error: Could not find or load main class com.assertnotmagic.lox.Lox example.lox
```

GAH!  What??  I had just spent all this time and effort painstakingly researching how packages and class paths and `java`and `javac` work!  I had done… like… four Google searches!

And so I searched.  And I read.  And I debugged.  For an embarrassingly long time.  Until I found it.

Do you see it?  It has absolutely nothing to do with Java or class paths or anything.

`$*`.  That’s right.  Dolla.  Starr.

In a Bash script, if you quote `"$*"` inside double quotes, it will output all of the command line arguments separated by spaces, with the whole thing wrapped in one big set of quotes.  So, when I was running `bin/lox example.lox`, the run script was expanding that to:

```bash
java -cp /home/ryan/java-build/ 'com.assertnotmagic.lox.Lox example.lox'
```

And *ooooobviously* there’s no .class file named `com/assertnotmagic/lox/Lox example/lox.class` now, is there?

What I *really* wanted was Dolla Starr’s more productive and useful older sibling, MC Quoted Dolla Att: `"$@"`.  When `$@` is inside double quotes, Bash expands that to each command line arg, separated by spaces, and each wrapped inside its own quotes.  So:

```bash
java -cp /home/ryan/java-build "$@"
```

Gets expanded (correctly) to:

```bash
java -cp /home/ryan/java-build 'com.assertnotmagic.lox.Lox' 'example.lox'
```

And, at this point, Java would (correctly) run the `Lox` binary and pass it the argument `'example.lox'`, which it will use to read in the file and interpret it.

Thanks for nothing, Dolla Starr.

But, on the bright side, now I know the Java pathing and packaging situation a lot better.  And you do too!
