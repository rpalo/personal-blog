---
layout: page
title: Learn to Code, Part 3 - Rainbow Collections
description: Part 3 in the learn-to-code using JavaScript and P5.js series.  Learn how collections like arrays and objects can amplify our coding power.
tags: p5 javascript beginner tutorial
cover_image: rainbow.jpg
---

![Final Product](/img/rainbow-final.gif)

Back for Lesson 3?  Awesome!  Hopefully the gif above is enough motivation to get you through this lesson.  This time, we'll build on what we have used before, and expand with two new concepts.  In the last lesson we learned about **for-loops**.

```javascript
for (var i=0; i < 10; i++) {
  console.log("Programming is dope!");
}
```

For-loops are pretty powerful, but when you combine them with the new stuff that we're going to learn this time — **arrays** and **objects** — you can really accomplish some big things.  And the basic **objects** that we'll learn about are stepping stones to creating your own, more powerful objects!  So let's get started with our list of requirements for the completed project.

> Our project should consist of a trail of a finite number of colored circles that follow the mouse.  The circles will be colored randomly and should be erased beyond a certain number of circles (i.e. only store a certain number of points in the mouse's history).

Just like last time, let's simplify our project and build it out in small steps.  ONWARD!

## Step 1: One in a Row

Let's simplify our requirements.  For Step 1, we'll just do one circle, that chooses its color randomly and is right at the position of the mouse at all points.

![One randomly colored circle](/img/rainbow-example1.gif)

Be sure to copy your standard `index.html` from [last time](https://assertnotmagic.com/2017/09/16/p5-part-2-looping-targets/) into your new project folder and create a new `sketch.js` file there.  Let's fill in just the stuff that you've seen before, first.

```javascript
function setup() {
  createCanvas(600, 600);
  background(255);
  stroke(0);
}

function draw() {
  background(255);
  fill('blue');
  ellipse(mouseX, mouseY, 15, 15);
}
```

None of this should be surprising or new, but, just in case, let's step through the code.  First, we do our `setup`.  We create a new canvas, paint the background white, and set the pen stroke color to black (remember that in P5, the grayscale goes from 0 to 255).  Then we do our `draw` function, which gets repeated over and over.  Every frame, we're re-painting the background white to effectively erase everything from the previous frame.  Then we select a fill color for our circles.  I picked blue with absolutely no pre-planning, so it's guaranteed to be a [random choice](https://xkcd.com/221/).  Ha.  Ha.  And then we draw a circle with x position of `mouseX`, y position of `mouseY`, and radius of 15.  Remember that P5 provides us with the `mouseX` and `mouseY` variables automatically, so we don't have to do any extra work there.

Open up `index.html` in the browser, and you should see a blue circle following your mouse!  Which is not *quite* what we want, but it's close.  Ideally, we want our circle color to be an actual random value.  There's a couple of ways to do this, but I'm going to use this as an excuse to introduce **arrays**.

### Arrays

An array is just a collection of values, like a bunch of slots to hold variables.  They look like this:

```javascript
var collection = ['bibble', 4, 3.2, 'glorb'];
```

You can declare arrays with square brackets: [].  They can hold whatever you want, and the members — or values inside — get separated by commas.  You can also store other variables inside.  You can even declare them on multiple lines if there's too many items.

```javascript
var my_favorite = 4;
var my_brothers_nickname = 'potato';
var my_stuff = [
  my_favorite,
  my_brothers_nickname,
  1.4,
  57,
  'soup'
]
console.log(my_stuff);
// [4, 'potato', 1.4, 57, 'soup']
```

Notice how, even though we stored the variables in the array, it doesn't say `[my_favorite, ...]`.  Similarly, if we then type:

```javascript
my_favorite = 28;
console.log(my_stuff);
// [4, 'potato', 1.4, 57, 'soup']
```

Modifying the variables doesn't affect the array (at least, for more basic things like numbers or strings (things in quotes).  If you need to access and/or modify specific values inside the array, you can use **indexing**.  It works like this.

```javascript
var nums = [1, 2, 3, 4, 5];
//   Index: 0  1  2  3  4
// Each item in the array has an *index*
// or place in line.  They start counting at 0!
nums[0];  // Use square brackets after the array name to access.
// 1
nums[3];
// 4
nums[2];
// 3
// You can even assign values that way.
nums[3] = 'BANANA';
nums
// [1, 2, 3, 'BANANA', 5]

// Try assigning to indexes that don't exist!
nums[7] = 'TWO BANANA!'
nums
// [1, 2, 3, 'BANANA', 5, undefined, undefined, 'TWO BANANA!']
// Javascript automatically creates blank entries
// to fill in the slack.
```

Get it?  Got it?  Good.  If you're still confused about how indices work or why they start from zero, check out [my blog post on indexing](https://assertnotmagic.com/2017/04/12/indexing-teaching-better/).  Anyways, we'll do more with those in a minute.  Let's get back to it.

### Back to It

One benefit of **arrays** is that P5's `random` function can be used with them!  When you pass an array to `random`, it will randomly choose one of the values.  We'll use that to our advantage.  Here's our new and improved `sketch.js`.

```javascript
var colors = [
  '#1B998B',
  '#ED217C',
  '#2D3047',
  '#FFFD82',
  '#FF9B71'
];

function setup() {
  createCanvas(600, 600);
  background(255);
  stroke(0);
}

function draw() {
  background(255);
  fill(random(colors));
  ellipse(mouseX, mouseY, 15, 15);
}
```

We create an array of colors (more on that in a second) at the top.  Then, when we go to pick a fill color, we pass colors to P5's `random` function and we get a random one of those five colors selected!  Mission accomplished!

One thing that you may not have seen before is the code inside the `colors` array.  These are **hexidecimal** values, which are often used to refer to colors in a concise manner in web programming.  For a primer on what hexidecimal values are, I recommend [this post by Vaidehi Joshi](https://medium.com/basecs/hexs-and-other-magical-numbers-9785bc26b7ee), and also that entire series of posts.  For now, just remember two important things.

1. Colors can be represented by a hash (pound, hashtag, octothorpe, …) symbol followed by 6 characters that are either between 0 and 9 or A and F.  16 possible values, ergo, **hexi (6) decimal (10)**.
2. You can google hex values to see what color they are, you can usually google colors to find their hex values, and most good code editors have some sort of plugin to visualize the color of a hex value.  In my case, here are the colors I chose.

![Pallette for this project](/img/rainbow-pallete.png)

(Fun fact, you can create some great color pallettes using [the Coolors app](https://coolors.co/) if you're bad at putting colors together like I am).

## Step 2: Keeping Track

Now we just need to keep track of our recent mouse positions to create our trail.  I'm going to do it *just* with arrays first, and then I'll show you the last new thing to show you how much cleaner it makes things.  First, what do we need to keep track of?  A mouse X value, a mouse Y value, and possibly a color (so each circle can keep its color as long as it's on screen).  Let's store that data.

```javascript
var colors = [
  '#1B998B',
  '#ED217C',
  '#2D3047',
  '#FFFD82',
  '#FF9B71'
];

var xValues = [];
var yValues = [];
var dotColors = [];
```

Now, each `draw` loop, we need to add a new circle to the mix — and possibly remove one if we have too many.  If I asked you to shift all of the values in an array down one index, effectively deleting the last one, your first thought might be something like this:

```javascript
var nums = [1, 2, 3, 4, 5];
nums[4] = nums[3];
nums[3] = nums[2];
nums[2] = nums[1];
nums[1] = nums[0];
nums;
// [1, 1, 2, 3, 4]
```

Your second thought (possibly) would be to notice a repetitive pattern and try a **for-loop**.

```javascript
for (i=4; i>0; i--) {
    nums[i] = nums[i - 1];
}
```

Both are valid, but arrays come with some nice built in **methods** (another word for a function that is tied to an object — more on that later).  These methods are useful utility functions that exist so we don't have to always reinvent the wheel.  To add an item to the start of an array, use the `unshift` command.

```javascript
var nums = [1, 2, 3, 4, 5];
nums.unshift('BANANA');
// ['BANANA', 1, 2, 3, 4, 5]
```

To remove the last item of an array, use `pop`.

```javascript
nums;
// ['BANANA', 1, 2, 3, 4, 5]
nums.pop();
// ['BANANA', 1, 2, 3, 4]
```

Maybe you start to see where I'm going with this?

```javascript
var colors = [
  '#1B998B',
  '#ED217C',
  '#2D3047',
  '#FFFD82',
  '#FF9B71'
];
var xValues = [];
var yValues = [];
var dotColors = [];

function setup() {
  createCanvas(600, 600);
  background(255);
  stroke(0);
}

function draw() {
  // Place current x, y, and new color value at front of array
  xValues.unshift(mouseX);
  yValues.unshift(mouseY);
  dotColors.unshift(random(colors));

  background(255);
  
  // Draw all dots
  var count = xValues.length;    // The .length command returns how many
  for (var i=0; i<count; i++) {
    fill(dotColors[i]);
    ellipse(xValues[i], yValues[i], 15, 15);
    
    // We step through the xValues, yValues, and dotColors simultaneously!
    // index:  0  1  2  3  4  5  6  7  8  9  10
    //     x: 75 70 65 64 63 40 34 40 46 45  50
    //     y: 20 23 24 22 21 18 08 12 14 15  17
    // color:  0  2  1  4  3  2  1  0  2  1   4
  }

  // If there are more than 10 dots, remove the last one
  // to keep the lists always at 10 values or less.
  if (count > 10) {
    xValues.pop();
    yValues.pop();
    dotColors.pop();
  }
}
```

And we're actually done!  We've met all the requirements we set out for ourselves at the beginning.  However, I want to introduce one more new thing that will be slightly less error prone and easier to read.

## Step 3: Keeping Track with Objects

Let's take a look at **objects** for a moment.

### Objects

**Objects** are JavaScript's way of keeping related data (and later, functions) all wrapped up in one package.  Right now, we've got three distinct pieces of data: an x value, a y value, and a color.  But, each index or data point is all clearly related.  That is to say that our program wouldn't work if we shuffled our x array and tried to re-run the program.  Each data point has one specific x, one specific y, and one specific color.  Let's take a look at how **objects** might help with this.

```javascript
var datapoint = { "x": 125, "y": 340, "color": "#2D3047"};
```

You can create an object with squiggly brackets.  Objects are made up of **keys** and **values**.  Each pair is in the pattern `{key: value}`, and key/value pairs are separated by commas like items in an array.  Another name for a basic object like this is an **associative array**, called such because each **key** in the array has an *associated* value that goes along with it.  You can think of the keys like labels that replace the indices of an array.  Similarly to an array, you can access and modify values in the object with square brackets.

```javascript
datapoint["x"] = 42;
datapoint;
// {x: 42, y: 34, color: "#2D3047"}
datapoint["y"];
// 34
```

As an extra bonus, though, there is a second way to access values in an object: the **dot**.

```javascript
datapoint.color;
// "#2D3047"
datapoint.y = "FISHES";
datapoint;
// {x: 42, y: "FISHES", color: "#2D3047"}
```

Let's redo our sketch using an **array of objects** instead of multiple arrays.

### Finishing Up

```javascript
var tail = [];
var colors = [
  '#1B998B',
  '#ED217C',
  '#2D3047',
  '#FFFD82',
  '#FF9B71'
]

function setup() {
  createCanvas(600, 600);
  background(255);
  stroke(0);
}

function draw() {
  background(255);
  // Add one tail dot object to the array
  tail.unshift({
    "x": mouseX,
    "y": mouseY,
    "color": random(colors)
  });

  var count = tail.length;
  var current;
  for (var i=0;i<count;i++) {
    // Get a reference to the current object
    // so we don't have to type [i] each time.
    current = tail[i];
    
    fill(current.color);
    ellipse(current.x, current.y, 15, 15);
  }

  if (count > 10) {
    tail.pop();
  }
}
```

We didn't change very much, but now we only have one array to keep track of, and instead of mucking around with multiple ones.  I'd like to think that using the **dot** method to access the values in the object is more explicit and easier to read than the previous method using indices.  Creating an ellipse with `current.x, current.y` looks a lot prettier in my opinion.

Et voila!

![Final product](/img/rainbow-final.gif)

## Homework

1. Research and input some more color hexes to put in our color array.
2. Get rid of the `colors` array and modify the program to select a color via multiple calls to `random` for a random RGB color value (similar to a homework in Lesson 1).
3. Double the size of the tail.
4. Make it so that when you click the mouse the tail disappears.
5. Vary the size of the circles randomly and store that in the object as well.

<hr>

That's it for this lesson!  Don't forget to reach out if you have any questions or troubles with the homeworks!  Now that we have the full powers of arrays, objects, and for-loops, we can really get some cool things made.

*Cover image credit: Huffington Post*