---
layout: page
title: Publish Single Directories to Another Branch
description: I can't believe I didn't know about this command at all, but it helps me publish a javascript project's dist folder to GitHub Pages.
tags: git tricks
cover_image: subtree.jpg
---

Quick Tip!

Let's say that you're just like me.  You've been working on a web project: HTML, CSS, and maybe some JavaScript.  You're done and you're ready to show the world your project, so you want to get it built, compiled, minified, and put it somewhere.  But how?  `git subtree`.  I'll show you.  One command.

*Also, did you see the cover image?  Subtree?  HA!*

Let's assume you've got a project laid out like this:

```text
my-dope-project
|- README.md
|- src
|   |- index.html
|   |- css
|       |- styles.sass
|   |- js
|       |- main.js
|       |- helper.js
|- dist
|- webpack.config.js
|- package.json
|- .gitignore
|- node_modules
    |- OMG so much stuff
```

Or something.  I don't know your life.  So you build your site with a `npm run build`.  Now your `dist` directory is full of your beautiful bundled new site.  So how do you put it up somewhere?

## 1. Make sure the dist folder is actually checked into your repo.

Get it out of your `.gitignore` and `add/commit/push` it.

## 2. Use the Subtree, Luke (and/or Leia).

```bash
$ git subtree push --prefix dist origin gh-pages
```

Here, `dist` is the directory subtree you want to publish.  `origin` is the remote repo you're pushing to.  `gh-pages` is the name of the remote branch you want to push to.

Then go to your GitHub and into your repo settings.

![GitHub Pages Settings](/img/gh-pages-settings.png)

Set the branch that you created to be the public branch.  And that's it!  Head to `<your-username>.github.io/<repo-name>` and do your happy dance!

I know that there's about a thousand ways you could skin this particular cat and they all have their pro's and con's.  I just really wanted to share this particular approach because I thought it was neat.  Happy coding!