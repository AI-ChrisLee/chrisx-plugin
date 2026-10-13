---
name: make-my-short
description: Use this when the member wants to turn a video they filmed (a short or a vertical ad) into a finished short, when they say "make my short", "make my shorts", "edit this video", "cut this ad", or when they hand over a video file or a folder of takes. Cuts it the way a pro editor does (1.15x, every pause down to 0.14 s, false starts and repeats out), then builds the kinetic page around it: their words landing as they speak, their screens and photos floating in cards, lists, numbers counting up, bars, steps, and an end card with their booking link. Needs a ChrisX account (checked through the ChrisX connector first). Runs on their own computer; nothing is uploaded and no credits are used.
---

# Make my short

The member filmed it. You make it postable. Everything runs on their computer: ffmpeg cuts, a local Whisper turns the
voice into timed words, and the renderer draws the kinetic page. The video never leaves the machine.

The script: `python3 "${CLAUDE_PLUGIN_DATA}/short-kit/scripts/make_short.py"` (call it `MS` below). Step 0 puts it
there. Always pass `--data-dir "${CLAUDE_PLUGIN_DATA}"`; settings, Whisper, the renderer and caches live there.

## Steps

0. **Get the short maker from ChrisX first, every time.** Make my short is part of ChrisX, and the short maker is not
   in this plugin: it comes from the ChrisX connector. Call its `get_short_kit` before anything else. It also proves
   their account. If Claude asks them to sign in, let them; it opens ChrisX's own sign-in. If the connector is not
   there, refuses, or says the account has no workspace or no plan, stop and say only: "Make my short comes with
   ChrisX. Start your free trial at https://chrisx.ai, connect it here, then send me the video again." (If it only
   says the short maker is not ready, tell them to try again in a minute.) Do not cut, render or install anything
   until `get_short_kit` answers.
   Then download and unpack the kit exactly as its answer says, into `${CLAUDE_PLUGIN_DATA}/short-kit/`. If
   `${CLAUDE_PLUGIN_DATA}/short-kit/VERSION` already reads the version it names, skip the download: the kit is
   current. Otherwise download its link with `curl -fL -o` into a new temporary folder (the link works 5 minutes; call
   `get_short_kit` again for a fresh one), unzip it into `${CLAUDE_PLUGIN_DATA}/short-kit/` (replace that folder only,
   never the rest of the data folder), and delete the temporary folder. Never post the link or the zip.

1. **Check the tools.** `MS doctor --data-dir "${CLAUDE_PLUGIN_DATA}"`.
   If it ends in `MISSING`, tell them in 1 line what you'll install and why, and wait for their OK:
   "To edit on your computer I need ffmpeg (cuts the video), Whisper (turns your voice into timed words) and the
   renderer (draws the page). About 2.5 GB, one time. OK?"
   Then `MS setup --ffmpeg --node --data-dir "${CLAUDE_PLUGIN_DATA}"` (drop `--ffmpeg` or `--node` when doctor found
   them). On a Mac with no Homebrew, send them to https://brew.sh first.

2. **Ask only what is missing**, once, in 1 message: their brand color (hex), the call to action and booking link for
   the end card, and their logo file. They are remembered (`MS settings ... --brand-color --cta --link --logo`).
   Ask for the screens and photos the short should show: their site, listings, results, reviews. Optional: the script
   they read, a music file.

3. **Cut.** `MS make "<video or folder of takes>" --clean --out "<their folder>/<name>_cut.mp4" --data-dir ...`
   [`--script script.txt`] [`--speed 1` when the take is already sped up]. It prints the job folder with `take.mp4`,
   `plan.json` and `scenes.draft.json`, and what it cut.

4. **Plan the page.** Read `${CLAUDE_PLUGIN_DATA}/short-kit/references/kinetic-types.md` and the draft. Copy the draft to
   `<job>/scenes.json` and turn every scene into the type that shows its line best, with their own screens in the cards.
   This is the craft: their words only, their real numbers only, a new picture every 2 to 4 s, never the same type
   twice in a row.

5. **Render.** `MS kinetic "<job>/scenes.json" --out "<their folder>/<name>_short.mp4" --data-dir ...`
   It checks the plan first and names any problem; fix the plan and run it again.

6. **Look before you hand it over.** Pull 1 frame from near the end of every scene
   (`ffmpeg -ss <t> -i <short> -frames:v 1 -vf scale=360:-1 f<k>.png`) and look at them: nothing cut off, nothing
   overlapping, every card readable. Fix the plan and render again if not.

7. **Report.** Where the file is, how long it is, what the cut took out (in plain words), and the scenes as
   `time · type · what it shows`. Offer 1 next step: a different hook, a change to any scene, or the next short.

## Freedom

Any scene can change. "Put my site here", "a list there", "no phone", "bigger", "slower", "no end card": edit
`scenes.json` and run step 5 again (about a minute). "Show me the plan" lists the scenes. A change to the cut (drop a
line, use another take) is step 3 again; then the plan follows the new words.

## Captions only

When they can't install Node, or ask for plain captions: `MS make "<video>" --out ... --data-dir ...` without `--clean`
makes the short on their footage alone (clean captions with the key word in serif italic, the hook, punch-ins, an end
card), no renderer needed.

## When something fails

Read the `ERROR:` line and fix the cause: a take with no sound, a file the plan names that isn't there, a bad hex
color, a word range outside the words. Never upload their video anywhere to work around a local problem.

The same harness makes a wide video with no voice (a site's hero, an ad on music): `"format": "16:9"`, `"take": ""`,
lines as text (`${CLAUDE_PLUGIN_DATA}/short-kit/references/kinetic-types.md`), rendered with the same `kinetic` command.

Remotion (the renderer's engine) is free for individuals and companies with up to 3 employees; a bigger company needs
its own Remotion license (remotion.dev/license).
