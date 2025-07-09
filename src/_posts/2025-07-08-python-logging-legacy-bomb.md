---
layout: page
title: Legacy Python Logging Stealth Bomb
description: I ran into a sneaky legacy-code footgun that I lost an hour to.  Read this and save yourself the pain!
tags:
  - python
  - legacy
  - django
  - pain
---

## TL;DR

> If nothing else makes sense and you can't figure out why logs aren't coming
> out of your program, do a global search for `logging.` and hunt for any rogue
> `logging.basicConfig` or `logging.disable` calls.

## Setting the Scene

I'm working on a long, multi-PR journey of some much-needed maintenance and new
QoL features for a super-old, super-legacy, only-touch-it-when-it-breaks Django
application that our team owns. I've got some sweet new features and bugfixes,
and I've gotten to a point where things are stable enough that it makes sense to
write some tests to make sure everything works the way I expect.

## The Head Scratcher

I start writing some tests for a method. The happy path works. Great! I write
the tests for the first error-handling path, and do an assertion that the log
messages I expect to see are being emitted. Django has pretty good test helpers
including one logs:

```python
with self.assertLogs("myapp.module", "WARNING") as logs:
    ...
```

The result: test failed. No logs emitted at all. Guh.

I'm not going to lie, between Python's logging configuration, which has always
been a little opaque to me, and Django's thin extra layer on top, my first
thought was that either I wasn't understanding something or the legacy code had
logs configured in a strange or outdated way. So I commented out the logging
config completely to start from default.

No luck.

I went to the Django docs and copied their simplest basic logging config.
Nothing.

I learned some more about how logging is based on the names and since different
apps have different names, you might want per-app logging configs sections. I
tried that: _still_ nothing.

Now I'm starting to get desperate. Google, Gemini, Cursor, somebody save me!

_Finally,_ I saw a result that said, "You might have other settings conflicting
somewhere," and, in desperation, I did a global search for `logging.`.

And there, tucked into `myapp/tests/__init__.py` like a forgotten hard-boiled
Easter egg, stinking up the project with its miasma of evil, were two simple
lines:

```python
import logging

logging.disable(logging.CRITICAL)
```

> Note: as of Python 3.7, the actual level specification isn't necessary, as
> [`CRITICAL` is the default](https://docs.python.org/3/library/logging.html#logging.disable).

This little beauty squashes all logs at the specified level and below and was
being loaded before the test suite for that app ran. In lieu of reaching back in
time to slap the past dev, I got up to take a walk and draft this post.

Hopefully it helps.

1. When in doubt, search for `logging.` for crazy hidden settings.
2. Don't be that person. Make sure any custom setting-doing happens in some sort
   of a test-specific (or as local as possible) fixture or context manager.
3. Please please don't be that person.

Here's an example of doing things well using
[caplog](https://docs.pytest.org/en/7.1.x/how-to/logging.html#caplog-fixture).

```python
# caplog is a built-in pytest fixture you can just use.
# Not even any imports required!
def test_thing(caplog):
    with caplog.at_level(logging.CRITICAL, logger="myapp.module"):
        do_crimes()
```
