---
layout: page
title: Scheduling Jekyll Posts on Netlify with Cron
description: A write-up of an answer to a question somebody emailed me.  Automated published posts with no manual intervention required.  Write it, schedule it, and relax.
tags:
- jekyll
- cron
- netlify
- automation
---

I had someone email me a question about how I schedule my posts on my Jekyll-powered blog.  Short answer: I don’t.  But.  That’s not to say that it’s not doable.  It is!  People have been scheduling computers to do things for almost as long as there have been computers.

I’d like to say that there are a lot of ways to solve this problem, and they all have their pro’s and con’s.  However, the person that e-mailed me asked about _this specific method,_ so that’s what the post is about.

Netlify is amazing.  If you’re hiring, Netlify, let me just say that you’re amazing and I’d love to work for you.  They allow for so much freedom and flexibility in how you want to handle your build/deploy pipeline and where and when you can hook into it.

We’re going to use cron (or some other method, see the last section) to send a POST request to Netlify’s Build Hooks endpoint to cause them to re-build our site for us.  All of the Jekyll posts with a date in the past at that point will publish themselves.  You could feasibly extrapolate this out into a whole deploy script/process that deployed your site, tweeted out the new article, and ordered you a celebratory pizza.  It all depends on how creative you can be.

## Prerequisites

1. You need to have a site already set up on Netlify and all configured.  My current setup is a git repo on GitHub, and Netlify is set up to build anytime I push a new commit to the repo.
2. This article assumes you have a Mac or Linux machine with `cron` available to you.  You can check this by typing `crontab -l` into a terminal.  If it tells you something about not having a crontab for your user, you’re good.  All of the fundamentals are possible on Windows machines too, but the names of the tools are a little bit different and I’m not going to cover that in this article.  If you’re on Windows and would like some help through this process, don’t hesitate to [reach out to me via e-mail or social media](https://assertnotmagic.com/about).
3. Part 2 will involve editing a text file in the terminal.  By default, when you go to edit a crontab file, the shell uses your `EDITOR` environment variable.  If you haven’t set this up, it may default to something like `vi` or `vim`.  Possibly `nano`.  I’m going to assume that you’re familiar with some command line text editor.  I’ll address how to pick that particular one in the next part.
4. You’ll need some command-line method of making a web request.  I’m going to show you using `curl`.  If you prefer `wget` or Python’s `requests`, that’s OK too.  I’m going to assume you can translate a `curl` request to your favorite requesting method, but, again, if you’d like help, hit me up.  Run `curl --version` to make sure you’re all set.  Use your system’s package manager to install `curl` if you don’t have it yet.

OK.  All set?  Cool.  

## Part 1: Setting Up the Build Hook

The piece we are going to be using is called “Build Hooks.”  It’s essentially a URL that you can send a POST request to to trigger a build of your site.

Open up your site dashboard on Netlify and head over to the Build and Deploy settings.  About three sections down, you’ll see a section titled “Build Hooks.”  Click “Add Build Hook,” give it a descriptive name so you’ll remember why you made this hook in a year, and confirm it.  You’ll see a URL of the pattern: “https://api.netlify.com/build_hooks/xxxxxxxxx”.  That’s what we need.

## Part 2: Setting Up Cron

In this step, we’ll set up a the scheduled job so that it pings the build hook we created on some sort of uniform schedule.  

**Please note:** If you’re doing this on a laptop or other computer that you put to sleep frequently, cron jobs won’t run while the computer is asleep.  Check out my notes in the next section to address this issue.

If you’ve got your `EDITOR` variable already set up, then editing your crontab (table of cron (schedules) jobs for your user) is a pretty short command:

```bash
crontab -e
```

If you want to ensure that you get a specific editor, e.g. `nano`, do it like this:

```bash
EDITOR=nano crontab -e
```

And then we can add our job.  Here’s what you need to know about cron.

1. Cron ignores blank lines and trims leading spaces.
2. Any line that starts with a `#` is ignored as a comment.  Comments are good and you should do them.
3. You can’t comment and have a meaningful line on the same line.
4. A meaningful line can be an environment variable setting or a scheduled job.
5. Variable setting lines take the form `name=value`.  Cron fills in a few defaults for you:
  * `SHELL=/bin/sh`
  * `PATH=/usr/bin:/bin`
  * `HOME=<your user’s home directory>`
  * `MAILTO=<your username>`
6. You can re-set these to whatever you want.  Personally, I have `SHELL` set to `/bin/zsh` and `MAILTO` set to `””`.  If there is a value for `MAILTO`, that user will get a terminal notification when their job runs.  If it’s set to blank, no notification will be sent.
7. Job lines take the form:

  ```cron
  * * * * * command
  ```
  Where the stars stand for these values, in order:
	
* Minute
* Hour
* Day of Month
* Month (numerical, 0 is Jan, or first three letters, case-insensitive)
* Day of Week (numerical, 0 is Sunday, or first three letters, case-insensitive)

There are also a bunch of built-in ease-of-use shortcuts like `@yearly` that you can use instead.  Enter `man 5 crontab` for more details.

So if you put `0 7 * * Thu touch ‘hi.txt’`, every Thursday at 7AM, cron will poke the `hi.txt` file for you.  Keep the very limited path in mind, and if you’re worried about portability at all, be sure to fully, explicitly spell out any paths.

So, we’ll do almost the exact example I just showed you, combining it with the command provided by Netlify’s ever-so-helpful web interface, and enter this into your crontab file:

```cron
0 7 * * Thu curl -X POST -d '{}' <your build hook URL here>
```

Make sure you save and exit, and run `crontab -l` to list out your crontab and make sure it worked.

## So how does this help me schedule my posts?

By default, if the date of a Jekyll post is in the future (as of Jekyll 3, and we’re now up to Jekyll 4.1.1), Jekyll won’t build/publish the post.  There are two exceptions to this:

1. If the `--future` flag is used with the `jekyll build` command.
2. I’ve found notes that suggest that sites built using the GitHub Pages around Jekyll have `--future` set by default (although these references are reasonably old, so maybe they’ve fixed it.  If you’re seeing issues, try putting `future: false` in your `_config.yml`.  That may help.

Anyways, you can happily put dates in the future for when you want your posts to actually be published, and they won’t be published until that date (allow for +/- a day to be safe depending on server timezone).

## But what if I close my laptop?

If your computer is asleep when the cron job time occurs, it just won’t do it.  There’s no catching up later.  You just miss it.  But we have options:

1. Don’t let your laptop sleep.  Eeeeeever…
2. Schedule your jobs when you know your laptop will be on and open.
3. Check out `anacron`, which is similar to cron but a little different, and more targeted towards people on laptops rather than people with servers (see the link below).
4. Rent a VPS from DigitalOcean or whoever and run cron there.
5. Run the cron job on a server you have lying around the house.
6. Check out one of the gabillions of free/cheap cron services online that will run cron jobs for you.
7. Go one step further and just use an integrated service like Zapier or IFTTT to send the HTTP POST request on a schedule.
8. Hook into GitHub Actions and have it commit or POST request to trigger a build one way or the other.
9. Use some sort of other Lambda/Serverless Function to send the POST request.  Heck, Netlify even offers serverless functions.  Keep everything in the same place!
10. Pay your little brother to sit by the computer and push “Deploy Site” every week.

## Automation frees you up to do more interesting things

Hopefully this helps!  Now you can spend less time mechanically deploying your site and more time writing whatever’s on your mind and knowing it’ll be published at just the right time.  Happy scheduling!

## Resources

* [Build hooks - Netlify Docs](https://docs.netlify.com/configure-builds/build-hooks/#parameters)
* [Schedule jobs with crontab on macOS - Ole Michelsen](https://ole.michelsen.dk/blog/schedule-jobs-with-crontab-on-mac-osx/)
* [Setting Up a Basic Cron Job on a Linux Server - Tania Rascia](https://www.taniarascia.com/setting-up-a-basic-cron-job-in-linux/)
* [Scheduling Cron Jobs with Crontab - Linuxize](https://linuxize.com/post/scheduling-cron-jobs-with-crontab/)
* [Jekyll notes on `--future` upon upgrading from 2.x to 3.x](https://jekyllrb.com/docs/upgrading/2-to-3/#future-posts)
* [How to: Deploy GitHub Pages on a Schedule to Publish Future Posts - SeanKilleen.com](https://seankilleen.com/2020/02/how-to-deploy-github-pages-on-a-schedule-to-publish-future-posts/)
* [Cron Vs Anacron: How to Schedule Jobs Using Anacron on Linux](https://www.tecmint.com/cron-vs-anacron-schedule-jobs-using-anacron-on-linux/)