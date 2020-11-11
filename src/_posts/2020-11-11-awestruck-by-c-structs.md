---
layout: page
title: Awestruck by C Structs
description: Learn to harness the more powerful multi-field data structures in C.
tags:
- c
- structs
- beginner
cover_image: c-structs-cover.png
---

*Cover image <a href="https://unsplash.com/@gecko81de?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Patrick Baum</a> on <a href="https://unsplash.com/s/photos/structure?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Unsplash</a>*

C is an amusing language, because there are some people who are used to writing in assembly or (I assume) knitting ones and zeros together by hand that refer to it as a “high-level language.”  And it is, to a point!  It has concepts about memory management, variable types, functions, complex branching and control constructs, and more!  But, at the same time, there are those who are used to even higher-level languages like Python, Java, PHP, Ruby, JavaScript, and similar languages that look at C like some sort of low-level, bare-metal secret wizard magic impenetrable forbidden knowledge.  And there’s no shame in that either.  Until very recently, when I forced myself to buckle down and just. write. a butt. ton. of C.  And Google the things I didn’t know.  And trust me: it was (_is_) a _lot_ of things.

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

But that possibility _is_ within reach… and we’ll get there.

You’ll notice that the above example is a little verbose.  You can speed up the initialization with some braces.

```c
#include <stdio.h>

int main() 
{
  struct Fraction f = {3, 4};
  // ...
}
```

This assigns values to the fields in the order that they were originally defined.  _And_, if you want to be a little more explicit, depending on your compiler version:

```c
  struct Fraction f = {.numerator = 3, .denominator = 4};
```

Or, a little _eeeevil_…

```c
  struct Fraction f = {.denominator = 4, .numerator = 3};
```

## `typedef` Aliases
Let’s be real.  It’s a real drag to type `struct` before each of these variable declarations.  Lucky for you, there’s a way around this: `typedef`.  You can define a type alias in the normal namespace.  More on that in a second, but let’s see it in action first.

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

The _first_ `Date` is the name of the struct.  The _second_ one is the _alias_ in the main namespace.  You can do some crazy things here.  You can make the alias different than the struct name:

```c
typedef struct Jerome 
{
  int year;
  int month;
  int day;
} Date;
```

You can even omit the struct name completely, making it so you can _only_ reference this struct via its alias.  This is the option that makes the rest of your code the least verbose.

```c
typedef struct 
{
  int year;
  int month;
  int day;
} Date;
```

But watch out.  Creating aliases has a bit of a gotcha attached: since aliases are in the main namespace, _the same place that function names live_, you can run into crashes:

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

Doing it this way is called **Passing by Value**.  That’s how C handles all arguments to functions unless you explicitly give it a reference to something.  More on that later.  The only downside of this is that C makes an entire copy of your struct and provides that to be used inside the function.  This uses more memory, especially if your structs are giant.  The _upside_ of that, is that any changes the function makes to that struct don’t affect the original.  The _downside_ of _that_ is that the function _can’t_ make any changes to the original.

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

Here’s how that looks.  This is the same example as above, except it _works_.

```c
#include <stdio.h>

struct Fruit
{
  char name[10];
  int seeds;
  int age;
};

void forgetToEat(struct Fruit *); // 1

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

void forgetToEat(struct Fruit *fruit) // 3
{
  (*fruit).age = 1000; // 4
}
```

Here are the main changes:

1. We update the function to expect, rather than a Fruit struct, a _pointer_ to a Fruit struct.
2. We call the function and, instead of passing it the struct directly, to make a copy, we use the `&` operator to send it the memory address of the banana.
3. Same as #1, our function expects a pointer to a Fruit, not an actual Fruit.
4. We use the **dereferencing** operator to get at the value that _lives at that memory address_.  Then we update that struct’s age.

This concept of reaching through a pointer to read and update fields of a referenced struct is so common that they have an additional convenience operator: `->`.  We can update the function body above thus.

```c
void forgetToEat(struct Fruit *fruit)
{
  fruit->age = 1000;
}
```

Note how it replaces the parentheses, the dereferencing operator, _and_ the dot operator.

## Going OOP with Structs (Kind Of)
Now, the OOP purists will probably have thoughts on this, but, if you squint and cock your head to the side a little, you can begin to encapsulate some data and provide some operations for your structs using these techniques.  This is a little long for a single code example, so we’ll break it into steps.

We are going to create a `Student` type and the operations for assigning them a letter grade, failing them wholesale, and calculating their [GPA](https://gpacalculator.net/high-school-gpa-calculator/).  We’ll also need a constructor to create Students, and, because it’s C, we’ll need a destroyer to clean up our objects when we’re done with them.

### The Struct Definition

Let’s get things started.  Our student will have fields for their name and an array of letter grades for each of their classes.

```c
#define NUM_CLASSES 10
#define MAX_NAME_LENGTH 20

typedef struct
{
  char name[MAX_NAME_LENGTH + 1];
  char grades[NUM_CLASSES];
} Student;
```

Note that we define macros for the magic numbers we use because we’re good C citizens who don’t like to hide hard-coded values.

### The Constructor

Now we need a way to create new students.  Yes, we could do this by hand each time, but that’s error prone, and we might forget an important step sometime.  Better to write it once and make sure it’s right.  Or, at least, we’ll have all the bugs written in one place.

```c
#include <stdlib.h>
#include <string.h>
// ... snip ...

Student *makeStudent(char name[])
{
  if (strlen(name) > MAX_NAME_LENGTH)
  {
    return NULL;
  }

  Student *s = (Student *)malloc(sizeof(Student));
  strcpy(s->name, name);
  s->name[MAX_NAME_LENGTH] = '\0';

  for (int i = 0; i < NUM_CLASSES; i++)
  {
    s->grades[i] = 'A';
  }

  return s;
}
```

Our constructor is actually allocating a Student on the heap and returning a pointer, which you can see by the type of the function’s return value.  It takes a string and stores that in the Student’s name.  We also do a sanity check to make sure the name is small enough to fit.  Returning `NULL` from a function that encounters an issue creating some sort of object is reasonably common.  Lots of pieces of the C standard library does it, and you’ll start constantly finding yourself checking if something is `NULL`.

We also need to include `<stdlib.h>` in order to use `malloc` and `string.h` in order to use `strcpy`.  Because we’re benevolent school administrators, we also initialize our students’ grades to all A’s.

Because it would be lame to write a bunch of code and not have it work until the end, let’s write some `main` logic to exercise our code and find any warnings.  We’ll also need `<stdio.h>` to print output.

```c
#include <stdio.h>
// ... snip ...

int main()
{
  Student *s = makeStudent("[your name]");
  printf("%s is my name.\n", s->name);
  return 0;
}
```

Give it a compile:

```shell
$ gcc student.c -Wall -o student
$ ./student
[your name] is my name.

```

Everything working well?  Great!  Let’s move on.

### The Destructor

As it stands right now, we either have to clean up any students we create by hand or let the operating system clean them up when our program ends.  This is fine for our tiny example, but if we started writing a bigger application that was constantly creating students, we’d want to make sure they were getting cleaned up properly to minimize the chances of a memory leak or pointer errors.

```c
void destroyStudent(Student *s)
{
  free(s);
  s = NULL;
}
```

Since our student doesn’t own any other allocated values (all of its members are just arrays of characters, not pointers), it doesn’t have to do anything fancy.  We can just free it right away.  The pointer still exists and points to that memory, however, so it’s considered good practice to update the pointer to point to `NULL`.  This helps find memory bugs down the road.

Even though it won’t change our functionality, let’s go ahead and clean up our student in the `main` function.

```c
int main()
{
  Student *s = makeStudent("Ryan");
  printf("%s is my name.\n", s->name);
  destroyStudent(s);  // <===
  return 0;
}
```

OK!  With housekeeping complete, we can move onto the fun stuff!  Let’s do the GPA calculation first, so we can have something interesting to do with the other functions.

### Calculating the GPA

Let’s jump right into the code.  The most important thing to notice as we start writing functions that operate on our “objects” is that they all have an argument that accepts a pointer to a Student.  This is just about the closest we can get in C to making “methods” for our “classes.”

```c
float gpa(Student *s)
{
  float total = 0;
  for (int i = 0; i < NUM_CLASSES; i++)
  {
    switch (s->grades[i])
    {
    case 'A':
      total += 4;
      break;
    case 'B':
      total += 3;
      break;
    case 'C':
      total += 2;
      break;
    case 'D':
      total += 1;
      break;
    default:
      break;
    }
  }

  return total / NUM_CLASSES;
}

```

A GPA is really just a weighted average, with letter grades weighted certain amounts.  One common US system is to make A’s worth 4 points, B’s worth 3, C’s worth 2, D’s worth 1, and award no points for failure.

Our `gpa()` function runs through our grades, awards adds each score up, and returns the average by dividing by the number of scores.

Since our students start out with all A’s, we’d expect that to work out to a GPA of 4.0.  Let’s exercise our new function:

```c
int main()
{
  Student *s = makeStudent("Ryan");
  printf("%s is my name.\n", s->name);
  printf("My initial GPA is %0.02f.\n", gpa(s));
  s->grades[2] = 'C';
  printf("Rough semester for history.  Now I'm at %0.02f.\n", gpa(s));
  destroyStudent(s);
  return 0;
}
```

And give it the ol’ run-aroony:

```shell
$ gcc student.c -Wall -o student
$ ./student
[your name] is my name.
My initial GPA is 4.00.
Rough semester for history.  Now I'm at 3.80.
```

Yay!  The next step is to add functionality for teachers to award scores to students.  We can already do that now manually, but, for the sake of example, and to add some error checking, we’ll do a function.

### Assigning Letter Grades

Here’s the next function:

```c
void assign(Student *s, Class class, char grade)
{
  // Don't allow assignment to a class that doesn't exist.
  if (class >= NUM_CLASSES)
  {
    return;
  }

  // Only allow A-F grading.
  if (grade < 'A' || grade > 'F')
  {
    return;
  }

  s->grades[class] = grade;
}
```

For this, it seems OK to let grade assignments fail silently.  If a teacher can’t figure out how to assign an A-F to a class that exists, then they don’t deserve to change the student’s grade from an A.

We’re going to make one other change here for some added readability.  You’ll notice that the `grades[]` array is indexible via integers, so you could give a student a B in class `4`.  But how lame is that?  What class is that?  Let’s create an `enum` that defines names for our grades.  I don’t want to dive into the nitty gritty of enums in this article, but they’re one of my favorite things ever, and I definitely want to make that article in the coming weeks.  Right now, just trust me that we’re basically giving names to the numbers 0-9 (our 10 classes).

```c
typedef enum
{
  MATH,
  SCIENCE,
  HISTORY,
  ENGLISH,
  SPANISH,
  PHYSICS,
  PHILOSOPHY,
  GOVERNMENT,
  COMPUTER_SCIENCE,
  SHOP,
} Class;
```

So now, we can update our `main()` function accordingly.

```c
int main()
{
  Student *s = makeStudent("Ryan");
  printf("%s is my name.\n", s->name);
  printf("My initial GPA is %0.02f.\n", gpa(s));
  assign(s, HISTORY, 'B');
  printf("Rough semester for history.  Now I'm at %0.02f.\n", gpa(s));
  destroyStudent(s);
  return 0;
}
```

Awesome.  One more function to go: the SUPER FAIL!

### Fail all Classes

Is it over-the-top, vindictive overkill?  You betcha!  Let’s write it.

```c
void fail(Student *s)
{
  for (int i = 0; i < NUM_CLASSES; i++)
  {
    assign(s, i, 'F');
  }
}
```

And the code to exercise it:

```c
int main()
{
  Student *s = makeStudent("Ryan");
  printf("%s is my name.\n", s->name);
  printf("My initial GPA is %0.02f.\n", gpa(s));
  assign(s, HISTORY, 'B');
  printf("Rough semester for history.  Now I'm at %0.02f.\n", gpa(s));

  printf("\n   Hehehe, I'm going to vandalize school property...\n");
  fail(s);

  printf("Oh no.  Now my GPA is %0.02f.\n", gpa(s));
  destroyStudent(s);
  return 0;
}
```

When we run it:

```shell
$ gcc student.c -Wall -o student
$ ./student
[your name] is my name.
My initial GPA is 4.00.
Rough semester for history.  Now I'm at 3.90.

   Hehehe, I'm going to vandalize school property...
Oh no.  Now my GPA is 0.00.
```

### Final Notes on this Example

This isn’t necessarily exactly the same as your ideal Object-Oriented scenario.  Right now, all members and functions are public.  You can use header files for some privacy, and that might be a topic for the future.  But hopefully, this helps make C a little more accessible to someone used to working with actual classes, methods, and properties.

## Struct LYFFFFEEEE
So there you are.  Zero to more than you maybe thought you wanted to know about C Structures in almost 2800 words.  No longer are you bound to simple scalar datatypes with one value each.  No, now you can have like _two_ or _three_ values tied up together in one!  Go forth and conquer!  And definitely reach out if you have any questions.