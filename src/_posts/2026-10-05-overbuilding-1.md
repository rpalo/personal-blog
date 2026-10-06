---
layout: page
title: "Overbuilding Part 1: Discord Bot MVP"
description: |
  The beginning of a journey building a Discord bot--and not just building it: overbuilding it until it gets silly to practice and learn. Level one is just getting something up that works.
tags:
  - architecture
  - typescript
  - bot
---

This will be Part 1 in a multi-part series on overbuilding and overarchitecting
a Discord bot for fun and learning until it gets silly. The goal of these
articles will be part dev-log and part architecture-focused dive. We're not
going to dive too deep into Discord bots directly. The important bits are how
everything is managed and deployed.

The project is this: I want to build a Discord bot for my friends and I to use,
tinker on, and have fun with. Sort of a project base for anybody who's into
learning something to build off of.

The goal of Part 1 is a Minimal Viable Product: get a Discord bot made that does
_something_ 🤷‍♂and get it talking to Discord.

## Level -1: It Works on My Machine

For level -1, I just want to get code that's working. We're starting small with
only one initial feature to show off: a quote manager. I chose this because it
can be done with discrete commands (in Discord lingo: Slash Commands). The
functionality looks like this:

```text
/book-add Here's my favorite quote.
(bot) => Quote added :salute:
/book-get
(bot) => Random quote from the book: Here's my favorite quote.
```

I'm starting this in Deno-backed TS because it's comfortable and familiar and I
can get up and running that way.[^1]

Step 1: Create the app on
[Discord's Developer Page](https://discord.com/developers), fill in the
important stuff (avatar and name, etc.), go over to the Bot tab, and grab a
fresh Discord token.

Step 2: Generate the join URL from the bot page with the proper permissions, and
click it to join your bot to your server. At this point, I recommend going into
your Discord settings and turning on Developer mode because it enables a bunch
of nice "right click this to get its ID" sort of features.

Step 3: Prep the code to do a bare minimum log in. I show you code here only so
you can see the general shape of what bot code looks like.

```javascript
import { Client } from "discord.js";

const client = new Client({
  intents: [GatewayIntentBits.Guilds],
});

client.login(Deno.env.get("DISCORD_TOKEN"));

const channel = client.channels.fetch("MY_CHANNEL")
  .then((channel) => channel.send("Hello there!"))
  .catch(console.error);
```

Step 4: Register the commands. Discord has to know about the commands ahead of
time that you plan to run. You will need the Client ID from the bot's Discord
developer app page.

```javascript
import { REST, Routes, SlashCommandBuilder } from "discord.js";
const rest = new REST({ version: "10" }).setToken(
  Deno.env.get("DISCORD_TOKEN"),
);

await rest.put(Routes.applicationCommands(Deno.env.get("DISCORD_CLIENT_ID")), {
  body: [
    new SlashCommandBuilder()
      .setName("book-get")
      .setDescription("Gets a quote."),
  ],
});
```

After running this script, reload your Discord window and your slash command
should show up. If you try to execute it, it'll spin for three seconds and then
error saying it got no response (which is expected because we don't have
listener code yet).

Step 5: Add the listener code, again, just to illustrate how event-driven bots
work.

```javascript
import { Events } from "discord.js";

// just before client.login()
client.on(Events.InteractionCreate, async (interaction) => {
  if (interaction.commandName === "book-get") {
    await interaction.reply("I've got your quote right here!");
  }
});
```

For me, I opted to go with a sqlite database of quotes. For such low volume, I
could have got with a simple JSON file or something else, but I'm foreseeing
much more usage and many more features in the near future. But with that, we
have enough to make an app. Running this main script gets us to a point where
Discord is talking to our bot and our bot is talking back.

As long as the command can run in my terminal. Let's fix that.

## Level 0: The Oldest Pi

Fully unwilling to do things out of order or shell out for infrastructure quite
yet, I have an old Raspberry Pi 2B laying around that's not doing anything and I
think it has just enough juice for this bot.

**HARD RECORD SCRATCH**

Guess what, gang. Running Deno on and/or compiling it for Raspbian ARM v7 is an
"unsupported platform" because "who the heck would want to do that anyway?" So,
now we get to do a build system that transpiles our Deno code to a simply
_enormous_ single-file node target bundle. I'm not going to show this build
system because it's a side-quest that we're going to pull up from very shortly.
As it turns out, installing Node on my little Pi just about maxed it out in
terms of storage, memory, and basically every other resource.

Also, I'm feeling like it's time to add some more learning, so we're going to
PIVOT TO GOLANG.

## Level 0.5: Old Pi, but in Go

As it turns out `discordgo` is delightful to use and compiling Go to ARM v7 is
as easy as... well... Pi. So after several minutes setting up cabling that I am
_not_ proud of, several more minutes setting up SSH and a Makefile of build and
deploy stages alongside a SystemD service unit file that gets put into
`/etc/systemd/system/discordbot.service`, we're back up again, and this time for
good!

```text
[Unit]
Description=Discord Bot Service
After=network.target

[Service]
User=discordbot
WorkingDirectory=/opt/discordbot/
ExecStart=/opt/discordbot/discordbot
Restart=always
RestartSec=5
EnvironmentFile=/opt/discordbot/.env

[Install]
WantedBy=multi-user.target
```

And there we go. As it turns out, Level 0.5 is probably as "architected" as most
people need to go. But that's not what I promised you, the readers. You were
promised absolutely silly levels of overbuild. So, I'll see you for Part 2 next,
where we go as far as even the fancier amongst you would go, and then we go just
a little bit further.

[^1]: Foreshadowing editor here: this decision does not last very long.
