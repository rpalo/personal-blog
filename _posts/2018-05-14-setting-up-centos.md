---
layout: page
title: Setting Up a CentOS Server
description: A walkthrough of the ins and outs of good security practices and some neat tricks to make your new server feel like home sweet home.
tags: linux sysadmin security
cover_image: centos-logo.png
---

I'm slowly discovering that I *love* systems stuff.  I've always used Ubuntu as the flavor of Linux on my servers, but I was curious about the differences between Ubuntu and CentOS, so I looked up a few guides and tutorials and spun up a new [Digital Ocean droplet](https://m.do.co/c/2e87eb578ad9) with a fresh install of CentOS.  I wanted to share what I learned, and all of the things to think about when first getting things set up.  I'm also writing this for when future me forgets a step and can't remember the commands.

I'm going to assume that you have working knowledge of the command line for now: changing directories, editing files, and setting file permissions.  I'll try to explain anything more exotic than that.  If you're not quite there, but you still want to learn, please [get in touch](https://assertnotmagic.com/about/), and I'd be happy to walk you through it (and/or write another post for that).  This is also a guide for CentOS because that's what I was doing.  For that reason, all of the commands are Centos (and probably RHEL) specific.  The process and theory should be much the same for other flavors of Linux, though.

## First Contact

I'm not sure how other providers do it, but once you create a droplet on Digital Ocean and your new server is all turned on, they send you an email with the `root` password.  You'll be able to `ssh` into your server using these credentials.  If you're on a Mac, you already have `ssh` installed and accessible via your terminal app of choice.  If you're on Windows, you should look into an `ssh` client.  I use [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/) when I need to.  Your hosting provider will provide you with an IP address as well.

```bash
ssh root@<your_server_ip>
```

From now on, if you see something in angle brackets like that, just assume that I mean, "Fill in the placeholder in angle brackets with your own preferred value."  It will ask you for your password.  Paste it in and hit Enter, and you should be ready to rock!

## Check Your Privilege

Right now you're logged in as `root`.  This is great!  It is also bad.  When you are logged in as root, typos and little mistakes can cause big problems.  It's generally better to sign in and go about your life in a less privileged account, only invoking `sudo` to do privilege-y things when you need to.  That way, if you accidently try to delete yourself out of existence, you'll have to work a little harder before you succeed.  So, we'll need to create this everyday user.

```bash
adduser <username> && passwd <username>
```

This will ask you for a new password for your new user.  Make it a good one.

Next, let's make sure that your new user can actually `sudo`.

```bash
usermod -aG wheel <username>
```

We're adding our new user to the `wheel` group, which (as long as you're on CentOS 7 or better) means that we'll be able to `sudo` without trouble.

Lastly, sometimes there's a default user created: `centos`.  I don't think we need this user for anything.  Remove it with:

```bash
deluser centos
```

## Transferring Keys

Next, we're going to strengthen security by setting up private/public key authentication.  A side benefit of this is that you won't need to remember a password if you don't want to anymore.  Temporarily switch users so that you're operating as your new user.

```bash
su <username>
```

In order to authenticate with keys, you'll need a spot to put your public key.  Let's create the `.ssh` directory.

```bash
mkdir ~/.ssh
```

We also don't want anyone but us to be able to fiddle around in this directory.

```bash
sudo chmod 700 ~/.ssh/
```

Great!  Let's transfer a key.  Exit `ssh` or open up a new terminal on your local machine.  If you don't yet have a private/public key pair, generate one now.

```bash
ssh-keygen

# Generating public/private rsa key pair.
# Enter file in which to save the key (/Users/localuser/.ssh/id_rsa):
```

Just hit Enter to accept the default file location for your keys.  This will create two files.  `id_rsa` is your private key.  This is *Very Secret*™.  Never share this with anyone unless you trust them with your life.  Or, at least, your servers.  I'd go so far as to say don't put this out on a cloud service or flash drive where it might get hacked, stolen, lost, or blown up.  `id_rsa.pub` is your public key, and this is the one you can share with people to prove you are who you say you are.  This is the file that we want to share with our new server's new user.  There are a couple ways to do this:

```bash
# Via ssh-copy-id
ssh-copy-id <username>@<server-ip>

# Via scp
scp ~/.ssh/id_rsa.pub <username>@<server-ip>:~/.ssh/authorized_keys

# Manually via good ole' fashioned copy/paste
cat ~/.ssh/id_rsa.pub

# You'll see something like:
# ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAmLmwkzQDjEOW1Rj3TP5NldVDqUODVH9xuYrkeaSkxtdP

# Copy the whole thing.  Then ssh back into your server like normal and create a new file at ~/.ssh/authorized_keys and paste in in.
nano ~/.ssh/authorized_keys

# Or use emacs or vim or whatever editor you like best.  Whatever.  Shut up.
```

Now, the next time you log in as your user, it shouldn't ask you for a password.

And once again, make sure the permissions are as restrictive as possible for this file.

```bash
# Once again logged into your server
sudo chmod 600 ~/.ssh/authorized_keys
```

## But We Can Go Even More Secure

*"But wait, shouldn't we do a public key for our `root` user as well, so we don't have to type that password either?"* you ask.  The answer is no.  Actually, the most secure way is if your `root` user can't even log in from the outside at all!  We're now going to edit the configuration for our `ssh` daemon (or, `sshd` for short) that controls how our server accepts `ssh` connections.  Most configuration lives in the `/etc` directory, and this is no exception.

```bash
sudo nano /etc/ssh/sshd_config
```

Look for the line that says:

```ini
#PermitRootLogin yes
```

You'll want to uncomment it and set that to "no."

```ini
PermitRootLogin no
```

*Side note: I always think it's funny to add an additional line.*

```ini
# PermitKennyLogin DANGER ZONE!
```

*My wife, a teacher and not an avid sshd configurer, disagrees.*

As extra steps, also change the following lines:

```ini
PasswordAuthentication no

# If you connect via IPv4:
AddressFamily inet
# If you connect via IPv6:
AddressFamily inet6
```

The first line turns off all password logins.  Without this, your user account is still open to password login, which somebody can do even without your private key.  The other lines shrink the amount of shenanigans you have to deal with by refusing to serve people who aren't connecting like you.  If you're not going to ever connect via IPv6, why leave that open for some botnet to sniff around?

Lastly, once we've reconfigured a service, we need to reload it.

```bash
sudo systemctl reload sshd
```

And we should be good to go!

## Moving In and Settling Down

We're pretty much done with the security stuff.  By now, you should be pretty much secure and feeling safe.  Now we're going to focus on turning this server into a pleasant place to work.

```bash
yum update && sudo yum upgrade
```

Watch as your server brings itself up to current.

### ProTip: Yum Errors

If you get interrupted or, hypothetically, your dog jumps into your lap while this is happening and just manages to mash the correct keys to abort the upgrade without cleaning up, and you start seeing errors like "yum lock" or "sqlite3 database lock", don't panic.

Check to see if there's still a `yum` process active.

```bash
ps aux | grep yum
```

 If you see one that shouldn't be active, try to kill it (take note of the process ID (PID) in the second column of the output from the above command).

```bash
kill <pid>
# Or, if you're feeling feisty and it's not working:
kill -9 <pid>
```

Willy is sorry he caused 90 minutes of frantically Googling error messages.

![Sad Willy](/img/sad-willy.jpg)

### Back To It

Now is a good time to install any packages you couldn't be without: Zsh, oh-my-zsh, Ruby, Vim, and git are the first ones that come to mind.  I'm going to show you just the first one, because there is one hiccup you might encounter.  If you prefer Fish or some other shell, it should most likely be similar.

## Installing Zsh

The first part should make sense.

```bash
sudo yum install zsh
```

Check to see where your executable lives.

```bash
where zsh
# /usr/bin/zsh
```

The important thing here is to make sure that this location is in your `/etc/shells` file, which is a list of the approved shells.

```bash
sudo nano /etc/shells
```

```ini
# List of acceptable shells for chpass(1).
# Ftpd will not allow users to connect who are not using
# one of these shells.

/bin/bash
/bin/csh
/bin/ksh
/bin/sh
/bin/tcsh
/bin/zsh
/usr/local/bin/pwsh
/usr/bin/zsh # << Here's the one we're adding.
```

Once the zsh executable is approved, you can set your own default shell to zsh.

```bash
chsh -s $(where zsh)
```

## Bonus: Bringing in Dot Files

If you're like me, you're probably reasonably proud of your slowly growing collection of "dot files."  But how do you get them from your computer onto the server, quickly, sanely, and repeatably?  With Git.  I found [this article by Nicola Paolucci](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/) that I think is brilliant.  We're going to use a modified bare Git repository in our local home directory!

### Setting Up

On your local machine:

```bash
git init --bare $HOME/.dotfiles
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
dot config --local status.showUntrackedFiles no
echo alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME' >> ~/.bashrc
```

We create a bare repo in our home directory to track our dot files, we create the `dot` command (or whatever you want to call it) which will function just like the `git` command, but just for our dotfiles.  We configure it to only show us if our tracked files change, and then we save the `dot` command for later.

Now, all we have to do is start tracking some dot files!

```bash
dot status
dot add .zshrc
dot commit -m "Add zshrc"
dot remote add origin https://github.com/<you>/dotfiles.git
dot push -u origin master
```

You get all the benefits of Git!  You can branch, edit, roll back, diff changes, and more.

### Installing Onto Our Server

On the server, add your same `dot` command to your `.zshrc` file.

```bash
echo alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME' >> ~/.zshrc
. ~/.zshrc
```

If there are any stock files that might conflict with the dotfiles you're about to pull in, either delete them or (better), copy them to a backup directory.

```bash
mkdir .dotfile-backup
mv .bashrc .dotfile-backup
mv .zshrc .dotfile-backup
```

Now we're ready:

```bash
git clone --bare <dotfile repo url> $HOME/.dotfiles
echo ".dotfiles/" >> .gitignore
dot checkout
# Just in case:
dot config status.showUntrackedFiles no
```

And now your server should be on its way to being comfy, cozy, and functional!

## Bonus Bonus: Message of the Day

I don't know about you, but I believe that 98% of the reasons why I learned how to program were to make computers print out funny messages.  To that end, I set up my Message of the Day accordingly.

```bash
sudo vim /etc/motd
```

```text
==================================
You are a gentleman and a scholar.
==================================
```

If you can't think of any one-liner affirmations to put in your MOTD, check out this [list of compliments I curated for a twitter bot to pepper my brother with](https://github.com/rpalo/fanbot/blob/master/fanbot/compliments.py).

Now, whenever you log in, your server will greet you with an uplifting message!  😁

## Wrap Up

I know there's a lot more for me to learn in the system administration realm.  I'm starting to stock up on books to read and videos to watch.  Did I miss anything important?  Do you have any extra protips?  Any great resources for learning?  Let me know about them!  Thanks for reading!