# Bash Functions Primer

If your Bash script is just a few lines of automated shell commands to make your life easier, leaving them in the script to be read top-to-bottom is a fine way to do things.  It documents your process, improves consistency, and reduces the amount of errors that you make typing them by hand each time.  But what happens when your script gets a little longer, or you find yourself repeating yourself, or you start to notice chunks of related functionality that could be abstracted and re-used?  What happens when you've got custom functionality that you'd like to turn into "commands" you can use from the command line?

That's where functions come in.  But, in Bash, because of the way arguments and return values are handled, it's not immediately obvious what the *right* way to do these things are -- the way that you might want to do them in a more robust language like Python or Ruby.

This article should help you get started using functions in Bash to power up your scripts and vastly improve readability.

## The Basics: Defining a Function

At its core, a function is just a named section of code that can be re-used by invoking its name.  It can be defined two different ways:

```bash
function hello() {
    echo "Hello, world!"
}

# Or, without the keyword

hello() {
    echo "Hello, world!"
}

# First brace on the next line, C-style, is OK too if you're one of *those* people
# (I'm kidding.  It's fine.  Whatever floats your boat.)
hello()
{
    echo "Hello, world!"
}
```

The keyword `function` (optional), the function name, a pair of parentheses to signal that it's a function (they don't get used for anything), and then the block inside the braces.  The first defining brace can go on the next line after the function

Personally, I like the first way.  Some C programmers might be more used to the second form.  Like a lot of trade-offs in Bash, you give up a little bit of readability, but you gain a little bit of portability.

So, what can we use this for?  Well, maybe there's a big chunk of text that you'd like to be able to echo at different points in your script.  Like a "usage" message!

```bash
function usage() {
	echo
    echo "My Cool Function"
    echo
    echo "Usage:"
    echo "  $0 <name> <age>"
    echo
    echo "Options:"
    echo "  -h --help	Show this screen"
    echo
}
```

*Yes, you could achieve a multiline string with one echo and a heredoc.  I like this way.  Live your best life.*

Note the `$0`.  It stores the name of the script as it was called.  It's a slick way of not having to remember what you named your script!  If they run `bash cool_script.sh`, they'll see `cool_script.sh <name> <age>`.  If they run `./cool_script.sh`, they'll see `./cool_script.sh <name> <age>`.

We can then use our function like this!

```bash
function usage() {
    # ... 
}

# We'll check if the user gave us two arguments, like we expect.
# If not, we'll shoot them the help message and move on.
# Functions are called by writing their name, like any other command.
if [[ "$#" -ne 2 ]]; then
  usage
  exit 1
fi
```

## Passing Arguments

A function that echoes things is all fine and good, but we can't do anything *super* powerful unless we can pass it values to work on.  So how do we do that?  As it turns out, there are a few ways that all work.

### Option 1: Global Variables

That's right, the big Global.  Essentially, by default, variables are global in Bash.  So this works just fine.

```bash
name="Jim"

function hello() {
    echo "Hello, $name!"
}

hello
# => Hello, Jim!
```

However, the same issues global variables create in other languages are present here.  Because your value is defined somewhere else (and possibly a bunch of other places), it can be hard to reason about where that value is coming from and can cause a lot of sneaky bugs.  For this reason, [Google's Bash style guide](https://google.github.io/styleguide/shell.xml#Function_Comments) recommends a special section in your function documentation comments for which global variables you expect:

```bash
##
# Says hello to our favorite person
# Globals:
# 	FAVORITE_NAME
# Arguments:
# 	None
# Returns:
#	None
##
function hello() {
    echo "Hello, $FAVORITE_NAME"
}
```

### Option 2: Positional Parameters

For individual values that affect how your function operates, this is my go-to strategy.  It's the most similar to what you would want to do in other programming languages.  Functions actually operate just like mini-scripts themselves!  In the same way that you can look for `$1, $2, $3...` and `$@` or `$*` in your main script, each function has its own versions of these values.

```bash
# Says hello to a friend
function hello() {
	echo "Hello, $1"    
}

hello "Barb"
# => Hello, Barb

```

If you want to be extra good to future-you and anyone else who has to read your scripts, it's a good idea to name the parameters you expect at the top of your function.  And, for extra safety avoiding variable name collisions, using a declaration like `local` or `declare` is also a good idea.

```bash
# Says hello to a friend, but better!
function hello() {
    local name="$1"
    echo "Hello, $name"
}

hello "Donkey Kong"
# => Hello, Donkey Kong
```

*But Ryan, other languages have default parameters!  Bash is so lame; you can't do that!*

As it turns out, Bash is not lame, and you *can* do that!

```bash
# Says hello to a friend, but, like, amazingly!
function hello() {
    local name="${1:-World}"  # If no argument 1 was passed, we'll use the string 'World'!
    echo "Hello, $name"
}

hello "dat boi"
# => Hello, dat boi
hello
# => Hello, World
```

There's actually a lot of cool things you can do with parameters in Bash.  [Check out this documentation for more!](https://www.tldp.org/LDP/abs/html/parameter-substitution.html)

### Option 3: STDIN

Working with STDIN is not quite as easy as parameters, but it can be really powerful for modifying streams of text, and it allows you to use your own functions in pipelines!  You can also do some sneaky things like using it to process inputs character by character.

Remember how functions had their own set of arguments like mini-scripts?  As it turns out, they have their own input and output streams too!  So, the same way you'd receive STDIN and send to STDOUT in your main script is how you do it inside functions.

Primarily, STDIN can be accessed through `read`.

```bash
# Inside words.txt
bibble
bobble
SNEEBLE
Snort

# Inside shout.sh
function shout() {
    while read -r line; do
    	echo "${line^^}"
    	# Or, if you're a portability nut:
    	# echo "$line" | tr [:lower:] [:upper:]
    done
}

cat words.txt | shout
# => BIBBLE
# => BOBBLE
# => SNEEBLE
# => SNORT

```

`read` is a really powerful built-in Bash command.  By default it asks the user for a line of input, but if you redirect STDIN via arrows or a pipe, it will read from whatever's in the pipeline.  The documentation recommends that you include the `-r` flag essentially all the time, as it normalizes how Bash deals with escaped characters in your stream, and stops some really sneaky bugs.  In my head, it stands for `raw`.  The last argument to `read` (in this case, `line`) is the name of the variable where read will store its result.  You should definitely check out the [official docs for `read`]() because there are a lot of cool options.  My personal favorite is `-c`, which specifies how many characters to read.  Using `read -r -c1 char` is a neat way to parse through a string one character at a time.  You can combine this ability with a `herestring` (a string passed in via STDIN) for extra power!

```bash
function chars() {
    while read -r -c1 char; do
    	echo "$char"
    done
}

chars <<< "banana"
# => b
# => a
# => n
# => a
# => n
# => a

echo "banana" | chars | shout
# => B
# => A
# => N
# => A
# => N
# => A

# Behold the power!  Cool, right?
```

## Returning Values

OK!  We've now got the ability to send values to a function, but how do we get values back?  Once again, there are a few ways.  In this case, though, I've got a clear favorite, but I'll show you all of them anyways.  Knowledge is power, and those other ways have their strengths sometimes.

### Option 0 (Not a Great Idea): Exit Codes

Unfortunately, the first tool you might reach for is also not a great way to handle this issue.  Bash *does* have a `return` keyword, but it doesn't work quite how you might think.  In Bash, the `return` keyword functions exactly like the `exit` keyword.  The only difference is that `exit` kills your whole script/subshell and `return` simply "exits" out of the function.  You can (and *should!*) use this to signal whether or not your function has succeeded or failed, but it's not a good idea to try to return actual *values* to be operated on.  That's because `return` can only return integers—and only integers between 0 and 255!  Typically, `return 0` will signify that everything went fine with your function, and `return 1` or [any other of the semantic return codes]() will signify some kind of failure.

The cool thing is that you can use this value to create **boolean functions**.  Any function you use after an `if` keyword can cause the `then` branch to be run if it returns 0 and the `else` branch to be run if it returns anything else (failure).

```bash
function is_good_dog() {
    return 0   # They're all good dogs, bront.
}

my_dog="Willy"
if is_good_dog $my_dog; then
	echo "Yes, $my_dog is a *very* good boy."
else
	echo "Aw."
fi
# => "Yes, Willy is a *very* good boy."

function is_even() {
	local number="$1"
    if (( number % 2 == 0 )); then
    	return 0
    else
    	return 1
    fi
}

my_age=27 	# Or not.  You'll never know.
if is_even "$my_age"; then
	echo "Even!"
else
	echo "I can't even."
fi
# => "I can't even."
```

In fact, if you choose *not* to use the `return` keyword, your function will implicitly return the return code of the last command in your function.  For a lot of functions that end up `echoing` something, this works out well, because `echo` mostly has a 0 exit code.  But, it *also* means that for functions that are basically just wrappers around `if` statements, you can shorten things up quite a bit.  Let's rewrite the function above, `is_even`.

```bash
function is_even() {
    local number="$1"
    (( number % 2 == 0 ))
}
```

The arithmetic test exits with an exit code of 0 if the comparison inside is true.  It exits with a return code of 1 if the comparison is false.  Since this is exactly what we need, we can leave out the wordy "if 'comparison' then return 0 else return 1" construct.