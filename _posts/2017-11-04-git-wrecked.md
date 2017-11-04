---
layout: page
title: Git Wrecked — Keeping Your Branches Synced Without Breaking Things
desription: An attempt to document (mostly for myself) the Right Way™ to sync Git branches.
tags: git workflow best-practice oss
cover_image: git-wrecked.jpg
---

Last month, I took part in Digital Ocean's [Hacktoberfest](https://hacktoberfest.digitalocean.com/) event, and it was awesome.  It helped give me the kick in the pants that I needed to get up the courage to contribute to Open Source Software.  It was definitely a great experience (and I got a t-shirt out of it 😬).  With this really being my first time interacting with the [Forking Git Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/forking-workflow), I wasn't exactly sure what to do.  I had seen snippets here and there about how you're supposed to do it, but I wasn't familiar enough with that *or* git commands other than the basic `push, pull, add, commit` commands needed for local/personal Git.  So I thought I'd share a story and what I learned.

## Forking GUI

I was working on some additions to a README for this contribution.  I had already forked the repo, cloned a local version to my machine, created a branch for the fix, made some initial changes, pushed back to Github, and opened a pull request.  So far, so good.  I felt accomplished.

![I love it when a plan comes together](/img/git-plan.gif)

A couple days later, the maintainer got back to me with some thoughts and possible revisions.  Great!  This was real collaboration!  So exhilarating!  I headed back to my local repo, but I noticed that the original upstream repo had had some changes made to it.  Having heard that it was a good idea to keep your local repo and branches up to date, I decided to attempt to refresh everything… but I didn't really know how.  I looked around, but I got intimidated by the official git documentation.  That's when I remembered that I had my handy-dandy git GUI application, [GitKraken](https://www.gitkraken.com/).  I opened it up, and in a couple of clicks, I had updated my `origin` and local branches, made the quick edits I was trying to make, and pushed everything up to GitHub.  Or so I thought.

That night I got a message from the maintainer, asking what these extra files were that I had added to my Pull Request.  To my horror, as I looked at the commit history of my GitHub repo, it was all jumbled up, and I had even included someone else's commit from `upstream/master` in my pull request branch changes somehow.  I was very confused — and mortified.  Not only had I bungled "doing the git", but someone else (and possibly many someones) had seen me do it.

![Oh no.](/img/git-oh-no.png)

Don't get me wrong.  GitKraken is an amazing tool, very pretty, and very powerful.  I just think that I personally should only use it to inspect projects, and not use its editing functionality.  On the command line, when you type a git command, you know that you're changing stuff and it's a big deal.  In the GUI, they make it so easy to just click some buttons and do a lot of potentially dangerous things if you don't already know what you're doing, where I'm used to buttons in a GUI almost always being low-risk and undoable.  I definitely need the extra reflection time required to type out git commands.

But anyway, that leads me to the important part of this post:

## The Right Way™

The goal of this section is to lay out each step of the Forking Git Workflow, with the associated commands, in the correct manner (or, at least, one of the correct manners) so that future me can come back and read this when I inevitably forget.  I'm going to lay this out, but if you see anything that I've done wrong or could do better, be sure to let me know and I'll try to keep this updated with the best practices you share.

```bash
# This is assuming you've already forked the Upstream Repo
# on GitHub/BitBucket/GitLab/etc.

# Clone to get an initial local copy.
git clone <url-to-your-fork>

# Add a remote link to the upstream repo
git remote add upstream <url-to-upstream-repo>

# Create a new branch for the feature/fix that you're doing
git checkout -b <new-branch-name>

# Do some work, edit some files
git add <files>
git commit -m <your-commit-message>
```

Oh no!  The `upstream` and/or your `origin/master` and/or your `origin/<branch-name>` had changes made to it that aren't on your local machine.

```bash
# Inspect the changes made to origin
git fetch origin

# Update your branch
git merge origin/<branch-name>

# Update your master
git checkout master
git merge origin/master

# Inspect the changes made to upstream
git fetch upstream

# If you don't have any commits on master ahead of upstream,
# you can just pull the upstream changes in
git checkout master
git merge upstream/master

# If your master branch is ahead of upstream, you may want to rebase
# In order to "work on top of" everyone else's changes, instead of merging
git rebase upstream/master

# Now that your master branch is up to date, you can decide whether
# or not you want to rebase your feature branch onto the new
# tip of your master branch.  Generally a good idea.
git checkout <your-feature-branch>
git rebase master

# OR, if you're about to submit a pull request and you  want to
# clean up your commit history, do an interactive rebase and
# squash and otherwise clean your commits/messages
git rebase --interactive master

# Finally, push your updated branch
git push -u origin <your-feature-branch>

# Sometimes, rebasing rewrites history, and pushing won't work.
# Try --force-with-lease, which is the safe way to force the push
# through.  More on that later
git push origin <your-feature-branch> --force-with-lease

# Optionally, push everything to update your origin/master too
git push origin --all
```

## What is Git Rebase

Git Rebase confused me.  I don't know that I can provide a better/more picture-laden explanation than the [Atlassian Tutorial](https://www.atlassian.com/git/tutorials/rewriting-history/git-rebase).  Here's the short version for the extra-lazy.

1. Your feature branch branched off of master at a certain point, called the "base".
2. Rebasing points this "base" to a new place, often moving it forward to the new head of another branch.
3. During this process, you can reword commit messages, re-order commits, delete commits, and squash commits together.
4. In general, you should never rebase something that is already pushed to a public place, *especially* if there's a possibility that somebody else already began working on the things that your rebasing.  Try to rebase *only on your local system*.
5. During the pull request progress, once you've submitted the initial request, you'll be asked to update/modify your original pull-requested code, which will add mulitple commits to the pull request history.  You'll be tempted to squash these to keep the pull request looking pretty and concise.  **Resist this urge.**  After doing research, it seems like a) doing so would violate #4, and b) a pull request is supposed to be a forum/record of the discussion, and if you go rewriting things to hide all of the intermediate changes, nothing will make sense and you'll miss out on that history.
6. Remote repositories don't necessarily like this rewriting history.  Often, a simple `git push` will be rejected.  Doing a `git push --force` will force the remote repo to accept the push, but you probably shouldn't be using `--force`.  The safe way is to use `--force-with-lease`, which only allows a force if it won't mess anybody up.   Well, most of the time.  Read [this post about —force-with-lease](https://developer.atlassian.com/blog/2015/04/force-with-lease/) and the dangers of fetching and pushing without first merging.

## Wrap Up

Like I said at the beginning, I've been learning this workflow for the last two weeks, so I am by no means anything more than a beginner.  Hopefully this helps, and hopefully people smarter than me will let me know if I got anything wrong here.  Shoutout to the [Exercism Ruby Track team](https://github.com/exercism/ruby/pull/760) that has been so patient with me as I bumble through my contributions.