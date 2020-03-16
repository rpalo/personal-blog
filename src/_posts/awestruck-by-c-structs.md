---
layout: page
title: Awestruck by C Structs
description: Learn to harness the more powerful multi-field data structures in C.
tags:
- c
- structs
---

C is an amusing language, because there are some people who are used to writing in assembly or (I assume) knitting ones and zeros together by hand that refer to it as a “high-level language.”  And it is, to a point!  

It has concepts about memory management, variable types, functions, complex branching and control constructs, and more!  But, at the same time, there are those who are used to even higher-level languages like Python, Java, PHP, Ruby, JavaScript, and similar languages that look at C like some sort of low-level, bare-metal secret wizard magic impenetrable forbidden knowledge.  

And there’s no shame in that either.  I felt the same way, until very recently, when I forced myself to buckle down and just. write. a butt. ton. of C.  And Google the things I didn’t know.  And trust me: that was (*is*) a *lot* of things.

*To be very clear, this is a post about C, not C++.*

This post is one of what I hope are a few, providing some clarity into some things that I didn’t understand about C at first.  They are the pieces that allow higher-level logic and bundling of data into more manageable packages.  They are the closest thing that C has to objects in an Object-Oriented Programming mindset.  They are Structs.

## What is a Struct?

A **Struct** or “structure” is a way of declaring that several fields of data are related.  They look like this in the simplest form:

```c
struct Fraction 
{
  int numerator;
  int denominator;
};
```

That’s it.  We’ve taken two concepts, integers named “numerator” and “denominator,” and we’ve denoted that they can be bundled up together in one concept called a “fraction.”

Then you can use them like this:

```c
#include <stdio.h>

int main() 
{
  struct Fraction f;
  f.numerator = 3;
  f.denominator = 4;

  printf("%d/%d\n", f.numerator, f.denominator);
  //=> 3/4
}
```

The full name of the type you give to the variable `f` is `struct Fraction`, which is essentially saying, this is a struct, but what kind of pre-defined struct is it?  A `fraction`.  With what we’ve got here, you cannot simply say:

```c
  Fraction f;
```

But that possibility *is* within reach… and we’ll get there.

You’ll notice that the above example is a little verbose.  You can speed up the initialization with some braces.

```c
#include <stdio.h>

int main() 
{
  struct Fraction f = {3, 4};
  // ...
}
```

This assigns values to the fields in the order that they were originally defined.  *And*, if you want to be a little more explicit:

```c
  struct Fraction f = {.numerator = 3, .denominator = 4};
```

Or, a little *eeeevil*…

```c
  struct Fraction f = {.denominator = 4, .numerator = 3};
```

## `typedef` Aliases

Let’s be real.  Although, in some cases, there are some very good arguments for doing it, it can be a real drag to type `struct` before each of these variable declarations.  Lucky for you, there’s a way around this: `typedef`.  You can define a type alias in the normal namespace.  More on that in a second, but let’s see it in action first.

```c
typedef struct Date 
{
  int year;
  int month;
  int day;
} Date;

int main() 
{
  Date today = {2020, 3, 13};
	
  // Using the struct name still works:
  struct Date tomorrow = {2020, 3, 14};
}
```

The *first* `Date` is the name of the struct.  The *second* one is the *alias* in the main namespace.  You can do some crazy things here.  You can make the alias different than the struct name:

```c
typedef struct Jerome 
{
  int year;
  int month;
  int day;
} Date;
```

You can even omit the struct name completely, making it so you can *only* reference this struct via its alias.  This is the option that makes the rest of your code the least verbose.

```c
typedef struct 
{
  int year;
  int month;
  int day;
} Date;
```

But watch out.  Creating aliases has a bit of a gotcha attached: since aliases are in the main namespace, *the same place that function names live*, you can run into crashes:

```c
// This is OK, since struct names are in their own
// namespace, separate from function names
struct love 
{
  int magnitude;
};

void love() 
{
  printf("I love you!\n");
}

int main()
{
  struct love me_n_wife = {1000000}; // <3
  love();
  //=> I love you!
}


// This would cause an error:
typedef struct
{
  int red;
  int green;
  int blue;
} color;

void color()
{
  printf("Coloring is fun!\n");
}

int main()
{
  color bada55 = {186, 218, 85};
  color();
  //=> error: redefinition of 'color' as different kind of symbol
}
```

## Using Structs with Functions

### Passing by Value (The Default)

Have no fear.  Even though structs are a little bit fancier than regular variables, they can still be used with functions with no extra fuss.

```c
#include <stdio.h>

struct Crate
{
  int length;
  int width;
  int height;
};

int volume(struct Crate);

int main()
{
  struct Crate c = {5, 12, 13};
  printf("The volume is %d.\n", volume(c));
  //=> The volume is 780.
}

int volume(struct Crate crate)
{
  return crate.length * crate.width * crate.height;
}
```

Doing it this way is called **Passing by Value**.  That’s how C handles all arguments to functions unless you explicitly give it a reference to something.  More on that later.  The only downside of this is that C makes an entire copy of your struct and provides that to be used inside the function.  This uses more memory, especially if your structs are giant.  The *upside* of that, is that any changes the function makes to that struct don’t affect the original.  The *downside* of *that* is that the function *can’t* make any changes to the original.

```c
#include <stdio.h>

struct Fruit
{
  char name[10];
  int seeds;
  int age;
};

void forgetToEat(struct Fruit);

int main()
{
  struct Fruit banana = {
    .name = "banana",
    .seeds = 9,
    .age = 1,
  };

  forgetToEat(banana);
  printf("Oh, no!  I forgot to eat the %s and now it's %d days old!\n", banana.name, banana.age);
  //=> Oh, no!  I forgot to eat the banana and now it's 1 days old!
}

void forgetToEat(struct Fruit fruit)
{
  fruit.age = 1000;
}
```

See?  The banana didn’t age!  IT’S AN IMMORTAL BANANA.  JK, we just haven’t learned about **Pass by Reference** yet.

### Passing by Reference

Passing arguments by reference means that you don’t provide a copy of your argument to the function; you provide a reference (or pointer to its memory location).  Then, the function can access the argument’s memory directly, and manipulate it in ways that show up outside of the function after its execution has finished.

Here’s how that looks.  This is the same example as above, except it *works*.

```c
#include <stdio.h>

struct Fruit
{
  char name[10];
  int seeds;
  int age;
};

void forgetToEat(struct Fruit*); // 1

int main()
{
  struct Fruit banana = {
    .name = "banana",
    .seeds = 9,
    .age = 1,
  };

  forgetToEat(&banana); // 2
  printf("Oh, no!  I forgot to eat the %s and now it's %d days old!\n", banana.name, banana.age);
  //=> Oh, no!  I forgot to eat the banana and now it's 1000 days old!
}

void forgetToEat(struct Fruit* fruit) // 3
{
  (*fruit).age = 1000; // 4
}
```

Here are the main changes:

1. We update the function to expect, rather than a Fruit struct, a *pointer* to a Fruit struct.
2. We call the function and, instead of passing it the struct directly, to make a copy, we use the `&` operator to send it the memory address of the banana.
3. Same as #1, our function expects a pointer to a Fruit, not an actual Fruit.
4. We use the **dereferencing** operator to get at the value that *lives at that memory address*.  Then we update that struct’s age.

This concept of reaching through a pointer to read and update fields of a referenced struct is so common that they have an additional convenience operator: `->`.  We can update the function body above thus.

```c
void forgetToEat(struct Fruit* fruit)
{
  fruit->age = 1000;
}
```

Note how it replaces the parentheses, the dereferencing operator, *and* the dot operator.

## Going OOP with Structs (Kind Of)

Now, the OOP purists will probably have thoughts on this, but, if you squint and cock your head to the side a little, you can begin to encapsulate some data and provide some operations for your structs using these techniques.  For clarity, I’m going to split things into a header file so you can see the declarations of the functions we’ll be using, and then I’ll show the main function and implementations.  I may have to do a whole nother post about how header files work and are used, since I’ve learned a lot about that as well, and they can be intimidating if you haven’t been walked through it.

Anyways, here’s the header file.

```c
// student.h

#ifndef STRUCTS_STUDENT_H
#define STRUCTS_STUDENT_H

typedef struct Student Student;

Student* makeStudent(char name[20]);
void deleteStudent(Student*);
float gpa(Student*);
void assign(Student* s, int class, char grade);
void fail(Student*);

#endif
```

We show that there will be a struct called Student (which we also attach a `typedef` to to save some typing).  Then I have a function for creating/initializing a student, deleting them cleanly, calculating grade-point averages, assigning grades for particular classes (e.g. Jerry got a D in History because *Jerry* thought the Great Depression was a mean name for his belly button), and for failing a student wholesale.  Seems drastic, but OK.

Here are the implementations:

```c
// student.c

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "student.h"

#define NUM_CLASSES 10

// Student: a school student record with letter grade
// values for each of their classes.
struct Student
{
  char name[20];
  char grades[NUM_CLASSES];
};

int main()
{
  Student* ryan = makeStudent("Ryan");
  ryan->grades[4] = 'B';
  ryan->grades[8] = 'C';
  printf("GPA: %1.2f\n", gpa(ryan));
  //=> GPA: 3.70
  fail(ryan);
  printf("GPA: %1.2f\n", gpa(ryan));
  //=> GPA: 0.00
  deleteStudent(ryan);
}

// makeStudent: Create, allocate, and initialize a student
Student* makeStudent(char name[20])
{
  Student* s = (Student*) malloc(sizeof(Student));
  strcpy(s->name, name);

  for (int i = 0; i < NUM_CLASSES; i++)
  {
    s->grades[i] = 'A';
  }
  return s;
}

// deleteStudent: cleans up and deallocates the student
void deleteStudent(struct Student * s) {
  free(s);
}

// gpa: calculate a student's grade-point average.
// Essentially just convert letters to numbers and 
// average over the number of classes taken.
// NO POINTS FOR FAILURE!!!
float gpa(Student* s) {
  float total = 0;
  for (int i = 0; i < NUM_CLASSES; i++) {
    switch (s->grades[i]) {
      case 'A': total += 4; break;
      case 'B': total += 3; break;
      case 'C': total += 2; break;
      case 'D': total += 1; break;
      default: break;
    }
  }
  return total / NUM_CLASSES;
}

// assign: assign a grade to a student for a particular
// class.
void assign(Student* s, int class, char grade) {
  s->grades[class] = grade;
}

// fail: fail a student in every class.  DECIMATE THEM.
void fail(Student* s) {
  for (int i = 0; i < NUM_CLASSES; i++) {
    s->grades[i] = 'F';
  }
}
```

There are some various ways you can encapsulate things so that things are more or less private.  Here, we’ve gone almost *full* private.  What you see in the header file is what any “user” of your code will be able to see, and since all you can see is the name of the struct, but no fields, client code won’t be able to access Student fields directly.  Hence the reason for the `assign` function.  Probably, you would want some functions for reading the name and grades individually as well.  If you wanted a little more openness in your life, a la Python objects where properties are accessible by default, you could plop the entire struct definition in the header file.

## Struct LYFFFFEEEE

So there you are.  From zero to more than you maybe thought you wanted to know about C Structures in almost 2000 words.  No longer are you bound to simple scalar datatypes with one value each.  No, now you can soar with your compound data structures, basking in the glory of each of their fields, masterfully controlling them and passing them to functions as you see fit.  Go forth!  And **build.**