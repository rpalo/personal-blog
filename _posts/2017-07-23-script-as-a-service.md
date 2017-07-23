---
title: Script as a Service
layout: page
tags: python sysadmin linux
---

I'm going to show you how I got a Python script to run as a service on Ubuntu.  I was working on a project of mine that is a [Twitter Bot that tweets compliments at people](https://github.com/rpalo/fanbot).  I wrote a (slightly disjointed) [post about it](http://assertnotmagic.com/2017/05/01/fanbot-and-doing-new-things-right.html) a little while ago, if you want more background.  Basically, I have this bot running in a Python script, and I want this Python script to run for a long time.  I definitely want to be able to kick it off and log out of my server!  So I went in search of some options.

## The Options

1. Never log out of the server.  Run `python main.py` and leave the shell open.  Pros: very easy to do, and I already knew how to do it.  Cons: probably won't work for long.  I assume ssh connections time out eventually.  Also, logging becomes an extra step of `python main.py | tee fanbot.log` or something of that nature.  All in all, feels hacky.

2. `nohup`.  A HUP (hangup) signal is sent to any job if its controlling terminal is closed.  One example of this is logging out of an SSH session or closing an open terminal window.  This causes it to wrap up and shut down.  `nohup` is a command that tells a job to ignore the HUP signal.  I would be able to do `nohup python main.py &`.  The & pushes the job to the background.  The job then runs in the background and appends all output to `nohup.out`.  You can get a custom logfile thusly: `nohup python main.py > custom.log &`.  Pros: I can log out, I get logfiles where I want them, fairly simple command.  Cons: Dies if the server resets.  I'm also not sure how cleanly it could be killed.  It would at least be a couple commands to get it done properly.

3. Use a terminal multiplexer.  I could use something like `tmux` to run in.  For those of you that don't know what `tmux` is, it's a neat way of saving and reusing terminal window, pane, and histories.  You can attach and detach from a tmux session whenever you want, but the programs running in the session stay running.  I'll have to add a `tmux` overview to my list of things to write.  It would go like this.  Pros: Easy to use.  Works basically just like running things in the terminal.  Cons: Also dies if the server resets.  `tmux` feels like a little bit of overkill just to manage this one single job.  If you're interested, here's how that would go down:

```bash
$ tmux new -s fanbot_session
$ python main.py | tee fanbot.log
$ <ctrl-b>d # To detach from tmux

# Later, to check on things:
$ tmux attach -t fanbot_session
```

## We Pride Ourselves on Service

Finally I gave in.  I had been putting off doing it as a service because it sounded hard and scary, even if it sounded like maybe it was the "right" way of doing things.  Turns out, it's not that bad.  But, I hear what you are thinking: less talk, more examples!  Let us say that we have the script below.

```python
# /home/ryan/bigben.py
import time

def bong():
    print("BONG!  It is now {}".format(time.ctime()))

if __name__ == "__main__":
    while True:
        bong()
        time.sleep(3600) # Tell the time once an hour
```

Kind of silly, but it is the type of script that you'd like to run for a long time, possibly be auto-restarted, and see the logs later.  OK.  So we'll only need one other file: the service's Unit File!  Create a file called `bong.service`.  The .service is not really needed, but I think it's nice to have.

```ini
; /home/ryan/bong.service

[Unit]
Description=Bong time telling service
After=multi-user.target

[Service]
Type=idle
ExecStart=/usr/local/bin/python /home/ryan/bigben.py

[Install]
WantedBy=multi-user.target
```

Some explanation.  The `Unit` section describes what this service is and how it should be run.  The `After` variable tells this service when is allowed to run.  `After=multi-user.target` essentially just means that this service will be ok to run once the server is ready for logging in.  The `Service` section desribes what `systemd` (the service controller) will do and how.  `Type=idle` tells it to only run our service once there are no more jobs to run.  The `ExecStart` variable is the command we would want it to run.  Note that absolute paths are required.  Lastly, the `Install` section allows us to have our service auto-run at boot.  The `WantedBy` variable tells it which already auto-run service our service should get started after.

Copy our service file into the systemd service library, setup permissions, load it up, and let er rip!

```bash
$ sudo cp bong.service /lib/systemd/system/bong.service
$ sudo chmod 644 /lib/systemd/system/bong.service
$ sudo systemctl daemon-reload  # Refresh the available service list
$ sudo systemctl enable bong.service

# Now watch your service auto run at bootup
$ sudo reboot
...
$ sudo systemctl status bong.service
# Blah blah blah you should see something happy and green
# Want to check your logs?
$ sudo journalctl -e -u bong.service
# -e scrolls to the end of the logs
# -u bong.service filters by the service that we care about
# OR: sudo journalctl -f -u bong.service to follow, similar to tail -f
```

So that's really it!  Create a service file, pop it in the right directory, and tell `systemd` about it.  Not as hard as I thought!  And you get auto-restarting, sane log files, easy status checks.  As you can see, this applies not just to Python, but to any language, script, program, etc. that you can run from the command line.  It should work with Ruby, Bash, Node, and more!

## Bonus: Virtual Environments

If you're one of the cool kids, you're programming Python in a virtual environment.  You may usually do something like the following to run your script by hand:

```bash
$ python -m venv .venv  # Creating a virtual environment in .venv/
$ source .venv/bin/activate
(.venv) $ which python
/home/ryan/.venv/bin/python
(.venv) $ python bigben.py
...
```

How, you ask me excitedly, do you get the service to run from within your virtual environment?  It's simpler than you might think!  Remember this line in our `bong.service` file?

```ini
ExecStart=/usr/local/bin/python /home/ryan/bigben.py
```

Simply point the python path to your virtual environment.  It will automatically pick up the installed packages from there as well.

```ini
ExecStart=/home/ryan/.venv/bin/python /home/ryan/bigben.py
```

Hopefully this post provides you a useful *service*!  (Womp womp womp)