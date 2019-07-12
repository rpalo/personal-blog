---
layout: page
title: Learning is Sneaky
description: If you're feeling stuck or like you're not progressing, take a closer look.
tags:
  - encouragement
  - learning
cover_image: learning-is-sneaky.png
---

Learning to program is sneaky. It's sneaky like exercise. It's sneaky like learning to ride a bike or skateboard.

It's sneaky like the smell of your house. You know the smell. Well, you don't know until you leave for a weekend and then come back. And then it’s like, “Woah what's that smell?” It's not a bad smell per se; it’s the smell of you, your stuff, your house, your neighborhood. And you get so used to it that you don't think there’s a smell at all, until you get a chance to step away. But it's there.

That's what learning to program is like. It’s not a fast process. You don't notice it happening. You might not feel any different than yesterday, last week, last month. But the learning is there. And it's always growing. And sometimes it can be really encouraging to take a step back and notice the things that are different.

This happened to me twice recently and I wanted to share them as encouragement for anyone who is feeling stuck, like there’s still too much to learn and they're not making any progress.

## Rust Tag

Last week I put together a post about Rust, and as I spun up the server to proofread it on the local site—`bundle exec jekyll serve`—the tag-page-maker plug-in that I wrote informed me it was creating a tag page for rust. I hadn't written any posts on Rust before.

I've been struggling to learn and be productive with Rust for several months and have been feeling like I'm not really making any progress.  So to see my first blog post talking semi-smartly about Rust celebrated a little bit by my dev server (followed quickly by the thought that my tag page generator is actually pretty cool) was very encouraging. Maybe all those mini-projects, videos, and books are rubbing off a little bit after all!

## Script Magic

I published a post this week about writing a script that fixes a tabs/spaces/Python thing that was bugging me. And after I wrote it, I though, “Boy, it sure would be nice if I could run this a little more easily than `python3 path/to/my/script.py other/path/to/my/file.md`.”

So, in a few quick steps, I renamed the file to something easier to type:

```bash
mv ulysses_t2s.py bootabs
```

I added a shebang line to the top of my file:

```python
#!/usr/bin/env python3
```

I made it an executable:

```bash
chmod u+x bootabs
```

And I dropped it into the “home for handy scripts” on my `$PATH`:

```bash
mv bootabs /usr/local/bin/
```

With that, I moved to another directory, and with no fuss at all:

```bash
bootabs -i example.md
```

Blammo! File fixed!

I started to move on to the next thing with a satisfied smile, and I just stopped.

Holy crap! In just the span of a few minutes, I had performed several tasks that I would have had no idea where to even start two years ago—even the simplest ones!

1. How do you run a Python script?
2. Why does plain old `python` not work?
3. What even is a shebang?
4. What is a good value for a shebang?
5. How do I open a shell?
6. Bash?!?
7. Why won't the script run now that it has a shebang?
8. What the heck is `chmod`?
9. What are permissions?
10. Octal?? Why do numbers mean read, write, execute?
11. What is the difference between those three?
12. What are users and groups?
13. Why do I need to add `./` before my script name?
14. What is a `$PATH`?
15. How do I look at it?
16. How do I change it?
17. OMG if I change it, will my computer explode?
18. What even is an environment?
19. What's a dot file? .bashrc??
20. Now I have to edit files in this command line?
21. Ok I like nano.
22. I accidentally tried vim! Help! How do I get out?
23. _Computer Rebooted_
24. Where do I put scripts I want to run?
25. `/bin, /usr/bin, /usr/local, /usr/local/bin, /opt, /home/ryan, /home/ryan/.local, /home/ryan/local, /home/ryan/scripts`??  _Cries_
26. Is `/bin` like recycle bin?
27. How do I rename a file?
28. How do I move a file?
29. Wait, they're the same??
30. Is sudo like please?
31. Oh gosh, I sudo-ed a bad thing.
32. _Reloads Operating System_ (true story)
33. It works! I'm king of the world!!! Now what's all this about color schemes?

## That’ll Do, Pig

So, all in all, maybe I'm not so lame after all. Programming is cool, and I am a cool programmer (at least, that's what my wife and cat say). The next time you feel stupid or like an imposter, pick the simplest task you've accomplished that day and imagine talking 10-years-ago-you through it over the phone. Not so simple, right?
