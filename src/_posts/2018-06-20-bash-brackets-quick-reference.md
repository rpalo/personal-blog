---
layout: page
title: Bash Brackets Quick Reference
description: Bash has lots of brackets and this is a cheat sheet to help you remember which ones to use.
tags: bash shell cheatsheet
cover_image: brackets.jpg
---

*Cover image credit: [Fonts.com](https://www.fonts.com/content/learning/fontology/level-4/fine-typography/braces-and-brackets)*

Bash has lots of different kinds of brackets.  Like, many much lots.  It adds meaning to doubling up different brackets, and a dollar sign in front means something even more different.  *And*, the brackets are used differently than many other languages.  I constantly find myself doing a 5-second search for which one is the right one to do since I'm not writing Bash scripts all the time.  So here, I'm going to lay them all out and then print this article out and staple it to the wall by my desk.  Possibly with a decorative frame.  So here we go.

A tiny note on all of these is that Bash generally likes to see a space between round or square brackets and whatever's inside.  It doesn't like space where curly braces are concerned.  We'll go through in order of net total squigglyness (NTS score).

## ( Single Parentheses )

The first usage for single parenthesis is running commands inside in a **subshell**.  This means that they run through all of the commands inside, and then return a single exit code.  Any variables declared or environment changes will get cleaned up and disappeared.  Because it's within a subshell, if you have it inside a loop, it will run a little slower than if you called the commands *without* the parentheses.

```bash
a='This string'
( a=banana; mkdir $a )
echo $a
# => 'This string'
ls
# => ...
# => banana/
```

The second usage is in declaring arrays.  Now, arrays and associative arrays are only available in newer versions of Bash, and there are a lot of weird edge cases and syntax rules that make it easy to make mistakes using them--so much so that I try to steer Bash newbies clear of their usage unless they're definitely the right tool to use.  But, for completeness's sake:

```bash
cheeses=('cheddar' 'swiss' 'provolone' 'brie')
echo "${cheeses[2]}"
# => swiss
cheeses+='american'
for cheese in $cheeses; do
  echo "$cheese"
done
# => cheddar
# => swiss
# => provolone
# => brie
# => american
```

In the input inside the parentheses, Bash uses the current environment variable `$IFS` (field separator) and will split the array string on any character found in `$IFS`.  So one way you can split a string on a character is something like this:

```bash
grade_string='A;B;F;D;C;A-'
IFS=';' grades=($grade_string)
echo "${grades[1]}"
# => B
echo "${grades[3]}"
# => D
```

There's a whole bunch more to dive into here, and a ton of gotchas to look out for, but that's a whole nother article.  I'll put it on the list of drafts to write.  This should give you enough of a feel to not freak out if you see it in somebody's Bash script, though.  :)

*Thanks Davide for bringing up this use case for parentheses.*

## (( Double Parentheses ))

This is for use in integer arithmetic.  You can perform assignments, logical operations, and mathematic operations like multiplication or modulo inside these parentheses.  However, do note that there is no output.  Any variable changes that happen inside them will stick, but don't expect to be able to assign the result to anything.  If the result inside is **non-zero**, it returns a **zero** (success) exit code.  If the result inside is **zero**, it returns an exit code of **1**.

```bash
i=4
(( i += 3 ))
echo $i
# => 7
(( 4 + 8 ))
# => No Output
echo $?  # Check the exit code of the last command
# => 0
(( 5 - 5 ))
echo $?
# => 1

# Strings inside get considered 'zero'.
(( i += POO ))
echo $i
# => 7

# You can't use it in an expression
a=(( 4 + 1 ))
# => bash: syntax error near unexpected token '('
```

## <( Angle Parentheses )

*Thank you to [Thomas H Jones II](https://dev.to/ferricoxide) for [this comment](https://dev.to/ferricoxide/comment/3pdn) that inspired this section on Process Substitution*

This is known as a *process substitution*.  It's a lot like a pipe, except you can use it anywhere a command expects a file argument.  And you can use multiple at once!

```bash
sort -nr -k 5 <( ls -l /bin ) <( ls -l /usr/bin ) <( ls -l /sbin )

# => Like a billion lines of output that contain many of the
# => executables on your computer, sorted in order of descending size.

# Just in case you don't magically remember all bash flags,
# -nr  means sort numerically in reverse (descending) order
# -k 5 means sort by Kolumn 5.  In this case, for `ls -l`, that is the "file size"
```

This works because the sort command expects one or many filenames as arguments.  Behind the scenes, the `<( stuff )` actually outputs the name of a temporary file (unnamed pipe file) for the `sort` command to use.

Another example of where this comes in handy is the use of the `comm` command, which spits out the lines that the files have in common.  Because `comm` needs its input files to be sorted, you could either do this:

```bash
# The lame way
sort file1 > file1.sorted
sort file2 > file2.sorted
comm -12 file1.sorted file2.sorted
```

Ooooor, you can be a total BAshMF and do it this way:

```bash
# The baller way
comm -12 <( sort file1 ) <( sort file2 )
```

## $( Dollar Single Parentheses )

This is for interpolating a subshell command output into a string.  The command inside gets run inside a subshell, and then any output gets placed into whatever string you're building.

```bash
intro="My name is $( whoami )"
echo $intro
# => My name is ryan

# And just to prove that it's a subshell...
a=5
b=$( a=1000; echo $a )
echo $b
# => 1000
echo $a
# => 5
```

## $( Dollar Single Parentheses Dollar Q )$?

*Shoutout again to [Thomas](https://dev.to/ferricoxide/comment/3pdn) for the tip!*

If you want to interpolate a command, but only the exit code and not the value, this is what you use.

```bash
if [[ $( grep -q PATTERN FILE )$? ]]
then
  echo "Dat pattern was totally in dat file!"
else
  echo "NOPE."
fi
```

Although, really, this isn't so much a special bracket pattern as it is an interesting use of `$?`, since the above works even if there is a space between the `$( stuff )` and the `$?`.  But a neat tip, nonetheless.

However, in Bash, `if` statements will process the `then` branch if the expression after `if` has an exit code of 0 and the `else` branch otherwise, so, in this case, *Matthew* notes that we can drop all of the fancy stuff and simplify to:

```bash
if grep -q PATTERN FILE; then
  echo "Vee haf found eet!"
else
  echo "No.  Lame."
fi
```

## $(( Dollar Double Parentheses ))

Remember how regular **(( Double Parentheses ))** don't output anything?  Remember how that is kind of annoying?  Well, you can use **$(( Dollar Double Parentheses ))** to perform an **Arithmetic Interpolation**, which is just a fancy way of saying, "Place the output result into this string."

```bash
a=$(( 16 + 2 ))
message="I don't want to brag, but I have like $(( a / 2 )) friends."
echo $message
# => I don't want to brag, but I have like 9 friends."

b=$(( a *= 2 ))			# You can even do assignments.  The last value calculated will be the output.
echo $b
# => 36
echo $a
# => 36
```

I *will* remind you that the assignment above is just as possible using plain double parens, as appears in the examples in that section.  *(Thanks to Yaniv Orenstein for flagging the potential for clarification here.)*

```bash
(( a = 16 + 2 ))
```



One thing to remember is that this is strictly integer arithmetic.  No decimals.  Look into [`bc`](https://www.lifewire.com/use-the-bc-calculator-in-scripts-2200588) for floating point calculations.

```bash
echo $(( 9 / 2 ))  # You might expect 4.5
# => 4

echo $(( 9 / 2.5 ))
# => bash: 9 / 2.5 : syntax error: invalid arithmetic operator (error token is ".5 ")
```

## [ Single Square Brackets ]

This is an alternate version of the built-in `test`.  The commands inside are run and checked for "truthiness."  Strings of zero length are false.  Strings of length one or more (even if those characters are whitespace) are true.

[Here are a list of all of the file-related tests you could do](http://tldp.org/LDP/abs/html/fto.html), like checking if a file exists or if it's a directory.

[Here are a list of all of the string-related and integer-related tests you could do](https://www.tldp.org/LDP/abs/html/comparison-ops.html), like checking if two strings are equal or if one is zero-length, or if one number is bigger than another.

```bash
if [ -f my_friends.txt ]
then
	echo "I'm so loved!"
else
	echo "I'm so alone."
fi
```

One last thing that's important to note is that `test` and `[` are actually shell commands.  `[[ ]]` is actually *part of the shell language itself*.  What this means is that the stuff inside of Double Square Brackets isn't treated like arguments.  The reason you would use Single Square Brackets is if you need to do *word splitting* or *filename expansion*.

Here's an illustration of the difference.  Let's say you used Double Square Brackets in the following way.

```bash
[[ -f *.txt ]]
echo $?
# => 1
```

False, there is no file explicitly named "[asterisk].txt".  Let's assume there are currently no `.txt` files in our directory.

```bash
# If there's no files .txt files:
[ -f *.txt ]; echo $?
# => 1
```

`*.txt` gets expanded to a blank string, which is not  a file, and *then* the test gets evaluated.  Let's create a txt file.

```bash
touch cool_beans.txt
# Now there's exactly one .txt file
[ -f *.txt ]; echo $?
# => 0
```

`*.txt` gets expanded to a space-separated list of matching filenames: "cool_beans.txt", and then the test gets evaluated with that one argument.  Since the file exists, the test passes.  But what if there's two files?

```bash
touch i_smell_trouble.txt  # bean pun.  #sorrynotsorry
# Now there's two files
[ -f *.txt ]
# => bash: [: too many arguments.
```

`*.txt` gets expanded to "cool_beans.txt i_smell_trouble.txt", and then the test is evaluated.  Bash counts each of the filenames as an argument, receives 3 arguments instead of the two it was expecting, and blurffs.

Just to hammer my point home: even though there are currently two `.txt` files, this next test still fails.

```bash
[[ -f *.txt ]]; echo $?
# => 1.  There is still no file called *.txt
```

I tried to come up with some examples of why you would want this, but I couldn't come up with realistic ones.  

> For the most part, it seems like, a good rule of thumb is: if you need to use `test` or `[ ]`, you'll know it.  If you're not sure if you need it, you probably don't need it and  you should probably use **[[ double square brackets ]]** to avoid a lot of the tricky gotchas of the `test` command.  If your shell is modern enough to have them.

## [[ Double Square Brackets ]]

True/false testing.  Read through the section above for an explanation of the differences between single and double square brackets.  Additionally, double square brackets support extended regular expression matching.  Use quotes around the second argument to force a raw match instead of a regex match.

```bash
pie=good
[[ $pie =~ d ]]; echo $?
# => 0, it matches the regex!

[[ $pie =~ [aeiou]d ]]; echo $?
# => 0, still matches

[[ $pie =~ [aei]d ]]; echo $?
# => 1, no match

[[ $pie =~ "[aeiou]d" ]]; echo $?
# => 1, no match because there's no literal '[aeoiu]d' inside the word "good"
```

Also, inside double square brackets, `<` and `>` sort by your locale.  Inside single square brackets, it's by your machine's sorting order, which is usually ASCII.

## Function Parens/Braces() { ... }

Functions are a little bit stranger in Bash than many other languages.  First of all, there's several ways to define them, that are all totally equivalent:

```bash
function hi_there() {
  echo "Hi"
}

hi_there() {
  echo "Hi"
}

function hi_there {
  echo "Hi"
}

# All above versions work fine with the C-style brace
# arrangement too.
hi_there()
{
  echo "Hi"
}
```

Every single one of these defines a function called `hi_there`.  The round parentheses are there *solely* for decoration.  In other languages, you might put your expected parameters there.  Not so in Bash.  Bash doesn't give a rat's patootie what you want people to pass your function.  Usually, if people are nice, you'll see the expected parameters named at the top of the function:

```bash
function hi_there() {
  name="$1"
  echo "Hi $name!"
}
```

*Thanks for pointing out that I should probably mention this usage, Robert!*

## { Single Curly Braces }

The first use for single curly braces is expansion.

```bash
echo h{a,e,i,o,u}p
# => hap hep hip hop hup
echo "I am "{cool,great,awesome}
# => I am cool I am great I am awesome

mv friends.txt{,.bak}
# => braces are expanded first, so the command is `mv friends.txt friends.txt.bak`
```

The cool thing is that you can make ranges as well!  With leading zeros!

```bash
echo {01..10}
01 02 03 04 05 06 07 08 09 10
echo {01..10..3}
01 04 07 10
```

They can also be used for grouping commands:

```bash
[[ "$1" == secret ]] && {echo "The fox flies at midnight"; echo "Ssssshhhh..."}
```

These commands are all run together in a block, but no new subshell is started.

*Thanks for reminding me of this usage, Robert!*

## ${dollar braces}

Note that there are no spaces around the contents.  This is for variable interpolation.  You use it when normal string interpolation could get weird

```bash
# I want to say 'bananaification'
fruit=banana
echo $fruitification
# => "" No output, because $fruitification is not a variable.
echo ${fruit}ification
# => bananaification
```

The other thing you can use **${Dollar Braces}** for is variable manipulation.  Here are a few common uses.

Using a default value if the variable isn't defined.

```bash
function hello() {
  echo "Hello, ${1:-World}!"
}
hello Ryan
# => Hello Ryan!
hello
# => Hello World!

function sign_in() {
	name=$1
  echo "Signing in as ${name:-$( whoami )}"
}
sign_in
# => Signing in as ryan
sign_in coolguy
# => Signing in as coolguy
```

Getting the length of a variable.

```bash
name="Ryan"
echo "Your name is ${#name} letters long!"
# => Your name is 4 letters long!
```

Chopping off pieces that match a pattern.

```bash
url=https://assertnotmagic.com/about
echo ${url#*/}     # Remove from the front, matching the pattern */, non-greedy
# => /assertnotmagic.com/about
echo ${url##*/}    # Same, but greedy
# => about
echo ${url%/*}     # Remove from the back, matching the pattern /*, non-greedy
# => https://assertnotmagic.com
echo ${url%%/*}    # Same, but greedy
# => https:/
```

You can uppercase matching letters!

```bash
echo ${url^^a}
# => https://AssertnotmAgic.com/About
```

You can get slices of strings.

```bash
echo ${url:2:5}  # the pattern is ${var:start:len}.  Start is zero-based.
# => tps://
```

You can replace patterns.

```bash
echo ${url/https/ftp}
# => ftp://assertnotmagic.com

# Use a double slash for the first slash to do a global replace
echo ${url//[aeiou]/X}
# => https://XssXrtnXtmXgXc.cXm
```

And, you can use variables indirectly *as the name of other variables*.

```bash
function grades() {
  name=$1
  alice=A
  beth=B
  charles=C
  doofus=D
  echo ${!name}
}

grades alice
# => A
grades doofus
# => D
grades "Valoth the Unforgiving"
# => bash: : bad substitution.   
# There is no variable called Valoth the Unforgiving,
# so it defaults to a blank value.  
# Then, bash looks for a variable with a name of "" and errors out.
```

## <<Double Angle Heredocs

This is how you make multiline strings in Bash (one method).  Two arrows and then a word -- any word that you choose -- to signal the start of the string.  The string doesn't end until you repeat your magic word.

```bash
nice_message=<<MESSAGE
Hi there!  I really like the way you look
when you are teaching newbies things
with empathy and compassion!
You rock!
MESSAGE

echo $nice_message
# => Hi there!  I really like the way you look
# => when you are teaching newbies things
# => with empathy and compassion!
# => You rock!
```

The word can be whatever you want.  I generally end up using "HEREDOC" to make it easier for future me.

One final trick is that, if you add a dash after the arrows, it suppresses any leading tabs (*but not spaces*) in your heredoc.

```bash
cat <<-HEREDOC
        two leading tabs
    one leading tab
  two spaces here
HEREDOC

# => two leading tabs
# => one leading tab
# =>   two spaces here
```

## Punctuation's a Killer

Hopefully this is helpful.  If you see something I missed or have another cool use for one of these variants, be sure to let me know, and I'll update it and publicly praise your genius.  Thanks for reading!