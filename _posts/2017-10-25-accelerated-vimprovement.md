---
layout: page
title: Accelerated Vim-Provement
description: A quick tip to help pick up Vim faster by freeing yourself of crutches
tags: vim editors encouragement
cover_image: hjkl.jpg
---

I'm currently working on practicing and learning to use Vim as an editor.  After a few sorry attempts to learn it quickly by sitting down and doing a few tutorials, I've learned that the road to Vim mastery for me will consist of a slow, steady grind of practice, learning and conquering one thing at a time, letting the Vim philosophy soak in as I go.

![Slow and steady](/img/slow-and-steady.gif)

Learning to take the pressure off of myself to learn quickly and move on the the next thing has been difficult, but I'm glad for it.  It's turned the hiccups, small frustrations, and the disappointment of having to Google the same thing for the umpty-seventh time into a weirdly relaxing and enjoyable journey.  Instead of *"I'm so dumb, I can't believe I can never remember how to delete a word"*, it has become, *"Oh Vim, you little rascal, you got me again.  We'll see who has the last laugh."*  

![Oh, Vim...](/img/oh-you.gif)

I did come up with one thing that helped me speed things up a little bit, which I thought I could share.

## Take the Training Wheels Off

One of the first things you learn when learning Vim is how to move around using `h, j, k, l` keys instead of the arrow keys.  In theory, it's more efficient and keeps your hands in an ideal typing position.  I don't think that using the arrow keys makes you a bad person, but there is one additional benefit to using these keys instead of the arrow keys:

> You have exactly as much practice using `h, j, k, and l` to move around as you have with any of the other motion/command keys in Vim.

The arrow keys are sort of a crutch, because, if you want, you can ignore all of the commands and keys that make Vim extra useful and stick to just using the arrow keys and staying in Insert mode all the time.  If this is how you're using Vim, you're essentially just using an obnoxious version of [Nano](https://www.nano-editor.org/).  

> All the features of Nano, with the added joy of continuously forgetting you're in Normal mode and trying to start typing, only to have your cursor do crazy things all over the screen.  

If that's the way you like it, I have no problem with that.  You do you.  If you're trying to break that habit and convert your brain to the Vim way of doing things (via Vimception, maybe?), then I've found it is super helpful to actually **throw away the crutch entirely** and turn off your arrow keys.

Add these lines to your  `.vimrc` file.

```
nnoremap <Up> <Nop>
nnoremap <Down> <Nop>
nnoremap <Left> <Nop>
nnoremap <Rigth> <Nop>
```

Mapping a key to `<Nop>` (or no-op, or no-operation) causes it to do nothing.

## But Why?

This is actually pretty common advice, but most articles will tell you only that it's to help get you more comfortable with `h, j, k, l`.  This seemed dumb to me because... why would I want to learn a new set of keys that just do the same thing if I'm already efficient with arrow keys?  I would say the benefit is not that I got more comfortable with `h, j, k, l`, but that I *quickly got tired* of pushing these keys.  Without the arrow keys to fall back on, but with a desire to be more efficient, I've had a much larger incentive to learn keys like `w, e, $, 0, G, gg` and others!

> You don't take the training wheels off of a bike so that you can say you're not using training wheels -- while continuing to ride slowly.  You take the training wheels off of a bike so that you can quickly learn that it's actually much easier when you go faster.

## Hard Mode Enabled

This works well, but there's still the temptation to just drop into Insert mode and use the arrow keys there, which defeats the entire purpose.  To circumvent this, You can also disable the arrows in Insert mode as well by adding the following to your `.vimrc`:

```
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>
```

This will make your life frustrating at times.  "But I just want to move over two characters!  I don't want to have to drop out of Insert mode, move over and go back in!"

### Tough.  Cookies.

![You're a tough cookie.](/img/tough-cookie.jpg)

Stick with it!  It'll pay off.  I've only been doing that for like a week and I'm seeing huge improvements.

## Bonus

For extra encouragement, replace all of the `<Nop>`'s above with this:

```
:echo 'STAHP.'<CR>
```

## Wrap Up

If you've got any Vim pro-tips, let me know.  Vim is a fairly popular tutorial topic and everybody's got lots of opinions about it, but I'm always on the lookout for cool resources, books, guides, games, ways to practice, etc.  I know there's a lot of people with a lot of knowledge to share, so share away!