---
title: Step Your Meta Game Up
cover_image: meta-tag.jpg
layout: page
description: Learn how to make sharing your site look awesome!
tags: html seo social
---

Meta tags.  SEO.  For me, these were things I knew existed, and I knew I should be doing something about them, but it was never high on the list of things to do -- until I read up on them and found out how cool they can make your website!  They're quick little things that can give your site just a touch of panache and confidence.

![I know what I'm about, son.](/img/confident-swanson.gif)

I'm going to cover two types of meta tags here: general utility tags and social tags.

## Utility Tags

First let's cover some things that help search engines, devices, and other robits work well with your site.  I'm just learning about this, but it seems like these should probably exist on every page that you ever make.  Someone correct me if I'm wrong.

```html
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="ROBOTS" content="INDEX, FOLLOW">
    <meta name="description" content="Ryan's site that extols the values of cheese.">
    <meta name="keywords" content="cheese, virtues, poetry, spoken word, slam poems about cheese">
</head>
```

Some explanation:

1. **Charset**: Specifies the character encoding of the website.  UTF-8 is nice, it's the recommended setting, and it helps with languages that have characters that are outside the basic ASCII set.
2. **IE=Edge**: A meta tag that seems like it used to be required to tell Internet Explorer to behave, but from what I can tell, Microsoft seems to be phasing this out.  This might not even be necessary any more.  I don't think it hurts to have it, though, and it may help with some browser compatibility.
3. **Viewport**: Sets the initial viewport and scaling.  According to [w3](https://www.w3schools.com/TAgs/tag_meta.asp), this makes it so your site doesn't show up teeny tiny on mobile initially.  Always a good idea.
4. **ROBOTS**: Tells well-behaving web-crawlers how to index (or not) your site.  You would set this according to whether or not you want the page to be visible from Google, for example.
5. **Description**: Your site's description.
6. **Keywords**: Keywords that help people find your site from searches.

Especially if you're using Jekyll, JavaScript frameworks, or some other method of templating, it's pretty easy to drop these in once and forget about them and they improve your searchability and accessibility.  But!  They don't do anything especially shwoopy like the next section does.  Behold!

## Social Tags

There are some people who's links look sad when they share them on social media.  Like this:

![Sad link sharing](/img/sad-link.png)

But, in a few short minutes, their links could look like **this:**

![AMAZING LINK!](/img/amazing-link.png)

Let's take a look at the HTML.

```html
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="assert_not magic? | Gouda?  You mean great!">
    <meta name="twitter:site" content="@paytastic">
    <meta name="twitter:description" content="A point-by-point comparison of Gouda and other cheeses.">
    <meta name="twitter:image" content="http://assertnotmagic.com/gouda.png">
    <meta name="twitter:image:alt" content="Delicious Gouda">
    <meta name="twitter:creator" content="@paytastic">
    <meta name="og:url" content="http://assertnotmagic.com/gouda/">
    <meta name="og:title" content="assert_not magic? | Gouda?  You mean great!">
    <meta name="og:description" content="A point-by-point comparison of Gouda and other cheeses.">
    <meta name="og:image" content="http://assertnotmagic.com/gouda.png">
```

There's actually a lot more you could do.  It's hopefully clear that the lines beginning with 'twitter' are for the Twitter API, and it's probably not clear that the 'og' ones are for Facebook for some reason.  There's also Google+ and others.  These are just the two that I'm using now.  Note the ever-important `twitter:image:alt` for screen-readers.

Anyways, once you've got this in place (or, at least the Twitter ones), head on over to [the Twitter Card API documentation](https://dev.twitter.com/cards/overview) and take a peek.  Finally, head to the [Twitter Card Validator](https://cards-dev.twitter.com/validator) to make sure you did it right and check to ensure everything is working as planned.  It may take a bit for Twitter and the other sites to crawl and whitelist your site (or blacklist you if you're a moral delinquent), but then, sharing your site on social media will be super duper shnazzy!

I'm working on figuring out Google's Rich Cards (i.e. how your site and pages are displayed in their search results), and once I get that all in place and figured out, I'll write a post about that as well.  

![Google cards](/img/google-cards.png)

<small class="centered">Sorry, apparently I've got food on my mind.</small>

If I missed some meta tags you think are important, or if you've got some other cool ones to share, I'd love to hear about it!