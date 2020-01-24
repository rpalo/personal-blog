---
layout: page
title: Dev Journal 1/24/2020
description: Crontab, awk, grep, and getent
tags: linux, awk, cron, dotfiles
category: devjournal
---

Today I wrote a bunch of scripts to bootstrap a computer and setup dotfiles!  Here are some things I learned.

## Making cron jobs

You can edit your crontab file with the command `crontab -e`.  This brings up a file with your cronjobs, which follow the pattern:

```crontab
# min hou dom mon dow command
0 5 * * * echo "Hi!" >> ~/hi.log
23 12 4 6 * echo "SUPER HI" >> ~/hi.log
```

The first line is a comment to show the pattern.  Comments are ignored.  The second line runs every day at 5:00 AM.  Since it is run from your home directory as you, a file should show up with all of the "hi" logs tomorrow morning!  The third line schedules a SUPER HI at 12:53 PM (just after noon) on June 4.

Your crontab can be found in /var/spool/cron/crontabs/$USER (although only root can actually see into the crontabs directory).

`crontab -l` outputs the entire current crontab to STDOUT (or an error message to STDERR if the user doesn't have one yet).

You can overwrite the crontab by using a single - to specify the crontab reads from stdin: `echo "0 0 * * 1 ls" | crontab -`

## Checking for unstaged changes

You can use

```bash
git diff --quiet
```

and the exit code will be 1 (failure) if there are unstaged changes and 0 (pass) if the working directory is clean.

## Checking for upstream changes

After running a `git fetch`, you can use

```bash
git diff origin/master --quiet
```

The same way as above.  The only difference is that it also checks unstaged changes, so if you want to only check against your current master branch, you have to `git stash` your changes first.  You can `git stash pop` them back when you're done.

## Sending variables to awk

You can input variables to awk!  This is really good for passing shell variables into awk, which should really be single quoted.

```bash
$ awk -F: -v user=$USER '$1 ~ user {print $7}' /etc/passwd
/usr/bin/zsh
```

Looks like you can't use them in regular expressions for patterns.

## Checking a user's default shell

Granted, I ended up finding a much easier check to see if my default shell was zsh or not:

```bash
$ grep '^ryan.*zsh$' /etc/passwd
ryan:x:1000:1000:,,,:/home/ryan:/usr/bin/zsh
```

Apparently, after some research, there is a command `getent` that lets you query the various system databases for specific info.  So this works:

```bash
$ getent passwd ryan
ryan:x:1000:1000:,,,:/home/ryan:/usr/bin/zsh

# And thus:
$ getent passwd ryan | awk -F: '{print $7}'
/usr/bin/zsh
```

*Also neat* is that if there is no key present that matches, it will do exit code of 2, so:

```bash
if getent passwd florpnorp > /dev/null; then
    echo "Found that user"
else
    echo "Not present"
fi
# => Not present
```