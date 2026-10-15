---
name: make-my-short
description: Use this when the member wants to turn a video they filmed (a short or a vertical ad) into a finished short, when they say "make my short", "make my shorts", "edit this video", "cut this ad", or when they hand over a phone take or a folder of takes for a short. Also when they want a short without filming, as in "make it with my digital twin", "use my twin", "I don't want to film this" (their HeyGen twin reads the script, and that video is the take). A long video for YouTube (a talking take, a screen recording, a walkthrough of several minutes) is the cut-my-video skill, not this. Cuts it the way a pro editor does (1.15x, every pause down to 0.14 s, false starts and repeats out), puts their words on screen as they say them, adds an end card with the video's link, checks that no word was lost, and puts the finished short in their ChrisX Media. Needs a ChrisX account (checked through the ChrisX connector first). The cut runs on their own computer with ffmpeg and a speech-to-text model; the take never leaves it and no credits are used.
---

# Make my short

The member filmed it. You make it postable. You cut it yourself, on their computer, with no credits: ffmpeg cuts, and a
speech-to-text model such as Whisper gives each word its time. The take never leaves the machine; only the finished
short goes into their ChrisX Media. A short runs 15 s to 3 minutes. If what they hand over is a long video for YouTube,
use the cut-my-video skill instead. In a chat with no file tools (no Claude Code), say: "Make my short runs on your
computer, in Claude Code. Open Claude Code with the ChrisX plugin and send me the video there. Or cut it in your phone's
editor and keep the script and the link." Then stop, unless they want their digital twin to read it: that path (No
take, below) works in a chat up to its step 5.

Working files go in `${CLAUDE_PLUGIN_DATA}/work/<name>/` (`<work>` below), Whisper in `${CLAUDE_PLUGIN_DATA}/whisper/`,
and what they told you once in `${CLAUDE_PLUGIN_DATA}/settings.json`.

## No take: their digital twin

When they want the short without filming, their digital twin (their face and their voice, made by HeyGen) reads the
script, and that video is the take. It runs on their own HeyGen account and plan, never on ChrisX credits. Step 0
below still comes first.

1. **HeyGen connected?** Look for HeyGen's tools (`prepare_avatar_video`, `create_video_from_avatar`). Missing: say
   how to add it in 1 message, then wait.
   - In Claude (desktop or web): Settings, Connectors, Add custom connector, name `HeyGen`, URL
     `https://mcp.heygen.com/mcp/v1`, then sign in with their HeyGen account.
   - In Claude Code: `claude mcp add --transport http heygen https://mcp.heygen.com/mcp/v1`, then `/mcp` to sign in.
   - No HeyGen account yet: they make one at https://www.heygen.com first.
2. **The script.** The newest file in `content/scripts/`, or the one they paste. No script: write it with the Content
   playbook first (`list_playbooks`, then `get_playbook` with its id). The twin says it word for word, so fix it now, not after: short
   sentences, numbers written the way they are said.
3. **Their twin.** A look id saved in `settings.json`: use it and skip this step. Otherwise `prepare_avatar_video` with
   the script as `pendingVideoPrompt`, and follow what it returns. With no twin it leads to `open_avatar_creator`,
   HeyGen's own setup: a photo, a short motion clip, their consent recording and their voice, all done by them on
   screen. A twin is never made without their own consent recording. When it is ready, save its look id (and its voice
   id) to `settings.json`.
4. **The video.** `create_video_from_avatar` with the twin's look id, the script word for word, `aspectRatio` `9:16` and
   `resolution` `1080p`. `show_video` lets them watch it render; `get_video` gives the file's link once it is done.
5. **Now it is a take.** Download it to `<work>/twin.mp4` and run the Steps on it from step 1. It was not sped up, so
   step 3 speeds it to 1.15x, and its script is the script step 5 checks against. In a chat with no file tools:
   `import_media` with the video's link puts it in their Media uncut; say that the cut and the words on screen need
   Claude Code.

## Steps

0. **Check ChrisX first, every time.** Make my short is part of ChrisX. Call the ChrisX connector's `get_workspace`
   before anything else. It proves their account and names their own business (step 9 uploads to it). If Claude asks
   them to sign in, let them; it opens ChrisX's own sign-in. If the connector is not there, refuses, or says the account
   has no workspace or no plan, stop and say only: "Make my short comes with ChrisX. Start your free trial at
   https://chrisx.ai, connect it here, then send me the video again." Do not cut or install anything until
   `get_workspace` answers.

1. **Check the tools.** ffmpeg (with ffprobe, and its `ass` filter for the words on screen: `ffmpeg -hide_banner -filters`
   lists it), and a speech-to-text model that gives word times: `mlx-whisper` on an Apple Silicon Mac (`uname -sm` says
   `Darwin arm64`), `faster-whisper` everywhere else, in a Python 3 venv at `${CLAUDE_PLUGIN_DATA}/whisper/`. If one is
   missing, say which in 1 line and install it on their yes: "To cut on your computer I need ffmpeg (cuts the video) and
   Whisper (turns your voice into timed words). About 1.5 GB, one time. OK?" ffmpeg with Homebrew on a Mac
   (`brew install ffmpeg`; no Homebrew: send them to https://brew.sh first), the system's package manager elsewhere.
   Whisper: `python3 -m venv "${CLAUDE_PLUGIN_DATA}/whisper"`, then its own `pip install mlx-whisper` (or
   `faster-whisper`). The model (`mlx-community/whisper-large-v3-turbo`, or `large-v3-turbo` for faster-whisper) downloads
   once, on the first transcription.

2. **Ask only what is missing**, once, in 1 message, and save the answers to `settings.json`: their brand color (hex),
   the call to action for the end card, and their logo file if they have one. Optional: the script they read, a music
   file they own. In their ChrisX workspace (a CLAUDE.md with `chrisx:start`), the takes are in `content/footage/`, the
   script in `content/scripts/` (the newest file for this video) and the short goes to `content/shorts/`.
   The end card's link is the video's own link: `get_content_numbers` with status `planned` gives the planned videos
   with their plan_id (find this one by its title), then `get_video_link` with that plan_id. No plan for it yet:
   `plan_video` with its title first. A link of null means no live page yet: ask which link to put on the card.

3. **Speed it up.** Several takes: join them in order first. Then 1.15x:
   `ffmpeg -i "<take>" -filter_complex "[0:v]setpts=PTS/1.15[v];[0:a]atempo=1.15[a]" -map "[v]" -map "[a]" -c:v libx264 -crf 16 -preset veryfast -c:a pcm_s16le "<work>/fast.mkv"`
   Ask 1 thing only when you cannot tell: did they speed it up already when they exported it? If yes, keep the rate:
   `ffmpeg -i "<take>" -c:v libx264 -crf 16 -preset veryfast -c:a pcm_s16le "<work>/fast.mkv"`.

4. **Every word with its time.** Transcribe `<work>/fast.mkv` with word times and save each word with its start and end
   to `<work>/words.json`. With mlx-whisper:
   `"${CLAUDE_PLUGIN_DATA}/whisper/bin/python" -c 'import json,sys,mlx_whisper; r=mlx_whisper.transcribe(sys.argv[1], path_or_hf_repo="mlx-community/whisper-large-v3-turbo", word_timestamps=True); json.dump([{"w":w["word"],"s":w["start"],"e":w["end"]} for g in r["segments"] for w in g.get("words",[])], open(sys.argv[2],"w"))' "<work>/fast.mkv" "<work>/words.json"`
   With faster-whisper it is the same list from `WhisperModel("large-v3-turbo").transcribe(path, word_timestamps=True)`.

5. **Plan the cut, word by word.** Read the words. Keep the last full, clean try of every line. False starts (a line
   begun and begun again), repeats and stumbles go, and so does anything before the first line or after the last. With a
   script, hold the words against it line by line. Then the joins: every pause between kept words comes down to 0.14 s
   (a span ends 0.07 s after its last word, the next starts 0.07 s before its first; a pause already shorter stays).
   Save the spans, each with its words, to `<work>/plan.json`. Read the list of what you took out: anything that was
   real content, not a false start, a repeat or a stumble, is a reason to plan again. A single word that lasts 1.5 s or
   more may hide a restart the model swallowed: keep its time for step 7.

6. **Render.** Each span to its own piece (`ffmpeg -ss <start> -to <end> -i "<work>/fast.mkv"`, a 10 ms audio fade at
   each edge so no join clicks, `-c:v libx264 -crf 16 -preset veryfast -c:a pcm_s16le "<work>/p<nnn>.mkv"`), then join
   the pieces with the concat demuxer (`-f concat -safe 0 -i "<work>/list.txt" -c copy "<work>/joined.mkv"`). Then 1 pass
   to the short:
   - Vertical, 1080x1920. A take that is not 9:16 sits whole over a blurred copy of itself, never cropped.
   - Their words on screen as they say them: an ASS file, `<work>/words.ass`, with every kept word at its time in the cut
     (the length of the spans before it, plus its place in its own span), 1 to 3 words at a time, big and bold, in the
     lower third, the word being said in their brand color. Burned in with the `ass` filter. Font: Inter when they have
     it, else Helvetica or Arial.
   - The end card: the last frame held 2.5 s (`tpad=stop_mode=clone:stop_duration=2.5`, `apad` on the sound), the call
     to action and the link on it in big type on a solid box, their logo above it when they gave one.
   - A music file they own, when they gave one: under the voice, about 20 dB lower.
   - H.264 (`-crf 20 -pix_fmt yuv420p`), AAC sound, `-movflags +faststart`, to `<their folder>/<name>_short.mp4`.

7. **Prove no word was lost.** Transcribe the finished short again (step 4's way) and hold its words against the plan's
   kept words, and the script when there is one: every kept word is there, in order. A word missing: find the join that
   ate it, widen that span, render again and check again. Say "no word lost" only after this check passed. Words in the
   short that the plan does not hold are one of two things: a line the first reading never wrote down (keep it, and add
   it to the words on screen), or a false start or a repeat still in (plan it out and render again). Never say the cut
   is clean while one is in.

8. **Look before you hand it over.** Pull 1 frame from every 3 s and 1 from the end card
   (`ffmpeg -ss <t> -i "<short>" -frames:v 1 -vf scale=360:-1 f<k>.png`) and look at them: nothing cut off, nothing
   overlapping, every word on screen readable, the end card's link right. Fix and render again if not.

9. **Put it in their Media.** `upload_media` with the file's name, `video/mp4` and its size in bytes (and the business
   it is for, when it is a client's). PUT the file to the `upload_url` it gives
   (`curl -X PUT -H "Content-Type: video/mp4" --data-binary @"<short>" "<upload_url>"`), then `finish_upload` with the
   upload id, the type and the name. It is free, and a post or an ad can use it from there. Videos go up to 50 MB: a
   short over that is encoded again at a higher CRF first. Never post the upload link.

10. **Report.** Where the file is, how long it is, what the cut took out in plain words (for example "3 false starts, 1
    repeat and 9 seconds of pauses"), "no word lost", and that it is in their Media. Offer 1 next step: post it on
    YouTube Shorts first with the same link in the description, a different hook, a change to the words on screen, or
    the next short. Last, say how big `<work>` is and ask if they want it deleted; delete that folder only on their yes.

## Freedom

Any change: "cut that line", "keep that pause", "bigger words", "another color", "no end card": change the plan or the
words file and run step 6 again, then step 7. "Show me the plan" lists the spans with their words. A change to the take
(use another take, a line filmed again) is step 3 again; then the plan follows the new words.

## When something fails

Read ffmpeg's error and fix the cause: a take with no sound, a full disk, a missing tool, a span outside the take, a
bad hex color. Never upload their take anywhere to work around a local problem.
