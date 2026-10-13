# ChrisX for Claude Code

Get more customers by copying what already works in your industry. ChrisX turns Claude into your marketing team.

You need a ChrisX account to use it: start the 14-day free trial at https://chrisx.ai. Everything below works only while your ChrisX plan is active.

This plugin gives you 3 things inside Claude Code:

1. **The ChrisX connector.** Your ChrisX workspace (your businesses, websites, contacts, outreach and your 6 AI employees) right in Claude. You sign in with your ChrisX account the first time Claude uses it.
2. **Set up my business marketing system.** Say that sentence and Claude builds your marketing in ChrisX, in order: your website live with its booking page and images, the follow-up emails every new lead gets, your contacts, and a video plan when you want videos. Claude gets the steps from your ChrisX account each time, shows you each part before it goes live and ends on your 1 next step. In Claude Code it starts with your workspace: a folder for your business, with your facts and how Claude works for you in its CLAUDE.md, and a place for plans, research, content, ads, photos and each Monday's update. Say "Set up my workspace" to make it or bring it up to date on its own; it never changes a file you edited. Ask for ChrisX work in a folder that is not a workspace yet and Claude offers to set it up first.
3. **Make my short.** Film a short or a vertical ad on your phone, hand Claude the file, and get back a finished short. It is cut the way a pro editor cuts (1.15x, every pause down to 0.14 s, false starts and repeats out), then built on the kinetic page: your words landing as you speak, your site and photos floating in cards, lists, numbers counting up, bars, steps, your face for the hook and the ask, and an end card with your booking link. Any scene can change: just ask. Claude checks your ChrisX account first and downloads the short maker from ChrisX after you sign in. After that it all runs on your computer. Nothing is uploaded and it costs no credits.

## Install

In Claude Code:

```
/plugin marketplace add AI-ChrisLee/chrisx-plugin
/plugin install chrisx@chrisx
```

Then say "Set up my business marketing system." Later, say "make my short" and point Claude at your video.

## What make my short needs

- **ffmpeg**, which cuts the video.
- **A local Whisper**, which turns your voice into words with timestamps: `mlx-whisper` on Apple Silicon Macs, `faster-whisper` everywhere else.
- **Node 18+ and the renderer** (Remotion and its own headless browser, about 400 MB), which draws the page.
- **Python 3.**

The short maker itself (the cut and the kinetic page renderer) is not in this repo. It downloads from ChrisX after you sign in: the first time you make a short, into the plugin's data directory, and again only when there is a newer version.

You don't install the tools above yourself. The first time you make a short, Claude checks what's missing, tells you what it is about to install, and installs it once you say OK (ffmpeg and Node with Homebrew on a Mac, Whisper and the renderer in their own folders inside the plugin's data directory). The speech model is about 1.5 GB and downloads once. No Node? Ask for captions only: the short is made on your footage with clean captions, no renderer needed.

The renderer runs on Remotion, which is free for individuals and companies with up to 3 employees. A bigger company needs its own Remotion license: https://www.remotion.dev/license

The fonts (Inter, Instrument Serif) come with the short maker download under the SIL Open Font License. The license text is in the download's `fonts/OFL.txt`.

## Music

The tracks will come with the short maker download. None yet; 5 original tracks are on the way (upbeat and bright as the default, chill lo-fi, inspiring piano / cinematic, confident corporate pop, trendy house). Until then, shorts come out without music and you add a sound in Instagram or TikTok when you post, or you pass any audio file you own with `--music path/to/song.mp3`.

## Links

- ChrisX: https://chrisx.ai
