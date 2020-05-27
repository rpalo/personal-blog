---
layout: page
title: "Dev Journal 5/27/2020: Good Progress and Some Footguns"
description: Day 2 of the bar project.  We've had ups and downs so far.
category: devjournal
tags:
- ruby
- rails
- models
- architecture
---

OK.  Today's update because I'm sticking with this.

I made some good progress.  I got the `ingredient` setup working all CRUD-like, and everything works great.  I had a brief period where I couldn't update the `in_stock` field on the `ingredient`, but the console lovingly told me (after I remembered that the console was my friend) that I had forgotten to permit the `in_stock` parameter in my `ingredient_params` helper.  So that works now.

I *also* got the `recipe` setup working all CRUD-like, and that went much faster.  Mostly because I'm doing the bare minimum to get something that works so I can see where it sucks and make it better.  This has mostly been a good philosophy.

Except.

I'm beginning to work through hooking up the relationship between recipes and ingredients, and it's more complicated than it was in my head.  After some research and reading, it seems that there are two main solutions to this Many-to-Many relationship (because a recipe certainly should be able to have multiple ingredients, but an ingredient should also be in multiple cocktails, unless it's that weird liquor that someone bought you and you can only make like the one thing with it): `has_many through` and `has_and_belongs_to_many`.

Here's the main difference.  `has_many through` assumes there's a third named model in between the two that is its own standalone thing.  For example, if you had a BoardGame model and a Player model, then the relationship between them could be through a Play model or something that kept track of individual game plays.  This is especially nice when the model in between should have data of its own, or functionality of its own.

`has_and_belongs_to_many` creates a Many to Many linkage as well, but only in the database.  You don't have a model in Rails to worry about.  In some ways it's simpler.

"But be careful," the articles that I read said.  "You're probably going to want to add data and functionality to that connecting model later, so even though it's simpler to go with HABTM now, you should probably take the time to set up the intermediate model and do a `has_many through`."

"Ha!  Ha. Ha. Ha. Ha," said I.  "I know better than that.  When in the *whole universe* would I *ever* need *any* extra information about the relationship between recipes and ingredients?  What would I even call it?  It's not a thing!  Sure it's all fine for doctors and patients, but not for *my* models."

So I went with HABTM.  That was last night.  This morning, I sat down and started thinking about what the user experience would be for selecting ingredients.  "A multiselect!" I thought.  "It'll be perfect!"  So I started tinkering.  And then: "Oh.  I need to keep track of how much of each ingredient is in each cocktail.  Farts."

So here I am, writing this article because I can't bear to go back to the drawing board to start on the `has_many through` connection yet.

So, if you're pondering a Many-to-Many relationship, think hard--think *really* hard--about whether or not you think you could *possibly* need any more information at all, now or later, about how these two models are connected.  Don't be like me.  Do the right thing.

## Progress

1. Completed basic CRUD for Ingredient and Recipe.
2. Completed basic views for both as well.

## Next Steps

- Roll back HABTM connection
- Set up new connector model.  I can't think of a good word besides Dosage, and words like Details or Use are to vague and bad.  Maybe a simple IngredientInRecipe or something.

## For the Future

- Get a rough home page in place.
- Deploy to Heroku as soon as I can.
- Create the home page based on a quick and smooth user interaction.
- Styles.  Mobile-first.  After everything works on the back end.
- Take a look at next features, including more intelligence for ABE, user profiles, etc.