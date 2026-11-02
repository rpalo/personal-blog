---
layout: page
title: "Overbuilding Part 2: Sharing is Caring"
description: My friends want to join in on the Discord bot development, and a local repo, an old Pi, and build scripts just aren't going to cut it anymore.
tags:
  - architecture
  - go
  - aws
  - lightsail
---

This is Part 2 in a multi-part series on overbuilding and overarchitecting a
Discord bot for fun and learning until it gets silly. The goal of these articles
will be part dev-log and part architecture-focused dive. We're not going to dive
too deep into Discord bots directly. The important bits are how everything is
managed and deployed.

If you missed [Part 1](https://assertnotmagic.com/2026/10/05/overbuilding-1), go
back and check that out first so you can see where we started and more details
about the project.

## Level 0.6: Growing Pains

The bot was working great. Everything was running smoothly. But I'd made a
mistake and made the project _too_ cool and interesting. My friends wanted to
join in. So up to a private GitHub repo the code must go (private only because
there are a number of inside jokes and I didn't want to stress too much about
performing for the whole internet. Not to worry, you'll get to see all the
important and relevant bits here in these articles).

And again, things were good, and pull requests started flying for all of one (1)
pull request before I realized another flaw: with our bot running on my
Raspberry Pi, unfortunately, I had become our CI/CD pipeline, deployment
interface, monitoring, and Ops team. For every pull request that we merged, even
if I could review code and approve PRs from my phone, I had to be at my computer
to pull the new code, run the build and deployment steps and make sure the bot
got restarted on the new code. If there was a problem, I had to be there to fix
it. I went briefly on vacation and the bot just quietly stopped replying and we
had no way of restarting the Pi remotely. I hadn't planned ahead enough to set
up any sort of VPN or SSH tunnel, and remote triage while on vacation with three
kids under the age of eight is not exactly "relaxing vacation behavior" anyway.

We needed a more public deployment, and soon.

## Level 1 (Finally!): LightSail

The bot going down while I was on vacation was really the last straw. We can't
be botless because I'm not home, that's lame! So I finally ponied up for a small
[Lightsail](https://aws.amazon.com/lightsail/) instance. Lightsail is AWS's
small, easy VPS offering: the "I just need a lil' server on the internet to do
stuff on" offering. DigitalOcean and Linode are others. Google has a version
too. Setup took almost no time at all, and I was up and running.

Except!

It's less expensive if you only need an IPv6 IP, but (and I couldn't confirm
this was the cause), Discord doesn't respond or blocks IPv6 only or something. I
couldn't get a response out of Discord from that box. After I switched to the
slightly more expensive version with an IPv4 address, it started working again.

They offer additional services like domains, networking, etc. but luckily, for a
Discord bot, we're just calling out to hook up the websocket, and we don't need
a fixed IP for people to reach in to us.

I was able to create users for my friends, add their SSH keys, and we were off
to the races. We could all log in to deploy code, and I could restart it from my
phone if needed.

## Level 1.5: CI Integration

"log in to deploy code... log in to deploy code... log in... log in..."

An absolute nightmare. What are we, peasants?! We can't be manually logging in
and scp-ing files to our Lightsail instance all the time! That's lame. We're
overengineering here, we need _integrations!_ We need **synergy!!!**

It was time to learn more about GitHub Actions. Luckily, the documentation and
tooling around GitHub actions is really approachable. We'll start with a nice
classy one for running tests on PR pipelines:

```yaml
name: PR Pipeline

on:
  pull_request:

jobs:
  lint-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-go@v5
        with:
          go-version-file: go.mod
      - run: go build -o /dev/null ./cmd/discordbot
      - run: go build -o /dev/null ./cmd/sync_commands
      - run: go test -v -race ./...
```

Nothing too crazy, just one job that checks out the code, builds it and runs
tests. With a little bit of Action learning under my belt, it was time to put
together the real time-saver.

```yaml
name: Release and Deploy

on:
  push:
    tags:
      - "[0-9]*.[0-9]*.[0-9]*"

jobs:
  release-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      - name: Set up go
        uses: actions/setup-go@v5
        with:
          go-version-file: "go.mod"
      - name: Run tests
        run: go test ./...
      - name: Run Command Sync
        env:
          DISCORD_TOKEN: ${{ secrets.DISCORD_TOKEN }}
          DISCORD_CLIENT_ID: ${{ secrets.DISCORD_CLIENT_ID }}
        run: go run ./cmd/sync_commands
      - name: Build binary
        env:
          CGO_ENABLED: 0
          GOOS: linux
          GOARCH: amd64
        run: |
          go build -o dist/discordbot ./cmd/discordbot
      - name: Deploy via SSH
        env:
          SSH_PRIVATE_KEY: ${{ secrets.LIGHTSAIL_PRIVATE_KEY }}
          SSH_HOST: ${{ secrets.LIGHTSAIL_HOST }}
          SSH_USER: ${{ secrets.LIGHTSAIL_USER }}
          SSH_KNOWN_HOSTS: ${{ secrets.SSH_KNOWN_HOSTS }}
        run: |
          eval $(ssh-agent -s)
          echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add -

          mkdir -p ~/.ssh
          chmod 700 ~/.ssh
          echo "$SSH_KNOWN_HOSTS" >> ~/.ssh/known_hosts

          scp dist/discordbot "$SSH_USER@$SSH_HOST:~/discordbot.tmp"
          ssh $SSH_USER@$SSH_HOST << 'EOF'
              sudo chmod +x ~/discordbot.tmp
              sudo chown discordbot:discordbot ~/discordbot.tmp
              sudo mv ~/discordbot.tmp /opt/discordbot/discordbot
              sudo systemctl restart discordbot
              sudo systemctl is-active --quiet discordbot
          EOF
          ssh-agent -k
```

An important note here is to make strong use of repository secrets so that we're
not hard-coding anything we care about. It's a little more complicated than the
previous Action, but it's really not much more than an automated deploy shell
script.

The important things are these at the end of Overbuilding Part 2:

- We're running on a VPS that me and all my friends can SSH into and that we can
  all restart remotely if we want to.
- We're _not_ running ARMv7 on an old Raspberry Pi.
- We're doing pull requests.
- Those pull requests have automated testing!
- We're in AWS now! We're basically a startup.
- We've got automated deploys when we tag a new version without anybody having
  to SSH in and run manual commands.

Next steps: I'm looking ahead to overbuilding the database, and maybe even
beginning work to do things with containers. We may not get all the way to EKS,
because clusters are expensive and I have three kids under 8, but by golly I'm
thinking we can get away with ECS at _least_. Keep an eye out for Part 3.

