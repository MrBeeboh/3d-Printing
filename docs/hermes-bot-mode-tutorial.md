# Your Robot Work Crew: A Beginner's Guide to Hermes Bot Mode (Multi-Agent)

> Turn one assistant into a whole team that works while you sleep — and tells you
> about it on Telegram.
>
> **Written for:** makers, 3D-printers, drone builders — anyone who wants a team of
> AI helpers, not just a single chat box. **Language:** plain English. No jargon.

---

## Table of Contents

1. [What is this? (plain-English intro)](#1-what-is-this)
2. [The big idea: bots are just profiles](#2-the-big-idea)
3. [Spawning your first experts](#3-spawning-your-first-experts)
4. [Delegation: handing off work](#4-delegation)
5. [Autonomous work while you sleep](#5-autonomous-work-while-you-sleep)
6. [Telegram handoff (check in from your phone)](#6-telegram-handoff)
7. [Kanban: the team's shared to-do board](#7-kanban)
8. [One full 3D-printing example, end to end](#8-worked-example)
9. [A simple 6-bot dream team](#9-sample-team)
10. [Graphics you can generate](#10-graphics)
11. [Audio / TTS narration script](#11-audio-script)
12. [Gotchas & quick fixes](#12-gotchas)

---

## 1. What is this?

**Bot Mode** lets you create extra "personalities" — we'll call them **bots** or
**agents** — and have them work together like a little company.

Think of it this way:

- **Normal Hermes** = one very smart assistant you talk to.
- **Bot Mode** = that one assistant *hiring a team*. A researcher to find answers,
  an engineer to build things, a designer to make the STL files, a critic to double-check
  work, and a foreman to boss them all around.

The best part: **you don't have to babysit them.** You hand a job to the foreman at night,
go to bed, and wake up to the finished files waiting in a folder plus a message on Telegram.

You can boss the whole team **from your phone** while standing at the printer. That's the
whole point of this guide.

---

## 2. The big idea: bots are just profiles

This is the one thing to remember because everything else is built on it:

> **A bot is just a separate Hermes profile.** It has its own settings, its own memory,
> its own history, and its own "personality" (a file called `SOUL.md`).

Profiles live in folders like `~/.hermes/profiles/<name>/`. The Bot Mode plugin is simply
a nicer on-screen way to manage those profiles — nothing special hidden under the hood.

Because a bot is just a profile:

- It can **run on its own**, even when you're not looking.
- It can **send you messages** on Telegram like a real person would.
- It can be **stopped, cloned, or deleted** safely — your main assistant is untouched.
- It shares the same **kanban board** (a to-do list) as every other bot.

**No extra hardware, no separate computer.** All bots run on the machine you already have.

> 💡 **Plain-English takeaway:** Bot Mode = several "brain clones" that each have a job,
> all sharing one to-do board and able to text you.

---

## 3. Spawning your first experts

You create a bot and give it a job. Here's the "new agent" recipe.

### Step 1 — Create the bot (easiest: desktop app)

1. Open Hermes. In the **Bots** tab (next to Sessions), click **New Agent**.
2. Give it a name and a one-line title. Example:
   - Name: `designer`
   - Title: "Designs 3D-printable parts in OpenSCAD"
3. Write a **role prompt** — a short paragraph telling it who it is and how to behave.
   Paste this into the SOUL.md box:
   ```
   You are DESIGNER. You turn ideas into printable OpenSCAD parts.
   You write clean .scad files and export .stl when asked.
   You always save your work under ~/Documents/3d_Printing/parts/.
   Your files must be real and on disk — never describe a file you didn't make.
   ```
4. (Advanced, optional) Clone from an existing bot or pick a model. You can skip this.

### Or do it from the command line (if you like typing)

```bash
hermes profile create designer
# write your role prompt to ~/.hermes/profiles/designer/SOUL.md
```

**⚠️ New-profile gotchas (they WILL bite):** a fresh profile has **no model** and **no
credentials**, so it can't talk to anything until you fix these two things:

```bash
# 1) Point it at a model you actually use:
hermes -p designer config set model.default deepseek-v4-flash
hermes -p designer config set model.provider deepseek

# 2) Share your API keys with it (symlink the main .env file):
ln -sf ~/.hermes/.env ~/.hermes/profiles/designer/.env
```

**Test the bot** before trusting it. It should reply instantly:

```bash
timeout 120 hermes -p designer chat -q "Reply with exactly: ONLINE"
# expect -> ONLINE
```

**Add skills** it needs for its job (designer wants the 3D-printing skills):

```bash
~/.hermes/scripts/sync-bot-skills.sh designer designer
# roles: engineer | researcher | designer | writer | critic | foreman | all
```

Repeat for each team member. Spawn them one at a time, test each, then move on.

---

## 4. Delegation: handing off work

**Delegation** = telling one bot "you do this part, then hand it to the next bot."
It's how a team gets more done than any single bot.

The team speaks to each other in a **handoff message** — a little note with all the
important info. A good handoff looks like this:

```
TASK MNT-014 · FROM foreman · TO engineer
OBJECTIVE: Mount the camera to the 7-inch frame.
INPUT: F450-Sentinel/Current design folder/ (read the frame files)
OUTPUT: STL for a camera mount + a short build note
APPROVAL: foreman
```

Every message is tagged so you know who said it:
> `[Message from agent 'engineer']`

### The golden rule of delegation

> **Do NOT delegate from a quick one-off command.**
> Use the **kanban board** (the team to-do list) for real jobs.
> A one-off command spawns a bot that dies as soon as the command ends — its sub-tasks
> get "interrupted" and nothing gets done. The board keeps workers alive until they finish.

So the real recipe for delegating is: **create a card on the board, assign it to a bot,
and let the always-on worker pick it up.** More in the [Kanban section](#7-kanban).

### What to delegate vs. keep

| Do this yourself | Delegate to the team |
|------------------|----------------------|
| Spending money / irreversible actions | Researching & comparing parts |
| Approving the final print | Drafting the STL/SCAD files |
| Anything ambiguous | Fact-checking and reviewing |
| Final sign-off | Writing docs & summaries |

**Money and irreversible things go to YOU.** The team knows this: ambiguous stuff goes to
the foreman, but purchases or anything permanent gets flagged `APPROVAL: michael`
(i.e. you) and stops until you say yes.

---

## 5. Autonomous work while you sleep

This is the magic feature: **give the team a job at night, wake up to finished work.**

Three pieces make it work together:

1. **The kanban board** holds the job so it isn't lost.
2. **A gateway worker** (an always-on process) picks up board tasks and runs them to
   completion — even when you're not in the app.
3. **Routines** (cron jobs) let a bot check in and report on a schedule.

### The overnight workflow, step by step

```text
Night    You: "foreman, by morning have a draft camera mount for the JeNo 7"
         -> foreman creates a card on the board, decomposes it into child cards:
              researcher (find specs) -> designer (draft .scad) -> critic (review)
         Each child is assigned to a bot and dependency-linked so they run in order.
         The gateway worker grabs the first card and starts working. FOREVER. No babysitting.

Morning  You wake up. Telegram buzzes with a digest:
              "3/3 cards done. STL at .../CAMERA_Mount_v1.stl. Approve to print?"
         You reply from bed: "approve"  -> the print card unlocks.
```

### Why it doesn't stop when you close the app

A board task starts a **standalone worker process** that keeps heartbeating to the board
until it's done:

```bash
hermes -p foreman --cli chat -q work kanban task t_<id>
```

Even if you close the app, the worker keeps going. If a card depends on another card,
it **auto-starts** the moment the parent flips to `done`. So the pipeline fires itself.

### Scheduling a bot to check in (a routine)

A routine is just a cron job with a bot's name on it:

```text
Name:   [bot:foreman] Nightly standup
When:   06:30 daily
Prompt: Run 'hermes kanban list', compile a digest with file paths,
        blockers, and decisions I need. Deliver to telegram:<your_chat_id>.
```

Now the foreman "wakes up" every morning, looks at the board, and tells you where things
stand — even if you never opened the app.

> 💡 **Plain-English takeaway:** board + always-on worker + a morning routine = you get to
> sleep. The team reports for duty and reports back to you.

---

## 6. Telegram handoff

You don't have to sit at your desk. The team can **text you on Telegram**, and you can
**talk back from your phone.**

### One-time setup (do this once)

Telegram messages to your home channel are **off by default** for each bot. Turn it on:

```bash
hermes -p foreman config set platforms.telegram.enabled true
hermes -p foreman send -t "telegram:<your_chat_id>" "Morning digest from the team:"
```

> 🧩 `send` uses the gateway's Telegram token and works **even if the gateway is not
> running** — a bot can text you from anywhere.

To find your personal chat id (use this once):

```bash
sqlite3 ~/.hermes/state.db "SELECT DISTINCT chat_id, chat_type FROM sessions WHERE chat_id NOT IN ('','0','null')"
```

And confirm the token is set:

```bash
grep -E 'TELEGRAM_BOT_TOKEN|TELEGRAM_HOME_CHANNEL' ~/.hermes/.env
```

### Make the board text you when work finishes

```bash
hermes kanban notify-subscribe t_<orchestrator-id> \
  --platform telegram --chat-id <your_chat_id> \
  --chat-type dm --delivery-mode notify+wake
```

Now when a card flips to `done`, you get pinged with the result. Verify with
`hermes kanban notify-list`.

### Prove it works before you rely on it

Send a real test task and confirm the message actually lands in your channel. **"It should
work" is not proof — a delivered message is proof.**

> 💡 **Plain-English takeaway:** the team texts you; you reply from the phone. You're
> running the whole operation from the printer, not your desk.

---

## 7. Kanban: the team's shared to-do board

**Kanban** is a fancy name for a sticky-note board: `todo → running → blocked → done`.
Every bot sees the same board, so nobody forgets a job and nobody does the same job twice.

### Where it lives

The real board is **one shared file** every profile uses:

```text
~/.hermes/kanban.db
```

> ⚠️ Don't look in `~/.hermes/profiles/<name>/projects.db` — that file only holds project
> metadata, **no task cards**. Check the wrong file once and you'll wrongly think "the team
> never worked."

### Everyday commands

```bash
hermes kanban create "Design camera mount" --assignee designer --priority high
hermes kanban list
hermes kanban status t_<id>            # where is this task?
hermes kanban log t_<id>               # full reasoning history
hermes kanban notify-list              # who gets pinged on completion
```

### Cards talk to each other (dependencies)

A card can depend on another card. When the parent flips to `done`, the child
**auto-starts**. That's how you build an overnight pipeline:

```text
t_research (researcher) ──done──▶ t_design (designer) ──done──▶ t_review (critic)
                                                                     │ done
                                                                     ▼
                                                           t_print (Ender-3)
```

You create the children with a `parents:` link so they fire in order:

```bash
hermes kanban create "Draft mount" --assignee designer --parents t_research
```

### Reviewing work (the critic's job)

A `blocked` card isn't necessarily failure — it often means the **critic said
"needs changes"** and the designer is iterating. That's the team being careful, not
broken. **Before you declare anything stuck:** check that the actual file is on disk
(a `.scad` / `.stl` / `.gcode`). A card can say `done` while the real file is missing —
always confirm the file exists, not just the sticker.

> 💡 **Plain-English takeaway:** kanban is the team's shared to-do wall. Assign a card,
> link the order, and the team works through it — pinging you when each step finishes.

---

## 8. One full 3D-printing example, end to end

Here's a realistic overnight run, the way it actually works.

**Your request (evening):**
> "Foreman, design a mount to put my camera on the 7-inch drone frame. I want it printed
> by morning. Let me know before you print."

**What the foreman does (without you):**

1. Creates a top-level card and splits it into ordered children:
   - `t_research` → **researcher**: specs of the frame + camera mounting holes.
   - `t_design` → **designer**: OpenSCAD draft → export `.stl`.
   - `t_review` → **critic**: check it will actually fit (using a *different* AI so it's
     a fresh pair of eyes).
   - `t_print` → **foreman**: queue it on the Ender-3, but **wait for your OK**.
2. Links each child so it auto-starts after the previous one is `done`.
3. Subscribes the top card to ping you on Telegram when it finishes.

**While you sleep:** the gateway worker runs each card in order. The designer writes real
files to `~/Documents/Drones/F450-Sentinel/Current design folder/`.

**Morning:** Telegram buzzes.

> `[foreman] Morning, Michael. 3/3 cards done.`
> `STL: .../CAMERA_Mount_v1.stl · SCAD: .../CAMERA_Mount_v1.scad`
> `Review: PASS (fits JeNo 7, holes align). Approve to print?`

**You, from your phone:**
> `approve`

The print card unlocks and goes to the printer. You roll out of bed to a printed part.

---

## 9. A simple 6-bot dream team

A practical starting roster for a maker shop:

| Bot | Job | Catches |
|-----|-----|---------|
| **foreman** | Routes tasks, tracks the board, reports to you | No real work itself |
| **researcher** | Finds specs, compares parts, sources hardware | Facts + sources |
| **engineer** | Builds things, does the actual integration | Real artifacts |
| **designer** | Turns ideas into OpenSCAD / STL parts | Real `.scad`/`.stl` files |
| **writer** | Docs, build notes, tutorials | Clear prose |
| **critic** | Reviews everyone's work with fresh eyes | Uses a DIFFERENT AI than the maker |

**Minimum viable team if you're in a hurry:** just **foreman + researcher + writer**.

**Extra bot worth having:** a **survivor** bot that runs on a local model only, so you
still have a working assistant even if the internet drops. It can also absorb the cloud
team's knowledge so it's useful offline.

---

## 10. Graphics you can generate

Below are ready-to-use image prompts (text-to-image) plus where to drop each graphic.
Suggest a 16:9 hero + a few square "cards" for a tutorial slideshow.

**Hero image — "Your overnight robot crew" (landscape, for the top):**
> A clean flat illustration of a cozy night-time maker workshop. One person asleep in a
> bed, phone glowing beside them showing a chat bubble "3/3 cards done". On a desk, four
> friendly small robot figurines labeled with badges: RESEARCHER, DESIGNER, ENGINEER,
> FOREMAN, all working at tiny workstations. A sticky-note kanban board on the wall with
> colorful cards: TODO, RUNNING, DONE. A 3D printer in the corner. Soft blue night tones,
> warm lamp light, friendly Pixar-style, no text clutter.

**Square card — "What is a bot?":**
> Four separate friendly robot heads in a row, each a different pastel color and shape,
> floating above a keyboard. One smiling brain icon above the row labeled "1 assistant →
> a whole team". Clean white background, flat illustration.

**Square card — "The board":**
> A kanban board with three columns labeled TODO / RUNNING / DONE. Sticky notes shaped
> like little parts (a wrench, a camera, a spool of filament). One note is being moved
> from RUNNING to DONE. Bright, minimal, readable.

**Square card — "Delegation / handoff":**
> One robot handing a glowing envelope (the handoff note) to another robot, who passes it
> to a third. Arrows showing the chain. On the envelope: tiny text "TASK · FROM · TO · APPROVAL".

**Square card — "Telegram":**
> A smartphone showing a chat screen with three bubbles from "foreman": a status digest,
> a file path, and a "Approve to print?" prompt. A thumbs-up reaction bubble from the user.
> Clean app-UI style, readable.

**Square card — "You sleep, they work":**
> A clock showing 11:59 PM on the left and 7:00 AM on the right. Between them, a row of
> robots passing a finished STL part along a conveyor to a 3D printer. Sunrise colors.

> **Note:** generate these with the `image_generate` tool (e.g. "FLUX" backend). Drop the
> hero at the top of the doc and the square cards beside their matching sections.

---

## 11. Audio / TTS narration script

Read this with a calm, friendly voice for a ~3-minute overview. Use with the hero image.

---

**(0:00 — Hero image)** "Meet your robot work crew. Hermes Bot Mode turns one assistant
into a whole team. Same computer, same brains — just a team of specialists."

**(0:15)** "Here's the trick that makes it simple: a bot is just a separate profile. It has
its own memory, its own personality, and its own job. The designer designs. The researcher
researches. The critic double-checks. And the foreman keeps everybody on track."

**(0:40)** "You hand the foreman a job — like, design a camera mount for my drone. The
foreman puts it on the team's kanban board, splits it into steps, and assigns each step to
the right bot. The researcher finds the specs, then the designer drafts the part, then the
critic checks the fit."

**(1:05)** "Now the best part. Because the job lives on the board, the workers keep going
even after you close the app. You go to sleep. They keep working. In the morning, you wake
up to a message on Telegram: three of three cards done, here's your STL file, ready to
print."

**(1:35)** "And you don't even need to be at your desk to steer it. The team texts you.
From your phone you can say 'approve', and the next step — the actual print — kicks off on
its own."

**(1:55)** "A few friendly rules to keep it safe. Money and irreversible actions always
come back to you. The team flags those and waits for your yes. And before you trust a
finished card, check that the real file exists on disk. A sticker that says done is nice;
a part that's on the shelf is better."

**(2:20)** "So that's it. Spawn your experts, hand them the job, go to bed, and let them
text you in the morning. Happy building."

---

> **TTS tip:** run this script through the `text_to_speech` tool (OpenAI/Edge voice) with
> a friendly tone. ~2.5 minutes. Pair the narration timing with the slideshow graphics
> from [Section 10](#10-graphics) for a full video, or use the narrated-slideshow skill.

---

## 12. Gotchas & quick fixes

| Symptom | Cause | Fix |
|---------|-------|-----|
| New bot says "No API key found" / "No usable credentials" | Fresh profile has no model + empty `.env` | Set model/provider + symlink `~/.hermes/.env` (see [§3](#3-spawning-your-first-experts)) |
| Bots tab missing in the app | Plugin not reloaded | `Ctrl+K` → "Reload desktop plugins", or fully restart the app |
| Sub-agents die after ~7 seconds, nothing written | Delegated from a one-off command | Use the **kanban board** so a standalone worker runs the task |
| Bot says "4 cards created" but board is empty | Bot used the wrong tool / lied | Check `hermes kanban list` directly — never trust a self-report |
| Board looks stuck on BLOCKED | Critic wants changes (a review loop) | Check the real `.scad`/`.stl` is on disk before calling it failed |
| Telegram digest never arrives | Telegram not enabled for that bot | `hermes -p <bot> config set platforms.telegram.enabled true` |
| Bot switched model mid-run, handoff stalls | Model switched while busy | Switch models only when the bot is idle |
| Checked `projects.db`, "team did nothing" | Wrong database | Real board is the shared `~/.hermes/kanban.db` |

---

### Cheat sheet (the whole workflow in 8 lines)

```bash
# spawn + fix a bot
hermes profile create designer
hermes -p designer config set model.default deepseek-v4-flash
hermes -p designer config set model.provider deepseek
ln -sf ~/.hermes/.env ~/.hermes/profiles/designer/.env

# hand it work on the board (durable)
hermes kanban create "Design camera mount" --assignee designer --priority high

# let the team text you
hermes -p foreman config set platforms.telegram.enabled true
hermes kanban notify-subscribe t_<id> --platform telegram --chat-id <your_id> --chat-type dm --delivery-mode notify+wake

# see everything
hermes kanban list
```

---

*Generated for the HAL2026 Hermes setup. Pair with the `hermes-bot-mode` skill for
operational detail.*
