---
title: 'Binary and Hexadecimal: Part 2 - Conversions'
layout: page
date: 2018-09-16 18:22:19 +0000
description: The second part of the binary/hexadecimal articles.  Learn to convert
  between decimal, hex, and binary!
tags:
- computer-science
- basics
- beginner
cover_image: hex.jpg

---
In the last artical, we discovered the sheer joy of counting in *two* -- count 'em, two! -- new number systems: Binary and Hexadecimal.

But just being able to count is only the first step.  To truly unlock the power of these number systems, you've got to be able to convert between them.  In the event that you know how to use a search engine, then you already know how to type 'convert 11001 to decimal.'  But, for quick conversions (and for the fun of it), it's good to know how it all fits together.

## A Note on Notation

Sometimes you might see people denote binary numbers starting with `0b`, as in `0b11011101`.  This is just to clue you in to what kind of number you're looking at.  If you're looking at a hex number, it might start with `0x` as in `0xFCDE23`.

## Binary -> Decimal

If you remember, in the last article, we talked about how the digits in binary represent **powers of two**.  Here's a nice table to remind you:

| Digit (Power of 2) |   7   |  6    |  5    |   4   |   3   |  2    |   1   |   0   |
| ----- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
|Decimal Value|  128    |   64   |  32    |   16   |  8 | 4 |2   |1   |

So, when you come across a binary number, all you have to do is figure out the decimal value of each digit and add up the total!  Let's say you were converting the binary number `1101 0011`.

|Binary Digit| 1 | 1 | 0 | 1 | 0 | 0 | 1 | 1 | TOTAL |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
|Decimal Value| 128 | 64 | 0 | 16 | 0 | 0 | 2 | 1 | 211 |

That's right!  `1101 0011` in binary is equal to `211` in decimal.  If you get confused about the value of a particular digit, one way to figure it out is to lay out a list of numbers on a piece of paper, starting from the right and going left.  Start with 1, and double each next digit.  One doubled is two, two doubled is four, four doubled is 8, etc.

```
128 <- 64 <- 32 <- 16 <- 8 <- 4 <- 2 <- 1
```

And then take a look at the binary number you have.  Anywhere there's a zero, cross that number out!

```
128 <- 64 <- XX <- 16 <- XX <- XX <- 2 <- 1
```

Now you can add up whatever's left.

## Decimal to Binary

To go from decimal to binary is a little harder to do.  There are a couple of different ways to do it.  I'll give you both ways, and you can decide if there's one that you like better.

### The Subtraction Method

I personally like this method better.  It fits better with my brain.  This version works well if you can remember the powers of two pretty well.  Keep in mind that we'll be filling in the binary digits from left (biggest) to right (smallest).  I'll give you a step-by-step guide, and pair it with an example.  It works like this:

1. Start with the number you want to convert.  We'll use the same 211 that we used in the last section so we can check our work.
2. Find the **biggest** power of two that is **less than** the number to convert.  In this case, 256 (2^8) is too big.  128 (2^7), though, is less than 211, so that's just right.
3. Mark a 1 on the piece of paper (or screen) for that power of two.
4. **Subtract** that power of two (128) from your main number.  In this case the result is 211 - 128 = 83.
5. Step down by one power of two.  2^6 is 64.  If 64 **is less than** the current value (it is), mark a 1 for that power of two and subtract again.  For the example, we'll mark 1 and get 83 - 64 =  19.
6. Carry on down the powers of two.  For any powers, if the power is **greater than** your current number (so that you can't subtract and get a positive result), mark a zero for that power and don't subtract anything.  Move on to the next power of two.  In our example, 32 is the next power of two, and it's bigger than 19.  So, mark a zero and move on.
7. The next power of two is 16, which is smaller than 19.  So mark a 1 and do 19 - 16 = 3.
8. Next is 8.  8 is bigger than 3, so mark a zero and don't subtract.
9. Next is 4.  4 is bigger than 3, so mark a zero and don't subtract.
10. Next is 2.  2 is less than 3, so mark a 1 and subtract: 3 - 2 = 1.
11. Next is 1.  1 is equal to 1, so mark a 1 and subtract: 1 - 1 = 0.
12. Once you get to zero, stop!  You're done.  Take a look at your marks.  You should have:

```
1 1 0 1 0 0 1 1
```

Does this match what we had in the section above?  Yes!  Success!

If this way doesn't seem like it makes much sense, that's totally fine.  There's one more way that doesn't require you to remember the powers of 2.

### The Other Way: Division

For this method, we're filling in binary digits from **right (smallest) to left (biggest)**.  We'll use 211 again.  For each of these calculations, we'll be dividing by 2 (floor division with a remainder).  Be sure to keep track of the result value *and* the remainder for each one.  The remainder represents the binary digit, and the result value is what we'll use for the next round of calculations.  Here we go:

1. Start with your number.  Divide by 2.  Is there a remainder of 1?  If so, mark 1.  Otherwise, mark 0.  In our case, 211 / 2 = 105, remainder 1.  So, we remember 105, and we mark a 1.
2. Repeat.  105 / 2 = 52, remainder 1.  Remember 52, mark a 1.
3. 52 / 2 = 26, remainder 0.  Remember 26, mark a 0.
4. 26 / 2 = 13, remainder 0.  Remember 13, mark a 0.
5. 13 / 2 = 6, remainder 1.  Remember 6, mark a 1.
6. 6 / 2 = 3, remainder 0.  Remember 3, mark a 0.
7. 3 / 2 = 1, remainder 1.  Remember 1, mark a 1.
8. 1 / 2 = 0, remainder 1.  Mark a 1, and we're done!

All together (again, from **right to left this time**), our binary digits are:

```
1 1 0 1 0 0 1 1
```

And again we have **SWEET SWEET VICTORY!**

## Hexadecimal to Decimal

The really cool thing about this is that you *already know how to do this one* -- you just don't know it yet.  It's the same as the binary-to-decimal conversion.  Each place has a value, and you add up all the digits!  This time, though, each place is a power of 16.  Honestly, for hexadecimal values longer than two digits, I always use a calculator or some other tool.  I only remember the first three powers of 2: 16^0 = 1, 16^1 = 16, and 16^2 = 256.  *256, you say!  That* is *an easy number to remember.  I'll remember that for all time!*

Let's do a short example and then a long one.  First, let's try converting `6C` to decimal.  We have 6 in the "16's" place and `C` (or 12) in the "1's" place.

| Hex Digit | 6 | C | TOTAL |
| ---- | ---- | ---- | ---- |
| Decimal Value | 6 * 16^1 = 96 | 12 * 16^0 = 12 | 108 |

That's right!  `6C` in binary is equal to 108.

You'll notice that two hex digits can include all of the values between 0 and 255.  For those paying attention, you might recognize that 0 - 255 are also the values that can be shown in 8 binary digits -- or one byte!  This is useful because things like CSS commonly use hex digits when referring to values in that range.  And now you have the power to convert `#BADA55` as a hex color into RGB values:

1. R: BA = `11*16 + 10*1` = 186
2. G: DA = `13*16 + 10*1` = 218
3. B: 55 = `5*16 + 5` = 85

So we know that `#BADA55` is a color with quite a bit of green, medium-high amounts of red, and not a whole lot of blue.

![The #BADA55 color](bada55.jpeg)

**VINDICATION!**

## Decimal to Hexadecial

Similarly, the process for converting decimal numbers to hexadecimal is the same as converting binary to decimal.  Either of the binary methods can be used (subtraction or division).  

> Once we go over how to convert binary to hex and back, you might decide it's easier to convert hex to binary first and then convert binary to decimal.  However you want to do it!

We'll do a division example just to confirm.  Let's convert 108 to hexadecimal to check our answer.  Remember again that, since we're doing the division method, we'll have to write down the hex digits from **right to left**.

1. Start with 108.  Divide by 16.  108 / 16 = 6, remainder 12.  The right-most digit is 12, or `C`.
2. 6 / 16 = 0, remainder 6.  The next digit is 6.

Altogether, 108 in hex is `6C`!  Success again!

## Hexadecimal to Binary

The nice thing about hexadecimal and binary is that 16 is a multiple of 2.  In fact, 16 = 2^4.  When converting hex to binary, you can essentially interchange each hex digit for 4 digits of binary and vice versa.  *How* you convert that single digit of hex to 4 digits of binary is kind of up to you.  When I do it, it comes down to a combination of a little memorization and converting through to decimal.

Let's take a look.  Let's convert `DB` from hex to binary.

1. `D` in hex is 13 in decimal.
2. Next we figure out which 4 binary digits we need to make 13.  13 is 8 + 4 + 1.  Those places in binary are: `1101`.
3. Thus, the binary conversion for the first digit, `D`, is `1101`.
4. Next digit is `B`.  Same process.  `B` is 11 in decimal.
5. Making 11 in binary: 8 + 2 + 1, or `1011`.
6. Thus, B = `1011`.

Soooo, combining everything, `DB` in hex is the same as `1101 1011`.  Did I plan for the binary number to be so symmetric?  No.  Will I claim credit for it?  Absolutely.

## Binary to Hexadecimal

Going the other way is exactly the opposite process.  Once again, we'll be converting `1101 1011` from binary to hex to check our work.

1. Let's break our binary number into chunks of 4 (like I've been doing): `1101   |    1011`.
2. And now we convert the first chunk to decimal: `1101 = 8*1 + 4*1 + 2*0 + 1*1 = 13`.
3. 13 in decimal converts to `D` in hex.  Our first digit is `D`!  (As expected.)
4. The next chunk of binary: `1011 = 8*1 + 4*0 + 2*1 + 1*1` = 11.
5. 11 in decimal converts to `B` in hex.  Our second digit is `B`!

In the end, our final hex number ends up being `DB`.  Just like we thought.

## The True Power... of Powers

And that's it!  Go forth and conquer numbers everywhere.  Amaze your friends by speaking to them in binary (or, possibly, get mocked for being a GIANT NERD 😁), streamline your CSS coding by eyeballing hex codes, and feel great about understanding how computers and math work just a little better.  A lot of these conversion skills will carry over to other number systems: try looking up Octal and doing some conversions to and from that!

As always, the math can be a bit intimidating, so if you have any questions or don't feel 100% confident in your number-fu, feel free to reach out to me and I'd be happy to show some more examples and help you get up to speed.