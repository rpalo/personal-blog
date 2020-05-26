---
layout: page
title: "Dev Journal 5/26/2020: rails new Who Dis"
description: I started a new project to make a dynamic, Rails-powered menu/assistant for our bar at home.  And I got the domain name palo.bar for $2!
category: devjournal
tags:
- rails
- ruby
---

I started a new project yesterday, because I *definitely* have enough spare time and energy for that (maybe).  I was just tootling around the internet checking out available domain names, and I found out that `palo.bar` was available *and on SALE for $2!*

![Ariana Grande singing 'I want it.  I got it.'](https://media.giphy.com/media/1X4FZo98u4xgdqkcL2/200.gif)

So now I'm diving back into Rails to make a dynamic, online bar menu for our home bar!  Here are the major use-cases.

1. People come over to our house (eventually, stupid virus).  I ask if they want a drink.  They say, "Sure, what do you have?"  Instead of pausing awkwardly, trying to figure out how to succinctly list everything I have or guess what they'll like, I hand them a QR code for `palo.bar`.  They go there, browse through the mobile-friendly, helpful, and intuitive UI, and select a cocktail based on the ingredients I have in stock and the things I know how to make.

2. I learn a new cocktail, so I add it to the list with some metadata that help people discover it.

3. I head to the store, and I'm not sure what I have and what I'm out of.  My helpful `palo.bar` bartender's assistant alerts me to the fact that I'm out of limes again.  *And,* if I was to get a bottle of Campari, I could add 4 new cocktails to the menu!  Thanks, Automated Bartender's E-ssistant (or, ABE)!

I know that there are mobile apps out there that provide some of this functionality for me.  But I want to build it the way I like it.  And, come on!  `palo.bar`?  It makes me so happy.

Necessary?  No.  *Cool?*  I hope so.  :)  So here's where I'm at after Day 1.

## Progress

1. Project created.  
2. Critical functions and domain-specific objects identified.
3. `Ingredient` model created.
4. Views and controller for `Ingredients` underway in a very rough form.

## Next steps

- Get a rough home page in place.
- Deploy to Heroku as soon as I can.
- Finish up views and controller for `Ingredients`.  Make sure everything works as expected.
- Start on the `Recipe` stuff.
- Create the home page based on a quick and smooth user interaction.
- Styles.  Mobile-first.  After everything works on the back end.
- Take a look at next features, including more intelligence for ABE, user profiles, etc.

But most importantly:

**Stay on track.**  Do not drop this side project.  Find the energy to push on and keep going after the baby goes to sleep.  Resist Netflix and Libby and the Switch.  They are the *enemies* of total seamless web-driven bar victory!

Anyways, I think these journals should help keep me going and knowing what I need to do next.  Stay tuned!  And I'm always open to friendly advice!
