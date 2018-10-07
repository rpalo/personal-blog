---
layout: page
title: File-Specific Vim Configuration
description: A quick tip about making custom settings that are language-specific in Vim.
tags: vim tools
cover_image: vim-ftplugin.png
---

It seems like an indicator of a powerful application if you can use it for a long time without any problems and then suddenly discover useful features that add to your enjoyment or productivity that you didn't even know existed.  This happens to me a lot with the Microsoft Office suite (imagine the look of boyish glee on my face as I discovered conditional formatting in Excel).  This also happens to me in Vim all. the. time.  Granted, this may be more because of a more specialized interface and low discoverability.  But, it's still like an Easter egg hunt that you come across that you weren't expecting because it's the middle of October!

So here's the #spoopy Halloween egg for today: **Language-Specific Vim Configuration**.

## The Tip

Have you ever wanted to have some custom functions, settings, or key-bindings, but only for a specific language, without losing the ability to use those keybindings when working on other languages?  Or (like in my case), multiple languages have a "build" command, but the command is different for each language, and it would be nice to have `<leader>b` do the building for each language so I don't have to learn a million different muscle memories.

## Introducing the `ftplugin` Directory

Inside your home directory, there is a `.vim` directory.  Inside this `.vim` directory, you can put a directory called `ftplugin` (short for "file-type plugin").  Inside *this* directory, you can put `<language>.vim` files for each language you'd like to configure for.  For instance, the plugin for the Rust language  provides the commands `:CBuild` and `CRun`, but no keymappings.  (I'm learning Rust, my first compiled language -- pray for me)  So, I created a `~/.vim/ftplugin/rust.vim` file, and right now, all it has are these contents:

```viml
nnoremap <Leader>b :CBuild<Enter>
nnoremap <Leader>r :CRun<Enter>
```

I'm sure I'll add more to it as I come up with more shortcuts and handy little settings, but that's all I really wanted right now.

## Clutter-Free Configuration

That's the whole tip!  I thought it was neat and wanted to share it.  I like that you can separate things out into different files so that you don't end up with one long convoluted `.vimrc` file.  If you have any cool language-specific customizations or key-mappings that save you time, share them with me!

Happy configuring!

