---
layout: page
title: Closures and Callbacks
description: A neat little pattern I found for DRY-ing up your callbacks.
tags: javascript functional front-end
cover_image: closure-callback.png
---

Earlier this week, I got an email telling me that the Odin Project had just upgraded their [JavaScript course](https://www.theodinproject.com/courses/javascript).  I checked it out.  If you're like me and have been putting off learning more about JavaScript because of all of the build tooling, this course is definitely for you.  I learned the basics of webpack (and even submitted a [pull request](https://github.com/webpack/webpack.js.org/pull/1855) to make a correction on the webpack tutorial!), and it was all at a super gentle and beginner-friendly pace.  As I was going through this course, during one of the assignments, I came across a pattern that I thought was neat.  Especially after my [post a couple of weeks ago about closures](https://assertnotmagic.com/2018/02/10/closure-i-hardly-know-her/), I knew I had to share it.  If at any point you're reading through my code examples and you get furious at my code, please skip ahead to the [Delirium Disclaimer](#delirium-disclaimer).

## The Project

The goal was to use as many different modules as possible in order to test out the bundling power of webpack.  I was supposed to [create a generic landing page for a restaurant](https://www.theodinproject.com/courses/javascript/lessons/restaurant-page), and it had to have a tab-based navigation system.  [Here's the site I came up with.](https://assertnotmagic.com/odin-restaurant/)  (and the related [GitHub repo](https://github.com/rpalo/odin-restaurant))

![My Odin Project Restaurant](/img/odin-restaurant.png)

I didn't do anything to make it look pretty on mobile, so if you're reading on mobile, forgive me.

## The Technique

The technique I want to share is the one I used for the nav button click callback: I created a closure!  Let me back up.  I've got three buttons.  The HTML ends up looking something like this:

```html
<div class="tabs">
  <button class="tabs__link active" data-target="About">About</button>
  <button class="tabs__link" data-target="Menu">Menu</button>
  <button class="tabs__link" data-target="Contact">Contact</button>
</div>
```

I then have a bunch of `<div class="tabcontent">`'s that contain the content of the tabs.  Every one but the active one has `display: hidden`, so only the active one will show up.

Of course, the assignment specifically asked me to generate these buttons in JavaScript, so it ends up looking more like this:

```javascript
// Don't worry about openTab now.
// We'll talk about it in a minute.
import openTab from './openTab';

const loadNav = () => {
  const tabHolder = document.querySelector('.tabs');
  const tabs = ['About', 'Menu', 'Contact'];
  tabs.forEach(tabName => {
    const button = document.createElement('button');
    button.classList.add('tabs__link');
    button.dataset.target = tabName;
    button.addEventListener('click', openTab(tabName));
    button.innerHTML = tabName;
    tabHolder.appendChild(button);
  });
};
```

But here's where the magic happens.  I'll show you the code for `openTab`, and then I'll talk about what's so special about it.

```javascript
const openTab = tabName => {
  return (e) => {
    const tabContent = document.querySelectorAll('.tabcontent');
    tabContent.forEach(tab => {
      tab.style.display = "none";
    });
    
    const tabLinks = document.querySelectorAll('.tabs__link');
    tabLinks.forEach(link => {
      link.classList.remove('active');
    });
    
    const activeTab = document.querySelector(`[data-page="${tabName}"]`);
    activeTab.style.display = "block";
    e.currentTarget.classList.add('active');
  };
};

export default openTab;
```

### So What's Going On Here?

Usually, when you pass a callback function to an event listener, you do it without parenthesis, like this: `button.addEventListener('click', doTheThing)`.  This is because you're not calling the function as you're creating the event listener, you're passing the function object to be called later.  However, have you ever wanted to pass additional information to a callback?  Usually when you have a callback function for event listeners, they only take the event as an argument:

```javascript
const doTheThing = e => {
  // stuff
};
```

However, what if you want it to have additional information?

```javascript
const doTheThing = (e, myColor) => {
  console.log(myColor);
};
```

In my case, I wanted to write one callback function that would work for all three nav buttons, even though their functionality would each be a little different, based on which tab they were trying to act on.  So I needed something like this:

```javascript
const openTab = (e, tabName) => {
  // The stuff
};
```

BUT, if you try this, JavaScript gets grumpy.  So what can we do?  One solution is to create a closure at the time that you add the event listener.

```javascript
const openTab = tabName => {
  return e => {
    // Things in here have access to tabName *and* e
  }
}
```

When you use it like this:

```javascript
button.addEventListener('click', openTab(tabName));
```

the `openTab` function gets *immediately* evaluated, and the new, anonymous function is given as the callback.  It's the same as writing:

```javascript
button.addEventListener('click', e => {
  console.log(tabName + "Haha!");
});
```

Thanks to our friend the closure, the anonymous function placed after the event listener retains access to the `tabName` variable, even though the function was called long before the event ever fires.  If you're not exactly sure what a closure is, definitely take a look at [my post on closures](https://assertnotmagic.com/2018/02/10/closure-i-hardly-know-her/).  The benefit is that you can pull the `openTab` logic out into its own function and your `addEventListener` call ends up looking a lot cleaner.

So, the next time you want your callback functions to have more information than just the event passed in, consider using a closure to DRY things up.

## Delirium Disclaimer

As I was writing this post, I noticed a lot of things I should change and fix in my original code (variable name consistencies, CSS class name consistencies, etc.).  I also noticed that I probably could have left out the `tabName` variable completely and gotten away with getting everything that I needed from the `event` that got passed into the function.  The whole closure thing may have been unnecessary.

I'm going to go ahead and blame this on the fact that by the time I got to this part of the code, I was delirious from all of the things I was doing and new things I was learning.  Now that I've had some sleep, past-me's code is making me cringe a little bit.  Sorry!

That being said, this is one of my first real stabs at modern JavaScript.  So if you see ways that I could improve my code or do something more idiomatically, I'd love to get your feedback.  Definitely share your wisdom!