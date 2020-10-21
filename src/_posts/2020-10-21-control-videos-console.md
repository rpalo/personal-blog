---
layout: page
title: Control HTML Video Playback Speed with the Console
description: University video element doesn't have playback speed controls?  No problem!  Pop open a console and do your wizard stuff.
tags:
- javascript
- html
- tricks
cover_image: video-speed.gif
---

Quick tip!

My university online class videos don't have a playback speed option.  This is doubly a bummer because the professor talks slowly, and I usually listen to podcasts at 2x speed.  Between that and I don't have time to watch 4 hours of lecture a week at regular 1x speed, I needed a way to speed up the video.  With no playback speed controls built into the UI, I thought I was sunk.

But then I realized: wait a minute!  I know things about computers!  And JavaScript!

I popped open an Inspect window, did some digging into the HTML to make sure I could do what I wanted to do, and then switched over to the Console.  It only took two lines:

```javascript
video = document.querySelector("video")
video.playbackRate = 2
```

And like that, my professor sounded like a chipmunk, and I had 2 extra hours of time to look forward to.  I'm considering putting together a browser plugin to make some of my own video control buttons for the site!
