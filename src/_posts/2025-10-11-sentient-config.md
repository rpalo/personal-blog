---
layout: page
title: Sentient Config is a Code Smell
description: |-
  Config is good, but when it gets too powerful, it often indicates
  a need for actual code and better underlying libraries.
tags:
  - legacy
  - design-intent
  - best-practice
  - code-quality
---

Stop me when this starts to feel familiar:

1. You build a really cool app that does a thing.
2. You have another use-case for the app, but maybe for a slightly different
   setup. So you add some configuration variables, maybe via environment
   variables or CLI args.
3. This works well, and you start to dream bigger. More use cases spring to mind
   that are _effectively_ the same app, but with more tweaks. More configuration
   variables are needed. You evolve to _config files_.
4. Config files allow you to go bigger. More workloads, all running on the same
   base code! But suddenly, your base code doesn't quite do the thing you need
   it to. Suddenly your config values, no matter how nested and complex, can't
   get you to where you need to be. That's when the whispers start.

_"These config files let me inject functionality into code. Code is
functionality. In fact, why couldn't I just inject a little code from a config
file. Then I wouldn't even need to make a pull request."_

It is at this precise moment that you need to SNAP OUT OF IT. Much like Frodo
with the One Ring, I'm being your Samwise Gamgee right now. Stop. It.

Look at where you are. You were just giddy about being able to "inject" code
into your app without "having" to go through the "pain" of making a pull
request. Do you see what the config file whispers have done to you?

## Beware the Sentient Config

I _hope_ that you've only experienced the brief wondering if hardcoding Python
in YAML strings is really that bad. I hope you haven't gone down the road that
some go: the road to mini-programming-languages-as-config.

If your config starts to become semi-executable, or--heaven
forbid--Turing-complete, you may want to take another look at your architecture
and see if there aren't some quality-of-life improvements to be made. Here's an
example similar to some sentient config in a legacy app I worked on:

```json
{
  "title": [
    ["regex", "(\w+\n===================)"],
    ["split"],
    ["strip"],
    ["replace", "&amp;", "&"]
  ]
}
```

_(sobs in JSON)_

Because, while the above isn't terrible, 1. it's possibly not under source
control, and 2. it would be 5% more readable in actual code, and 3. it's an
active gateway even more Turing. How long does this go on before you start to
really crave an `if` expression, or--OK, maybe not that, but perhaps just a few
boolean `ands` and `ors`? Or, perhaps, `map`, `reduce`, `filter`, and a `first`?

## Consider a Different Mindset

At times like these, it's important to ask ourselves: "What are we doing here?
What's our goal?"

At least in our case, one issue we had been seeing is that our "custom code
modules" were all bundled together in a package which the main app installed as
a dependency, so anytime we wanted to tweak one specific custom module, we'd
have to make that PR and deploy that new version, bump it in the main app, and
bump that app's deployments, only to find out that we had a small bug and
another round of PR's followed. This was understandably frustrating. So the
workaround was more sentient config that we could configure live, on the fly,
with fewer hoops to jump through.

But, as we took a step back to reflect (right around the time we started
drafting proposals for `if` statement syntax), we realized that we could do with
an inversion:

Our "main app" became our "base library." Our "custom modules" became individual
"main" modules that extended, expanded, and customized our new base library. And
we gained the following benefits:

- We dropped one or two bump-and-redeploy cycles per code change.
- We were able to really hone and polish our new "base library" because it
  wasn't yet overcomplicated by so many config variables.
- Our base library stopped changing so frequetly to accomodate new edge cases.
- The previous two points allowed us to dramatically and confidently increase
  our test coverage of the base library, knowing we wouldn't have to rewrite the
  tests in a month.
- Debugging, fixes, and new apps/module development saw huge speedups, because,
  now our engineers weren't trying to figure out where the bug was in our awful,
  lightly documented, poorly tooled quasi-Lisp, they could quickly debug in
  Python code with Python tools like the grown, strong, independent software
  engineers we hired them to be.
- Onboarding got faster because new hires already knew Python and didn't have to
  learn a new "language" (with those quotes doing lots of deeply malice-filled
  work here).

## Inherit with Caution

I want you to hear me very clearly here. I am _not_ advocating for you to go
forth and design up 52 layers of `BaseMiddleGenericAbstractMixin` classes to
override. Some inheritance may make sense. Some composition via components
probably would go a long way. But, just because you're planning on "extending
the base functionality" in your individual apps doesn't mean that it _has_ to be
done via way too much inheritance.

## Let Them Code

Was there a setup cost to rework the main app into a base library? Sure. And
there was even more cost to make sure it was a good, easy-to-use library with
excellent documentation. But all of the productivity, cleanliness, and quality
benefits mean that all that work was a sound investment in a stable future with
a solid foundation to launch from.

Any time you feel like you're running up against a wall because, "Augh, it would
be so easy to fix in code, I just want to write some code here," the answer is
_probably_ that you should be able to write your solution in code rather than
config. Just... make sure that code is your team's main language and not your
team's internally written "good-enough" config-garbage-slop-monster.
