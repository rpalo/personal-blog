---
layout: page
title: I Can JavaScripting?
tags: javascript
---
Hey!  Sorry for the long gap.  It's been over a month since my last post, which is not ok.  Luckily, I've recently started the [100 days of code](https://github.com/rpalo/100-days-of-code) challenge along with a number of the other [CodeNewbies](http://www.codenewbie.org/blogs/100-days-of-code-codenewbie-edition), and that should help keep me on track.  Also, I'm working on some changes to the blog that should be coming up here in the next week or so.  I actually got a url that means something, which is neat!  More on that after the change.

Anyways, I have been having a whole lot of success in the JavaScript world recently, and I wanted to share some of the wisdom nuggets that I've stumbled upon.  First thing's first.  If you haven't heard of the [JavaScript30](https://github.com/rpalo/JavaScript30), it is a 30 day (or so) challenge wherin [Wes Bos](http://wesbos.com/), a genius person and excellent teacher, works through 30 different projects with you using only Vanilla Javascript.  This is especially great if you are like me and have a slight distrust of just installing a random library without vetting it out, which makes doing anything exhausting.  A lot of times I end up starting something, finding out lots of people use a library for it, trying to do it without the library, getting stuck, and giving up.  This is especially frustrating, because I feel like I know JavaScript, but can't actually do anything with it!  Not anymore!  I want to share a few of the most useful things with you that use Vanilla JavaScript and not libraries.  (Note: I don't hate libraries.  I just think there is something to be said for not having to manage dependencies.)  So here we go.

### Just Selecting Stuff

The very first useful thing you should know is how to get at (or create) things in the DOM.  This is something that JQuery makes really easy, but here's how to do it the rugged way.

{% highlight javascript %}
// I'm going to use ES6 syntax (which I'm still learning, so be gentle)
const header = document.querySelector('h1');
// Now you have access to everything about your header!
header.innerHTML = "I OWN THIS HEADER NOW."
// What if you want to get a whole list of links to work with?
const navlinks = document.querySelectorAll('a.navlink');

// BUT BE CAREFUL!  querySelectorAll doesn't return an Array, it returns a NodeList.
// It works similarly, but doesn't have all the useful methods.  Here's a workaround.
const navArray = [...navlinks];  // Using the neat ES6 spreading technique.
// Which lets you dump the NodeList into an array and you can keep on like normal
// This is just shorthand for new Array(...navlinks);   

navArray.forEach( function(link) {
    link.addEventListener('click', doSomethingCrazy);
});

// You can also query within elements themselves!
const contentDiv = document.querySelector('#content');
const authorName = contentDiv.querySelector('.author');

{% endhighlight %}

### Making Things Happen (Events)

I hinted at this in the previous section.  What if you want to run some magic voodoo everytime someone mouses over your title or everytime someone submits a form?  It's really that simple.

{% highlight javascript %}
// Just select the element you want the event to be tied to
const header = document.querySelector('#title');

// Note that if you have more than one #title (which would be poor form anyway)
// querySelector() will only return the first one in the page.

// Let's define our action to happen
function titleGrow(e) {
    // You can pass in the event, e, which contains useful info about what happened
    // note that we don't need that here
    this.style.font-size = "48px";
    // for events, this often (possibly always, not sure yet) refers
    // to the thing that triggered the event
}

// Lastly let's tie our event to the above function
header.addEventListener('mouseenter', titleGrow);
// NOTE: there are no () at the end of the function name.  We don't want to
// call the function *in place*, we just want to pass a reference to it to 
// be used later.
{% endhighlight %}

And that's it!  Now, the first time the user mouses over the title, its font will grow to 48px.  Note that you would have to listen for a `mouseleave` event and pass in a different function if you wanted it to shrink back to normal once the user mouses out of the title.

### Modifying Elements

The last thing I'll talk about are some common ways to modify elements using JavaScript.

{% highlight javascript %}
const author = document.querySelector('#author');
// Let's change the text!
author.innerHTML = "Ryan 'is the coolest' Palo";
// modify a style
author.style.color = "#BADA55";
// add, remove, or toggle a class
author.classList.add("cool-guy");
author.classList.remove("blog-slacker");
author.classList.toggle("is-on-the-ball");
{% endhighlight %}

A lot of times, it is the easiest to simply toggle a class and handle all of the excess animations, changes, styling in the css.  Makes things easier to read and find.

Anyways, that's it for now.  More coming soon!

***


