---
name: cut-my-video
description: Use this when the member wants a long video they filmed (a talking take, a screen recording, a walkthrough, a YouTube video) cut and ready to upload, when they say "cut my video", "cut this take", "edit my YouTube video", "add captions and chapters", or when they hand over a long video file. A short or a vertical ad is the make-my-short skill, not this. Cuts it the way a pro editor does (1.15x, every pause down to 0.14 s, false starts and repeats out, a breath where the topic turns), checks that no word was lost, and hands back a 1080p file, the captions as an SRT and the chapter list for the description. Needs a ChrisX account (checked through the ChrisX connector first). Runs on their own computer with ffmpeg and a speech-to-text model; nothing is uploaded and no credits are used.
---

# Cut my video

The member filmed one long take. You cut it yourself so it is ready for YouTube, on their computer, with no credits:
ffmpeg cuts, and a speech-to-text model such as Whisper gives each word its time. The video never leaves the machine,
and you upload nothing. In a chat with no file tools (no Claude Code), say: "Cut my video runs on your computer, in
Claude Code. Open Claude Code with the ChrisX plugin and send me the video there. Or cut it in your own editor and keep
the script and the link." Then stop.

Working files go in `${CLAUDE_PLUGIN_DATA}/work/<name>/` (`<work>` below) and Whisper in
`${CLAUDE_PLUGIN_DATA}/whisper/`, the same place Make my short uses.

## Steps

0. **Check ChrisX first, every time.** Cut my video is part of ChrisX. Call the ChrisX connector's `get_workspace`
   before anything else. It proves their account. If Claude asks them to sign in, let them; it opens ChrisX's own
   sign-in. If the connector is not there, refuses, or says the account has no workspace or no plan, stop and say only:
   "Cut my video comes with ChrisX. Start your free trial at https://chrisx.ai, connect it here, then send me the video
   again." Do not cut or install anything until `get_workspace` answers.

1. **Check the tools.** A cut needs ffmpeg (with ffprobe) and a speech-to-text model that gives word times:
   `mlx-whisper` on an Apple Silicon Mac (`uname -sm` says `Darwin arm64`), `faster-whisper` everywhere else, in a
   Python 3 venv at `${CLAUDE_PLUGIN_DATA}/whisper/`. If one is missing, say which in 1 line and install it on their
   yes: "To cut your video I need ffmpeg (cuts it) and Whisper (turns your voice into timed words, so I can cut the
   stumbles and write the captions). About 1.5 GB, one time. OK?" ffmpeg with Homebrew on a Mac (`brew install ffmpeg`;
   no Homebrew: send them to https://brew.sh first), the system's package manager elsewhere. Whisper:
   `python3 -m venv "${CLAUDE_PLUGIN_DATA}/whisper"`, then its own `pip install mlx-whisper` (or `faster-whisper`). The
   model (`mlx-community/whisper-large-v3-turbo`, or `large-v3-turbo` for faster-whisper) downloads once, on the first
   transcription.

2. **Find the take and the script.** In their ChrisX workspace (a CLAUDE.md with `chrisx:start`) the take is in
   `content/footage/`, the script in `content/scripts/` (the newest file for this video) and the cut goes to
   `content/long/`. Outside a workspace, ask where the video is and put the cut beside it (`<folder>` below). The script
   is the best help there is: it keeps the best take of every line, and each `## ` heading in it becomes a chapter. No
   script: it still cuts, and you find the chapter breaks from the words. Ask 1 thing only when you cannot tell: did
   they speed the video up already when they exported it? If yes, keep the rate in step 3.

3. **Speed it up.** Say it takes a few minutes and keeps working files on the disk (a copy about the size of the take,
   and the pieces), and check the free space first (`df -h`): too full, say so in 1 line and stop. Several takes of 1
   video: join them in order first. Then 1.15x:
   `ffmpeg -i "<take>" -filter_complex "[0:v]setpts=PTS/1.15[v];[0:a]atempo=1.15[a]" -map "[v]" -map "[a]" -c:v libx264 -crf 16 -preset veryfast -c:a pcm_s16le "<work>/fast.mkv"`
   Already sped up: the same without the filter (`ffmpeg -i "<take>" -c:v libx264 -crf 16 -preset veryfast -c:a pcm_s16le "<work>/fast.mkv"`).

4. **Every word with its time.** Transcribe `<work>/fast.mkv` with word times and save each word with its start and end
   to `<work>/words.json`. With mlx-whisper:
   `"${CLAUDE_PLUGIN_DATA}/whisper/bin/python" -c 'import json,sys,mlx_whisper; r=mlx_whisper.transcribe(sys.argv[1], path_or_hf_repo="mlx-community/whisper-large-v3-turbo", word_timestamps=True); json.dump([{"w":w["word"],"s":w["start"],"e":w["end"]} for g in r["segments"] for w in g.get("words",[])], open(sys.argv[2],"w"))' "<work>/fast.mkv" "<work>/words.json"`
   With faster-whisper it is the same list from `WhisperModel("large-v3-turbo").transcribe(path, word_timestamps=True)`.

5. **Plan the cut, word by word.** Read the words. Keep the last full, clean take of every line. False starts (a line
   begun and begun again), repeats and stumbles go, and so does anything before the first line or after the last. With
   a script, hold the words against it line by line. A line said a little differently from the script is still their
   line (often a number said as a word where the script has the numeral): keep it. A script line you cannot find in the
   words was skipped: tell them in 1 line. Then the joins: every pause between kept words comes down to 0.14 s (a span
   ends 0.07 s after its last word, the next starts 0.07 s before its first; a pause already shorter stays), except a
   breath where the topic turns: about 0.5 s at each `## ` part of the script (or the whole pause, when it is shorter).
   Save the spans, each with its words, to `<work>/plan.json`. Read the list of what you took out: anything that was
   real content, not a false start, a repeat or a stumble, is a reason to plan again. A single word that lasts 1.5 s or
   more may hide a restart the model swallowed: keep its time for step 7.

6. **Render.** Each span to its own piece (`ffmpeg -ss <start> -to <end> -i "<work>/fast.mkv"`, a 10 ms audio fade at
   each edge so no join clicks, `-c:v libx264 -crf 16 -preset veryfast -c:a pcm_s16le "<work>/p<nnn>.mkv"`), then join
   the pieces with the concat demuxer (`-f concat -safe 0 -i "<work>/list.txt" -c copy "<work>/joined.mkv"`). Then 1 pass
   to the cut: 1920x1080; a video that is not 16:9 sits whole over a blurred copy of itself, never cropped. H.264
   (`-crf 18 -pix_fmt yuv420p -colorspace bt709 -color_primaries bt709 -color_trc bt709`), AAC sound (`-b:a 192k`),
   `-movflags +faststart`, to `<folder>/<name>_cut.mp4`.

7. **Prove no word was lost.** Transcribe the finished cut again (step 4's way) and hold its words against the plan's
   kept words, and the script when there is one: every kept word is there, in order. A word missing: find the join that
   ate it, widen that span, render again and check again. Say "no word lost" only after this check passed. Words in the
   cut that the plan does not hold are one of two things: a line of theirs the first reading never wrote down (keep it;
   the captions in step 9 come from this second reading, so they have it), or a false start or a repeat still in (look
   at the step 5 times too; plan it out and render again). Never say the cut is clean while one is in.

8. **The chapters.** With a script, each `## ` part is a chapter, at the time its first kept word lands in the cut,
   titled with the heading's words. No parts, or no script: read the words and pick 3 or more turns in the talk, each
   titled with 2 to 5 plain words in their own language. Always: the first is 0:00, at least 3, each at least 10
   seconds long. Save the list as `<folder>/<name>.chapters.txt`, one `0:00 Title` a line.

9. **The captions.** Write `<folder>/<name>.srt` from step 7's reading of the finished cut (its times are the cut's own).
   One line per caption, 38 characters at most, 1 to 6 s each, split where the meaning breaks, each ending before the
   next starts. Fix names and product words the model heard wrong, from the script, in the text only (never the times).

10. **Look before you hand it over.** Pull 1 frame from the start, the middle and the end
    (`ffmpeg -ss <t> -i "<cut>" -frames:v 1 -vf scale=480:-1 f<k>.png`) and look at them: the whole screen is there,
    nothing cut off.

11. **Report.** Where the file is and how long it is (from how long the take was), what the cut took out in plain
    words (for example "4 false starts, 2 repeats, 11 stumbles and 3 minutes of pauses"), "no word lost", the chapter
    list, and the `.srt` path. Then the upload, about 3 minutes, by hand in YouTube Studio: Create, Upload videos, pick
    the MP4; the title and description (paste the chapter list in the description; the first line is `0:00`); the
    thumbnail; publish. After it is up: Subtitles, the video, Add language, Upload file, With timing, pick the `.srt`. A
    channel that is not verified uploads up to 15 minutes: they verify at youtube.com/verify with a phone, once. If the
    Content playbook made a listing file for this video, offer to fill the description from it. Last, say how big
    `<work>` is and ask if they want it deleted; delete that folder only on their yes.

## Freedom

"Cut it tighter", "keep my pauses", "no chapters", "drop that part": change the plan and run step 6 again, then step 7.
A longer pause kept inside a line, or the rate as filmed, is a change to step 5 or step 3. "Show me the plan" prints the
spans and the chapters without making the video. The cut never adds music, type or an end card: it is the video, cut.

## When something fails

Read ffmpeg's error and fix the cause: a take with no sound, a full disk, a missing tool, a span outside the take.
Never upload their video anywhere to work around a local problem.
