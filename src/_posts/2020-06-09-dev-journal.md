---
layout: page
title: "Dev Journal 6/8/2020: Avoid the Pull of the Rabbit Hole"
description: I needed to work through a tornado of thoughts, ideas, bad ideas, problems, and potential solutions after todays research session.
category: devjournal
tags:
- rails
- javascript
- devjournal
---

I learned a lot today, and I will be compiling everything into one or more well-edited, logical, and nicely-put-together topic-specific articles.  I did a deep dive into the Rails docs for connected models, forms, forms based on models, and all of the recommended helper methods and best practices therein.  There’s a lot of good information, and I want to help other people find that information too.

But this is not that article.  I’ve got a lot of ideas and thoughts spinning around in my brain, and this article will be my unceremonious dumping ground for them before I move on to mold tool design and infant care and forget everything.  Forgive me.

- - - -

OK!  Today I worked on figuring out how to create a form that allowed a user to add an unknown number of existing or non-existing Ingredients to a Recipe along with information like quantity and units (e.g. 2 dashes, 1 1/2 oz., etc.) under the name I’ve tentatively selected: Parts.  As in “Parts of a Recipe.”

I wanted to figure out what the _Rails_ way is, because, I assumed this has to be a pretty common use case, right?  What I actually ended up finding was a conglomeration of various StackOverflow answers and blog posts that spanned several different versions or Rails with all of the changes of conventions that come along with that.  And most of these answers were what that particular author had done as a kludge and then presented as The Right Way™.

Then (and I’m pretty proud of this) I had the bright idea to actually READ THE MANUAL and go to the Rails Documentation.  This was an excellent idea.  I truly _am_ amazing.  As it turns out, the Rails Docs have documented not only the canonical Rails way to approach things but some alternative methods that might also work, reasons and pros and cons for each of these alternatives, warnings for trouble spots you might hit, and—to top it all off—up-to-date idioms, code, and helper methods from this current version of Rails.

I think that I will rarely look anywhere else for answers.  This was a good experience.

Now comes the not-so-good news.  In my research and fiddling around, I better crystallized what I want the interaction to look like (probably should have written that out first—lesson learned).  And this created a rabbit hole.

A user goes to create a new recipe.  They can look up an ingredient in a search box that shows them existing ingredients.  They select the ingredient and inputs come up that allow them to enter quantity and units.  And the pattern repeats.  There is also an option for “Create a new ingredient” nearby/in the results box because it would be a pain to have to leave this new recipe to go create one or more ingredients before coming back to the main flow.

After looking through all the docs and their recommendations, it seems (and this matches what my gut kind of thinks) that this is a job that calls for a JavaScript-powered form.  I don’t want to pass all of the records into JavaScript inside an HTML template using Ruby, because that feels dirty.  It seems cleaner to have a simpler controller and less Rails helpers designed to get me _around_ JavaScript and HTML and, rather, fetch the data in the background with JavaScript, create new ingredients via the API and then, when the form is finally submitted, send a nicely crafted, coherent POST request with everything Rails expects to see.

So I’m struggling to take small steps in this.  It seems like a waste of time to dive into all of the Rails helpers and build out an elaborate solution made of collection select tags if I know that’s not at all what I’ll eventually want.  But I also don’t want to leap from problem to problem (oh, now I need a framework, now I’ve got to learn Vue, now I need to figure out how to manage state, now webpack, now toolchain, now I’m dead.) and never get to any stable, workable points where the app maybe isn’t as fancy as it could be but at least it _works_ so I can **ship it**.  But also, like, if something is worth doing, it’s worth doing right, right?

So that’s where I’m at.  I feel like I’ll probably just get a minimal either Vanilla JavaScript or Vue form in place without investing too much in a complicated toolchain.

Or.  And I’ve just thought of this.  For now, maybe I’ll just put the ingredients as text in the main recipe text.  And then I can ship.  And then I’m not building something that I’m planning on scrapping later.  And I’m investing literally _zero_ effort into it.  And I can **Ship.  It.**  Because, really, the reason the ingredients are separate is for other features like being able to tell what cocktails I can currently make and helping me figure out what to buy which are only secondary to my _real_ MVP, an online menu/repository of cocktails that I know how to make.

_Sigh._  Oh man that feels good.  I felt like I was drowning in complexity with no way out other than a huge leap of faith and hope that I wouldn’t forget what I was doing or give up halfway through.  These are smaller steps that I know I can take.

Bam.  Journaling is the best.  Thanks, Internet!  I’ll check in next time once I’ve dramatically simplified my life and—you guessed it—**shipped it.**

## Progress Made

* Found Rails Docs
* Read lots of docs about forms and models and HTML attributes
* Wrote partial Rails, ERB, JavaScript, hybrid monster that won’t work
* Searched soul
* Found better way

## Next Steps

* Remove everything but the Recipe model
* Simplify Recipe model
* Make it shippable
* Add recipes
* Ship it
* Add login capability so I can create recipes from my phone?
* Add styling to improve menu interface for users
* Convert recipe generation form to JavaScript
* _Then and only then_ add ingredients
