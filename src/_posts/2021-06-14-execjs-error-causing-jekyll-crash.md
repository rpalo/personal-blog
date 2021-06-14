---
layout: page
title: "Solving error ExecJS error that breaks Jekyll on Rebuild"
description: Updating my blog after 6 months took a lot more than I initially thought it would.  Oy...
tags:
- jekyll
- bugs
---

Hi!  I'm back.  I was finishing up my Master's program, slogging through the last 6 months of thesis coupled with about 9 months of extremely stressful work time that all adds up to a whole buttload of burnout.  I'm real burnt out.

However, now that it's over, things are improving.  I opened a code editor today, and that's a huge step.  I have a couple of coding books on my holds list for our library.  Things are starting to not seem like an insurmountable amount of effort anymore.  We're doing great.

"So, why not put myself back out there?" I thought to myself.  I'll just update my resume (🎉 I'm a Master of Computer Science now, after all! 🎉) and get things rebuilding again.

Bonk.  Wrong.  Error.

The fix was a little convoluted, so I thought I would write it up.  TL;DR version: keep your crap updated.  Broken `xcode-select` tools after a Mac OS upgrade led to un-updatable ruby versions, homebrew versions, and finally a Jekyll dependency I have.

Other takeaway: Ryan, just write your own static site generator in C with no dependencies, it'll be fine.

## Initial Investigation

I've got a weekly job that triggers a rebuild of my Netlify site just so I don't have to remember to push everything all the time, and I can keep track of really huge supply chain changes.  I had been seeing build errors for a couple of weeks (burnout, remember?) and apparently I was about to deal with them.

So, first things first: open up the repo, try a clean build, and see what happens.  I deleted the `Gemfile.lock` and ran `bundle` to reinstall everything to see how that went and what got updated.  This usually fixes most things.

Then I went to build the site:

```shell
bundle exec jekyll serve
```

This started well but dropped me with a 100% opaque error message:

```text
                    ------------------------------------------------
      Jekyll 4.2.0   Please append `--trace` to the `serve` command 
                     for any additional information or backtrace. 
                    ------------------------------------------------
```

Great.  Thank you so much.

```shell
bundle exec jekyll serve --trace
```

This error message was better:

```text
bundler: failed to load command: jekyll (/Users/ryanpalo/.rbenv/versions/2.6.5/bin/jekyll)
ExecJS::ProgramError: TypeError: Cannot read property 'version' of undefined
  eval (eval at <anonymous> ((execjs):1:213), <anonymous>:1:10)
  (execjs):1:213
  (execjs):19:14
  (execjs):1:40
  Object.<anonymous> ((execjs):1:58)
  Module._compile (internal/modules/cjs/loader.js:1236:30)
  Object.Module._extensions..js (internal/modules/cjs/loader.js:1257:10)
  Module.load (internal/modules/cjs/loader.js:1085:32)
  Function.Module._load (internal/modules/cjs/loader.js:950:14)
  Function.executeUserEntryPoint [as runMain] (internal/modules/run_main.js:60:12)
  [...SNIP...]
  /Users/ryanpalo/.rbenv/versions/2.6.5/bin/jekyll:23:in `<top (required)>'
```

ExecJS was breaking something some kind of way.

## ExecJS was broken?

After some searching around, I came upon [this GitHub issue comment](https://github.com/rails/execjs/issues/99#issuecomment-837369385) which I'll copy the pertinent info from to save you a click:

> This is related to using Ruby < 2.7. If you must stay on Ruby 2.6 or earlier, you probably need to stay on execjs < 2.8. The other option is to upgrade to Ruby 2.7 or above. Adding this here for posterity and anyone else running into that rough error message :)
>
> Two solutions:
> 
> 1. Upgrade to Ruby 2.7 or later
> 2. Downgrade to execjs 2.7 or earlier.

## Out of Date Ruby

I looked up what the current stable Ruby version was and discovered I was behind by a whole minor version and more.  Whoops.  Time to upgrade to `2.7.3`.  I could and should probably upgrade to 3, but I can do that later after I get things unbroken.

My first step was to add that version to the versions available to `rbenv`.

```shell
$ rbenv install 2.7.3
ruby-build: definition not found: 2.7.3

See all available versions with `rbenv install --list'.

If the version you need is missing, try upgrading ruby-build:

  brew update && brew upgrade ruby-build
```

OK, my `ruby-build` database is out of date.  That's fair.  Let's get that updated.

## Out of Date `ruby-build`

This one seemed easy enough: just follow the prompt:

```shell
$ brew update && brew upgrade ruby-build
Error: homebrew-cask is a shallow clone. To `brew update` first run:
  git -C "/usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask" fetch --unshallow
This restriction has been made on GitHub's request because updating shallow
clones is an extremely expensive operation due to the tree layout and traffic of
Homebrew/homebrew-cask. We don't do this for you automatically to avoid
repeatedly performing an expensive unshallow operation in CI systems (which
should instead be fixed to not use shallow clones). Sorry for the inconvenience!
```

Fart!  OK, that's fair.  We can play by their rules.

## Out of Date Homebrew (False rabbit hole, but still probably good to fix)

Once again, following the instructions: 

```shell
git -C "/usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask" fetch --unshallow
```

This updates Homebrew for me.  Just for those of you glancing through quickly, this didn't solve my overall problem, but it was probably healthy for my system overall.

## Out of Date Command Line Tools??

After running the upgrade command again for `ruby-build` I hit another error message, which I probably could have spotted before:

```text
Error: Your CLT does not support macOS 11.
It is either outdated or was modified.
Please update your CLT or delete it if no updates are available.
Update them from Software Update in System Preferences or run:
  softwareupdate --all --install --force

If that doesn't show you an update run:
  sudo rm -rf /Library/Developer/CommandLineTools
  sudo xcode-select --install
```

OK, not sure what a CLT is, but I vaguely remember YOLO upgrading a major version of Mac OS in the last couple of months.  Thanks for that, past me.  [This StackExchange answer](https://apple.stackexchange.com/a/406529) confirmed that could be my issue.  Time to follow instructions again:

```shell
sudo rm -rf /Library/Developer/CommandLineTools
sudo xcode-select --install
```

I just about died as the installer estimated 8 hours to complete, but it completed in just about as long as it took me to get to this point in the writeup.  Maybe 5 minutes--my laptop is a little old.

## Back Up the Traceback Chain (Hopefully): Updating `ruby-build`

OK, we're back on track.

```shell
brew upgrade
```

No error message, so far so good.  Now to install the version of Ruby I need.

```shell
rbenv install 2.7.3
```

Bonk.  No 2.7.3 version available.  Crap.  Double-check `ruby-build` is up-to-date: check.  Well, let's see what versions *are* available:

```shell
$ rbenv install --list
2.5.8
2.6.6
2.7.2
jruby-9.2.13.0
mruby-2.1.2
rbx-5.0
truffleruby-20.3.0
truffleruby+graalvm-20.3.0
```

OK, that's weird that it doesn't show the most recent, but let's chalk it up to maybe the Homebrew package not having the latest yet.  I checked the [`ruby-build` repo](https://github.com/rbenv/ruby-build) and it shows `2.7.3` available, but, just to get things running, let's just get what we can: 2.7.2.

```shell
rbenv install 2.7.2
```

See you in several hours...

## Updating the Ruby Version in the Repo and Re-Installing Dependencies

OK!  We're back.  The next step is to make sure Bundler is using the right version to do things.  I've got a `.ruby-version` file in my repo.  We'll just update that to 2.7.2, delete the `Gemfile.lock`, and try re-installing all the dependencies.

```shell
bundle
```

## Running the Build (Fingers Crossed)

Hope this works!

```shell
bundle exec jekyll serve
```

Son of a nutcracker!  Same ExecJS error!

## Pinning ExecJs to version 2.7

After returning to the ExecJS repo and reading further, apparently upgrading to Ruby 2.7 (or even 3.0) is a silver bullet.  Multiple libraries including some JSON-parsing ones are tied into the same issue which apparently is a problem where they are trying to auto-detect versions of local programs using Node.  I've got *lots* of thoughts on that for a Ruby library, but I'll bottle them deep down inside for now.  One user suggested just manually pinning ExecJS to `2.7` in your Gemfile.  [Here's the commit.](https://github.com/Walls-to-Walls-Cleaning/website/commit/c0e76ee1d881878bc4aa69bd4a148eaa81c52a74)  Sounds like as good a fix as any.

Update my Gemfile:

```gemfile
gem 'execjs', '2.7'       # Locking it due to an issue affecting node version checking
```

Delete the `Gemfile.lock`, run `bundle` to re-install, confirm version `2.7` has been installed, and rebuild again!

```shell
bundle exec jekyll serve
```

Success!  Brilliant, brilliant success!  And there you have it, my Monday morning rabbit hole.  Thanks for reading!  Hopefully more posts to come as I start feeling better.
