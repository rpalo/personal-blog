---
layout: page
title: Keep VS Code from Becoming an IDE
description: I like quick, light text editors and terminals, not big IDE's.  This is how I keep VS Code how I like it.
tags: editors vscode
cover_image: vs-code-icon.png
---

Some people like a big, heavy, comfy IDE.  Some people like a light, zippy, relatively simple text editor and a terminal window.  And some people like Emacs.  We don't talk about them.  (I'm joking, I'm sorry, I couldn't resist.)  I'm part of the zippy editor/terminal group.  This is a tip to help keep the VS Code editor lightweight, like you've come to know and love.

I was using [VS Code](https://code.visualstudio.com/) last week, and it was starting to feel really sluggish.  It seemed like it was eating a lot of memory up (relatively) and I wasn't sure what was happening.

And then it hit me:

## I Had Too Many Extensions Running

I love tools.  Especially new shiny ones.  I don't think I'm alone on this.  Because of this, I frequently install new extensions just to try them out and kick the tires a little bit.  I then promptly forget about them, and leave them not only installed but also activated.

Each one of these extensions takes up memory, and uses battery, and slows you down.  They can add time to startup speed, too.  Keep in mind, my laptop isn't all that burly, and a new computer or more memory isn't in the cards for a little while, so every little bit of memory I can conserve is worth it.

## Here's the Fix

Turn them all off.

*You heard me.*

Ok, maybe not all of them.  But you don't need the entire Go-lang support system when you're working on a Ruby project do you?  You probably don't need all the Python support either.  Or the C# snippets.

Go through each of your extensions in the extensions bar and disable them.  You don't have to reload until you've done them all.

![Disabling an extension](/img/extensions-disable.gif)

Now you are fast.  You are sleek.  *You.  Are.  Speed.*

![Look at all those disabled extensions](/img/extensions-installed.gif)

## OK, OK, Not All of Them

In my opinion, there are two kinds of extensions.  The first are language support extensions.  As I pick up a new language, I discover there's an extension that makes writing it better.  Python, Go, Ruby, language-specific linting, prettifying, snippets, and intellisense.  These are the ones that you want to disable.  The other kind are the general developer happiness extensions.  Things like [journaling support](https://marketplace.visualstudio.com/items?itemName=pajoma.vscode-journal), [colored bracket matchers](https://marketplace.visualstudio.com/items?itemName=2gua.rainbow-brackets), [Star Wars-based themes](https://marketplace.visualstudio.com/items?itemName=dustinsanders.an-old-hope-theme-vscode), and, of course, [emoji support](https://marketplace.visualstudio.com/items?itemName=Perkovec.emoji).  Feel free to leave these enabled all the time.  You deserve to be happy.

## But What if I Want My Extensions?

Don't panic.  If you go to work on a project that needs those language-specific ones, you can enable them *just in your workspace*.

![Enabling within a workspace](/img/extensions-enable-workspace.gif)

Now you get the full power of your development environment, and your computer loves you.

<hr>

Do you have some favorite extensions?  Any that are a little obscure or don't get a lot of love?  Let me know about them.  I'm always looking for another extension to add to my list.  I might even leave it enabled.

