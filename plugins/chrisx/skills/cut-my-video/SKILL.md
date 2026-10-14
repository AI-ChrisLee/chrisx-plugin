---
name: cut-my-video
description: Use this when the member wants a long video they filmed (a talking take, a screen recording, a walkthrough, a YouTube video) cut and ready to upload, when they say "cut my video", "cut this take", "edit my YouTube video", "add captions and chapters", or when they hand over a long video file. A short or a vertical ad is the make-my-short skill, not this. Cuts it the way a pro editor does (1.15x, every pause down to 0.14 s, false starts and repeats out, a breath where the topic turns), checks that no word was lost, and hands back a 1080p file, the captions as an SRT and the chapter list for the description. Needs a ChrisX account (checked through the ChrisX connector first). Runs on their own computer; nothing is uploaded and no credits are used.
---

# Cut my video

The member filmed one long take. You cut it so it is ready for YouTube. Everything runs on their computer: ffmpeg cuts,
a local Whisper turns the voice into timed words. The video never leaves the machine, and you upload nothing.

The script: `python3 "${CLAUDE_PLUGIN_DATA}/short-kit/scripts/make_short.py"` (call it `MS` below). Step 0 puts it
there, the same one Make my short uses. Always pass `--data-dir "${CLAUDE_PLUGIN_DATA}"`; settings, Whisper and caches
live there. In a chat with no file tools (no Claude Code), say: "Cut my video runs on your computer, in Claude Code.
Open Claude Code with the ChrisX plugin and send me the video there." Then stop.

## Steps

0. **Get the cutting tool from ChrisX first, every time.** Cut my video is part of ChrisX, and the tool is not in this
   plugin: it comes from the ChrisX connector. Call its `get_short_kit` before anything else. It also proves their
   account. If Claude asks them to sign in, let them; it opens ChrisX's own sign-in. If the connector is not there,
   refuses, or says the account has no workspace or no plan, stop and say only: "Cut my video comes with ChrisX. Start
   your free trial at https://chrisx.ai, connect it here, then send me the video again." (If it only says the tool is
   not ready, tell them to try again in a minute.) Do not cut or install anything until `get_short_kit` answers.
   Then download and unpack the kit exactly as its answer says, into `${CLAUDE_PLUGIN_DATA}/short-kit/`. If
   `${CLAUDE_PLUGIN_DATA}/short-kit/VERSION` already reads the version it names, skip the download: the kit is
   current, unless `MS make --help` has no `--format` option (a kit from before the long cut carries the same date):
   then download it again. Otherwise download its link with `curl -fL -o` into a new temporary folder (the link works 5
   minutes; call `get_short_kit` again for a fresh one), unzip it into `${CLAUDE_PLUGIN_DATA}/short-kit/` (replace that
   folder only, never the rest of the data folder), and delete the temporary folder. Never post the link or the zip.

1. **Check the tools.** `MS doctor --cut-only --data-dir "${CLAUDE_PLUGIN_DATA}"`. A cut needs ffmpeg and Whisper
   only: no Node and no renderer. If it ends in `MISSING`, tell them in 1 line what you'll install and why, and wait
   for their OK: "To cut your video I need ffmpeg (cuts it) and Whisper (turns your voice into timed words, so I can
   cut the stumbles and write the captions). About 1.5 GB, one time. OK?" Then
   `MS setup --cut-only --ffmpeg --data-dir "${CLAUDE_PLUGIN_DATA}"` (drop `--ffmpeg` when doctor found it). On a Mac
   with no Homebrew, send them to https://brew.sh first.

2. **Find the take and the script.** In their ChrisX workspace (a CLAUDE.md with `chrisx:start`) the take is in
   `content/footage/`, the script in `content/scripts/` (the newest file for this video) and the cut goes to
   `content/long/`. Outside a workspace, ask where the video is and put the cut beside it. The script is the best help
   there is: it keeps the best take of every line, and each `## ` heading in it becomes a chapter. No script: it still
   cuts, and it finds the chapter breaks from the pauses. Ask 1 thing only when you cannot tell: did they speed the
   video up already when they exported it? If yes, add `--speed 1`; the cut plays a raw take at 1.15x.

3. **Cut.** Say it takes a few minutes (a 12-minute take took about 6 on a recent Mac), and that it keeps working files
   on the disk (an 11-minute screen recording took 0.5 GB; a busy picture can take several times that); the tool stops
   with a clear message if the disk is too full. Then:
   `MS make "<take>" --clean --format 16:9 [--script "<script.md>"] [--speed 1] --srt "<folder>/<name>.srt" --chapters --out "<folder>/<name>_cut.mp4" --data-dir "${CLAUDE_PLUGIN_DATA}"`
   `<folder>` is `content/long/` in a workspace. Several takes of one video: pass the folder or each file in order.
   It prints what it cut, the breaths it kept, the chapters and where the plan file is.

4. **Read what it took out.** The printout lists every cut with its time, a line each. False starts, repeats and
   stumbles are the point. A line marked `other take / off-script` that is a real point of theirs is not: it means the
   script and the voice differ (often a number said as a word, where the script has the numeral). Tell them in 1 line,
   fix the script's line, and run step 3 again (the working files are kept, so a second run is faster). With a script,
   a line found at less than 80% shows `kept: "..."`, the words it took for that line: when they are not the line (a
   line they skipped can match 1 or 2 words said somewhere else), tell them, cut the line from the script, and run
   step 3 again. A `Listen:` block lists words that sit on 1.5 s or more of speech: the speech model may have swallowed
   a restart there, so it can still be in the cut. Keep those times for step 5.

5. **Prove no word was lost.** `MS verify "<folder>/<name>_cut.mp4" "<the plan.json it printed>" --data-dir "${CLAUDE_PLUGIN_DATA}"`
   listens to the finished cut again and compares it with the words the plan kept. It must print `NO WORD LOST`. If it
   prints `WORDS LOST`, listen at those times, fix the cause, cut again and verify again. Say "no word lost" only after
   you saw that line. It can also print a `Listen:` list of places where the cut says words the plan does not hold.
   Each place is one of two things. A line of theirs the first reading never wrote down (the captions lack it: add it
   in step 7), or a false start or a repeat that is still in the cut. Read the words and tell which. For a false start
   still in, tell them its time and the words in 1 line: they trim those seconds in their own editor, or film the
   line again. Never say the cut is clean while one is in.

6. **The chapters.** If it printed a list from their script's parts, keep it. If it printed `[title this]` (the script
   has no parts, or there is no script), read the words around each time in the plan file and give each break a title
   of 2 to 5 plain words in their own language. If it printed none, read the plan file's words and pick 3 or more turns
   in the talk. Always: the first is 0:00, at least 3, each at least 10 seconds long. Save the final list as
   `<folder>/<name>.chapters.txt`, one `0:00 Title` a line.

7. **The captions.** Open the `.srt` and fix names and product words Whisper heard wrong, in the text lines only
   (never the numbers or the times). One line per caption, 38 characters at most: keep it. A line of theirs that
   step 5 found in the cut and the captions lack: add a caption for it, at the time step 5 gave, ending before the
   next caption starts.

8. **Look before you hand it over.** Pull 1 frame from the start, the middle and the end
   (`ffmpeg -ss <t> -i <cut> -frames:v 1 -vf scale=480:-1 f<k>.png`) and look at them: the whole screen is there,
   nothing cut off. A video that is not 16:9 sits whole over a blurred copy of itself, never cropped.

9. **Report.** Where the file is and how long it is (from how long the take was), what the cut took out in plain
   words (for example "4 false starts, 2 repeats, 11 stumbles and 3 minutes of pauses"), the chapter list, and the
   `.srt` path. Then the upload, about 3 minutes, by hand in YouTube Studio: Create, Upload videos, pick the MP4; the
   title and description (paste the chapter list in the description; the first line is `0:00`); the thumbnail; publish.
   After it is up: Subtitles, the video, Add language, Upload file, With timing, pick the `.srt`. A channel that is not
   verified uploads up to 15 minutes: they verify at youtube.com/verify with a phone, once. If the Content playbook
   made a listing file for this video, offer to fill the description from it. Last, say how big the working files are
   (the printout names the folder) and ask if they want them deleted; delete that folder only on their yes.

## Freedom

"Cut it tighter", "keep my pauses", "no chapters", "drop that part": change the script or the options and run step 3
again. `--max-gap` sets the longest pause kept inside a line; `--speed 1` keeps the rate as filmed. `--plan-only`
prints the plan and the chapters without making the video. The cut never adds music, type or an end card: it is the
video, cut.

## When something fails

Read the `ERROR:` line and fix the cause: a take with no sound, a full disk, a missing tool. Never upload their video
anywhere to work around a local problem.
