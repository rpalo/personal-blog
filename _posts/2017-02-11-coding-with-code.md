---
layout: page
title: Coding with Code
---

I think I am not alone among developers when I say unabashedly that I love gadgets.  A lot.  Now, I try not to jump from tool to plugin to framework willy nilly, dropping everything else, but I'm always on the lookout for things that make life easier, faster, and generally nicer.  There are a few topics that developers are kind of touchy about.  I'm going to try to hit all of them.  I'm going to start by vehemently recommending a new editor.  Well, not new, per se, but new to me.

Because I love tools (and especially editors), I've tried a lot of them.  Do not consider this a *Top 6 editors of 2016: Number 3 will knock your socks off!* article.  Consider it more of a chronicling of my journey to ultimate enlightenment.

## Vim

I tried Vim.  What I will say about that is that I didn't have a good enough teacher to show it to me.  Overall, Vim failed the test of increasing my productivity (and not my blood pressure).  I will admit -- not proudly -- that Vim and I started off on the wrong foot when I couldn't figure out initially how to exit.  <del>`esc:q`... Like what kind of sick, UX neanderthal...</del> Anyways!  If someone understands the reasoning behind the design and usage of Vim, I'm all ears and more than happy to learn.

## Emacs

Having rejected Vim with vehemence, the next natural option is Emacs.  I will say that I was able to put a significant amount of time into teaching myself the Emacs ways.  It has some nice tools, I'm a fan of the built in shell, calendar, journal, language support, and the fact that it can run in a terminal.  It will most likely be my editor of choice <del>if</del> when I have to code in the terminal and/or over ssh.  The only thing I didn't like about Emacs is that I ended up spending more time looking up how to do things like open a new pane or something than I spend coding.  That and it wasn't super simple for me to customize to my liking.  Again, as with Vim, both are clearly not problems with the editor but with my personal character.  But that's what this is all about, and so... we move on.

## Sublime Text

Once I found Sublime Text, I felt that I could end my search.  Simple, quick, easy to use.  Key bindings that existed but weren't required to use.  Directory tree explorer for easy navigation.  JSON customization and easy-to-change color themes!  Ah.  This was the life.  And then I found out about [package control](https://packagecontrol.io)!  All the plugins!  The themes!  The inline CSS hexidecimal color previews!  "That's it!" I crowed.  "My search is over.  I will never need to download another editor.  I have found my canvas, and on this canvas I will paint my masterpiece!"  Or something like that.  I'm paraphrasing.  Shut up, I like my tools, OK?

And then just a few days ago, I finally got caught up with my podcasts, and one of them was a [JavaScript Jabber](https://devchat.tv/js-jabber) episode with one of the guys who works on something called...

## Visual Studio Code

Yep.  I'll admit, I was skeptical.  Generally, I tend to enjoy my coding experience more on Mac or Linux than on Windows, and I have spent my fair share of time in the built in VBA editor within Excel, Word, and Access.  I have done a little bit with Visual Studio too, but I tend to try to stay away from full-blown IDE's.  As the podcast went on, however, and I heard more and more about the features available, my curiousity was piqued and I had to check it out.  So I did, and I loved it from the minute I opened it.  "Why?" you ask.  "Why should I look at *another* editor?"

These are a few of the things I liked.

 1. The onboarding process is really smooth.  They have a welcome page, a whole host of video tutorials, articles, and a guided sandbox to learn the basics in.  The welcome page helps you to get started customizing your settings, choosing your color theme, and picking out extensions (plugins), which everyone knows is the real fun of getting a new editor.
 2. It does everything that Sublime Text does, down to the key bindings (there's an extension for that)!  So you lose nothing by moving from Sublime to VSCode -- or, as the cool kids call it, Code.
 3. There's an integrated debugger and git GUI that are unobtrusive, so you don't have to think about them if you don't want, but robust, so you can get lost in all of their features if you do want.  Also, integrated terminal and markdown preview (at least with an extension).
 4. My favorite feature by far is the intelli-everything.  There's a command pallete (much like Sublime -- `cmd-shift-p`), but it shows fuzzy suggestions.  This is something Emacs could benefit from.  I know it does command suggesting, but the UI is much snappier.  Want to change a setting, but aren't sure which set of settings are available?  Pull up the pallete and type "settings."  It will offer you suggestions.  Need to find a file?  The pallete can do that too.  The pallete also shows what the keybindings are, so you can learn them at your own pace, not all up front (looking at you Vim).  This intelligence carries through into the code!  It offers some amount of code intelligence (and more with extensions), such that you can type `object.` and see a list of available suggestions.  You can right-click and peek (in-place!) at the definitions of functions and classes.  The best part is that it's all very unobtrusive.

 I think the main takaway is that the developers of VSCode have mastered the management of the user learning curve.  Are you a purist who doesn't believe in all the frills of IDE's?  Just want something you can edit code in?  It will do that.  As you slowly get more comfortable and decide a feature here or there is ok, they allow you to do that and will even suggest some extensions for you.  Ready to use the integrated terminal?  OK, there it is and it looks great!  Need to go faster?  How about some key-bindings?  Don't worry, you can pick those up as you go.  There are some minor hiccups here and there, but they're constantly updating it, and all in all, I'm sold.  Goodbye my previous tools.  Hello Visual Studio Code!

 You can get it [here!](https://code.visualstudio.com/).  Have a big opinion on any of the other editors I mentioned?  Want to chew me out for not getting Vim?  Have any other neat tools?  Let me know at hello@assertnotmagic.com!