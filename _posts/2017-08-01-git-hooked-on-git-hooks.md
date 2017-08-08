---
title: Git Hooked on Git Hooks
layout: page
description: A beginner's overview of git hooks to automate your process
cover_image: hook.jpg
tags: git
---

I found something cool that either should be more popular than it is, or it is popular and it should be taught to new programmers sooner than it is.  They are called Git Hooks.  I'm going to write this post assuming you know what Git is, and assuming you're comfortable with the general process of code, stage, commit, lather, rinse, repeat, push.  If you're not, Here are a [few](http://rogerdudler.github.io/git-guide/) [good](https://www.sitepoint.com/git-for-beginners/) [resources](https://git-scm.com/book/en/v2/Getting-Started-Git-Basics).  (Note, those are three separate links, not one long one).

## The Background

Git hooks are scripts that, if enabled and set up properly, get fired at certain times in the git process.  Here is a list of the available hooks:

1. `pre-commit`: Runs first, before a you even enter a commit message (assuming you don't use -m for messages).
2. `prepare-commit-msg`: Runs before displaying the commit message to you for editing.  This is good for templating commit messages.
3. `commit-msg`: Runs after you hit save on the commit message, but before the commit goes through.  Useful for enforcing commit message standards.
4. `post-commit`: Runs after the commit is saved and completed.  Used for notifying or status updating usually.
5. `pre-rebase`: Runs before a rebase occurs.  Git's default example script for this makes sure you haven't pushed before you rebase (since that could cause issues for other people).
6. `post-rewrite`: Runs after a commit is replaced (e.g. with `git commit --amend`, `git rebase`).  Good for generating documentation or copying in untracked files.  Think `npm install` or similar, maybe.
7. `post-checkout`: Runs after `git checkout`.  Similar to #6.
8. `post-merge`: Runs after `git merge`.  See #6.
9. `pre-push`: Happens before a push completes.  You can use it to abort the push if need be, similar to `pre-commit`, but for pushes.

In addition to these, there are a few hooks available for an email-based workflow (i.e. when people are emailing you patches to merge).  There are also a few available on the git server side that are useful for deployment.  I'm going to skip all of these for now, and just focus on a really basic case (mostly because that's about where my skill level is at right now).

## Hook It UP

So let's do it!  For my example, I'm using Python because of course I am, shut up.  I'll walk through this with you step by step.  First, create a new project folder.

```bash
$ cd ~/Desktop
$ mkdir hooky && cd $_
```

Create a new Python file called `hooky.py`.  Note that I'm going to purposefully use poor style for our example.  You'll see why in a minute.

```python
# hooky.py

def hook( quantity ):
    return "---u<><"*quantity

if __name__ == "__main__":
    print(hook(3))
```

Now let's initialize our git repository.

```bash
$ git init
$ git add hooky.py
```

Before we commit, take a look at the `.git/hooks/` directory.  Also, if you haven't, install `flake8`, which is one of many linters for Python.  If you're following along in another language, install an equivalent linter.  Normally, we'd use a virtual environment, but a linter is a handy thing to have around globally.

```bash
$ ls -l .git/hooks/
$ pip3 install flake8
```

You'll see a bunch of samples that you should look through later.  They've got some neat ideas in them.  For now, we'll create our own `pre-commit` hook.  Create `.git/hooks/pre-commit`.  Make sure there is no file extension.

```bash
#!/usr/bin/env bash

# This is the pre-commit file
echo "Linting code before commit..."
flake8
```

Now, make sure that your script is executeable and we can attempt to commit.

```bash
$ chmod +x .git/hooks/pre-commit
$ git commit  # omit the -m for example's sake.
              # if you include a message, it will still work
              # you'll just waste your time typing a message
```

Boom!  Flake8 complains about our 💩 style.  No commit.  Prove it with `git status`.  Note the files are still staged, but not commited.  But why no commit?  For `pre-commit` hooks, if the script exits with any other status but zero, it cancels the commit.

![Cancelled!](/img/git-cancel.gif)

`prepare-commit-msg`, `commit-msg`, `pre-rebase`, and `pre-push` all do similar things.  That's pretty much it!  Great right?  Go forth and hook away!  Just to drive this home, I want to illustrate one more similar use case.  This is extra, so feel free to skip it if you're already too excited you can't wait to try it yourself.

## Bonus Example

Create two new files: `__init__.py` and `test_hooky.py`.  `__init__.py` will remain blank, but here are the contents of the test file.

```python

from hooky import hooky   # From this dir, import the module

# This test should pass
def test_hook():
    assert hooky.hook(3) == "---u<><---u<><---u<><"

# This one will fail because there is no such method (yet).
def test_release():
    assert hooky.release("---u<><") == 1
```

Now, update your `.git/hooks/pre-commit` file.  Again, if you haven't yet, intall pytest (an awesome testing framework) via pip.

```bash
#!/usr/bin/env bash

# This is the pre-commit file
echo "Linting code before commit..."
flake8

echo "Running tests..."
pytest
```

Now, running `flake8`, go back into your `hooky.py` file and fix all of the warnings until `flake8` is appeased.  Then try committing again.  You should see it blow up with the broken test!  Feel cool?  Good, because you are cool.  And it's not just the git hooks.  Although they add to your overall coolness, you were already cool.  So how about that?
