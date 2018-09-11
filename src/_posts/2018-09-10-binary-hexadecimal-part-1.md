---
layout: page
title: "Binary and Hexadecimal: Part 1"
description: Let's learn to count like a computer!
tags: computer-science basics beginner
cover_image: binary.png
---

There are two reasons why I've seen people avoid learning how binary and hexadecimal number systems work: either they're intimidated because they don't consider themselves "math people," or they think it's a waste because "why am I ever going to need this?"  I really think there are some neat uses to these alternative numbering systems... and they're fun!

I'm definitely going to try to make them as accessible as I can in this post and take all of the intimidation out of them.  You don't need to be a "math person."  As long as you're a "person who can count on their fingers," you'll be OK.  If you don't have fingers, find a friend and use their fingers.  If you don't have fingers and don't have a friend, then today is your lucky day!  Now you've got three friends: Binary, Hexadecimal, and me!  And you can count them on *my* fingers if you want.

## Starting from the Beginning: Decimal

Let's go back to elementary school for a second.  How does counting work?  Well, we have ten shapes we can use to represent values: numbers!

0	1	2	3	4	5	6	7	8	9

Zero through nine is ten digits.  These are the *only* digits we count with -- at least if we're using [Arabic Numerals](https://en.wikipedia.org/wiki/Arabic_numerals).  If you're not using Arabic Numerals but still using the decimal system, you'll still have ten digits available to you.  They might just look a little different.

So how do we count?  We start with the first digit available to us: 0.  Let's count our first time, adding one to our total.  We still have 8 numerals we haven't seen yet, so we move to the next one: 1.  Then 2.  Then 3.  And so on, until we get to 9.  

At that point, we've hit a snag.  We've run out of numerals!  So, what do we do?  We tally that round of counting 10 times by **incrementing a new digit by one** and **resetting that digit to 0.**  Now we're at 10.  And we can start again, stepping through the numerals available to us: 11, 12, 13, 14, 15, 16, 17, 18, 19... Uh oh.  We've completed another round through all of the numerals.  So again, we increment our tally and increment the *second digit*, the one on the left, to mark that fact.  And we reset our right-most digit to zero.

What happens when our *second digit* runs through all of the available numerals: 97, 98, 99... we're getting ready to increment the right-most digit, which means we should be resetting it to zero and incrementing the second digit, but we're out of numerals to use in the second spot.  No problem here either, we'll just add another digit to celebrate that fact!  Now we have a 1 *in the third digit location*: 100.  And so it goes.  Congratulations, you still know how to count.

But, do you see the idea?  We have 10 different numerals the show, and as each digit exhausts the numerals available to it, it increments the digit to the left of it and resets.  That's how the rest of the number systems work -- they just have different amounts of numerals!  With 10 digits, we're using something called the **"Decimal"** (deci- means 10) system.

## So What is Binary Then?

Well, you *might* guess from the name "BI-nary" (bi- meaning two) that there are two available numerals.  And you're right!  You may have even heard before what the two numerals are.  0 and 1.  That's right!  As you can imagine, with significantly fewer numerals, we're going to rack up digits pretty quickly.  Let's try counting in binary now.  I think you're ready.

Don't forget that the same basic rules of counting apply.  We'll start with zero.

0

And then we'll increment to the next available numeral.

1

And then we'll increment to the next available numeral again-- wait.  We're already out of numerals!  What gives!?  That's OK, we follow our counting rules and increment the next digit and reset our current digit.

10

And then we start again.

11

Oop!  Now we go to increment our right-most digit, but we're out of numerals.  So we go to increment our *second* right-most digit, but we're out of numerals there too!  So we continue on to add a new digit and reset our other digits.

100

101

110

111

Can you guess what happens next?

1000!

Now, have you been keeping track of our count?  How many times have we incremented?  I'm going to make a table, and, to make the ones and zeroes easier to see, I'm going to add some zeroes out in front of the number as placeholders.  It's OK, though.  They don't change anything.  The number 000000048 is still 48, right?

|Decimal Number|Increment Number|
|--|--|
|0001|1|
|0010|2|
|0011|3|
|0100|4|
|0101|5|
|0110|6|
|0111|7|
|1000|8|


[This is a neat demonstration.](https://www.reddit.com/r/mechanical_gifs/comments/9cto4l/how_simple_pieces_of_wood_and_hinges_makes_a/)

How does that feel?  You're counting in binary!  You're practically a computer!  Quietly, to yourself, say "bleep bloop."  No one will know.  But we will know.  And it'll make you feel accomplished.  :)

Now, there's one more pattern that you may not have noticed, that makes binary even more magical.  Check out the values of the increment number when there is only *one 1* and everything else is zero:

1, 2, 4, and 8.

Do you see a pattern?  Let me show you some other binary numbers and their decimal equivalents.

|Binary|Decimal  |
|--|--|
|0000 0001|1|
|0000 0010|2|
|0000 0100|4|
|0000 1000|8|
|0001 0000|16|
|0010 0000|32|
|0100 0000|64|
|1000 0000|128|

Don't worry about the space in between the binary digits.  I added it in there to make things easier to read.  Otherwise, if you read binary too long, your eyeballs start to fall out.  The important thing is the *pattern*.  Do you see it?  Every binary number that's just one 1 and the rest 0's is a power of 2.  Or, put another way, the decimal numbers are doubling each time!  That's right, everytime you go up a digit (i.e. shifting things left one place) in binary, you double!

But, when you think about it, it makes sense right?  Let's look at the decimal numbers that are one 1 followed by zeroes.

1
10
100
1000
10000

Each one is the previous one, multiplied by 10, in the **deci-** mal system.  In the **bi-** nary system, every one is the previous one multipled by 2.  Do you see?  Don't worry if not.  We'll do more with that later, and we'll get more practice.

## Hexadecimal Too?

Don't worry.  Now that you've got binary nailed down, **hexa-** (meaning 6) **-deci-** (meaning 10) **mal** should be a snap.  Hexadecimal has a **base** of 16.

*Wait, wait, wait.  There's only 10 numerals.  How are we going to show 16 different "shapes?"  Are we just going to make up new numbers?  I thought you said there wasn't going to be hard math!*

Don't worry.  We're not making up any new shapes, and chances are, you've probably seen hexadecimal out in the wild somewhere.  You're right about one thing, though: we need more "numerals" to get our 16 "shapes."  But, luckily you know these shapes: letters!  That's right, the numerals in hexadecimal are:

0 1 2 3 4 5 6 7 8 9 A B C D E F

(I'll pause while the skeptical among you take the time to count.  There's 16.  I'll wait.)

Satisfied?  Good.  Now let's start counting.

0
1
2
3
4
5
6
7
8
9

What do we do?  Well, we've got more "numerals," right?  We keep going!

A
B
C
D
E
F

Aaaaand now we're out of numerals.  Increment the next digit and reset!

10
11
12
13

And so on.  And when that second digit gets up there after much more counting?

F8
F9
FA
FB
FC
FD
FE
FF...
...
100!

## Intermission

See?  Hopefully that wasn't so terrible.  And you counted in both binary and hexadecimal!  Congratulations!  I now confer upon you the title of budding computer scientist.  We can't really do much useful with this new knowledge yet, though.  In the next post, I'll show you how to convert back and forth, and what cool things that enables us to do.

This can be a tough topic, and I don't want it to be intimidating or scary at all.  If I missed something or it's not quite clicking, my DM's are open!  Shoot me a message and we'll talk about what's bugging you.

Happy counting!