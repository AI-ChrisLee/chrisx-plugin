# ChrisX for Claude Code and Codex

Get more customers by copying what already works in your industry.

ChrisX is the tool: Website & funnel, CRM & automation, and Content & ads. This plugin and the ChrisX connector let your own Claude or Codex do the work inside it, with ChrisX's tools and credits. Every screen in ChrisX also works by hand.

You need a ChrisX account to use it: start the 14-day free trial at https://chrisx.ai. Everything below works only while your ChrisX plan is active.

This plugin gives you 4 things inside Claude Code and Codex (ChatGPT connects to ChrisX without a plugin: see https://chrisx.ai/docs/claude):

1. **The ChrisX connector.** Your ChrisX workspace (your businesses, websites and contacts, and your 6 playbooks: Offer, Website, Follow-up, Content, Ads and, for agencies, Find clients) right in your AI. You sign in with your ChrisX account the first time it uses it.
2. **Set up my marketing.** Say that sentence and your AI builds your marketing in ChrisX, in order: your workspace, your offer, your website live with its booking page and images, the follow-up emails every new lead gets, your first content (a script made from the winning videos in your industry, and a post), then ads if you want them. Your AI gets the steps from your ChrisX account each time, shows you each part before it goes live and ends on your 1 next step. Where your AI has file tools (Claude Code or Codex) it starts with your workspace: a folder for your business, with your facts and how your AI works for you in its AGENTS.md and CLAUDE.md, and a place for plans, research, content, ads, photos and each Monday's update. Say "Set up my workspace" to make it or bring it up to date on its own; it never changes a file you edited. Ask for ChrisX work in a folder that is not a workspace yet and your AI offers to set it up first.
3. **Make my short.** Film a short or a vertical ad on your phone, hand your AI the file, and get back a finished short. Your AI cuts it on your computer the way a pro editor cuts (1.15x, every pause down to 0.14 s, false starts and repeats out), puts your words on screen as you say them, adds an end card with your video's link, and listens to the cut again to prove no word was lost. Any change: just ask. It checks your ChrisX account first. Your take never leaves your computer; the finished short goes into your ChrisX Media, so a post or an ad can use it. It costs no credits.
4. **Cut my video.** Film one long take (your face, or your screen with your voice), hand your AI the file, and get back a video ready for YouTube. It is cut the same way: 1.15x, every pause down to 0.14 s, false starts and repeats out, and a breath where the topic turns. Your AI then listens to the cut again to prove no word was lost, takes out any restart still in, and gives you a 1080p file (H.264, BT.709, fast start), the captions as an SRT file and the chapter list for your description (taken from the parts of your script when you have one). You upload it in YouTube Studio, about 3 minutes. It runs on your computer, uploads nothing and costs no credits.

## Install

**Claude Code.** Run these 2 lines, 1 at a time:

```
/plugin marketplace add AI-ChrisLee/chrisx-plugin
```

```
/plugin install chrisx@chrisx
```

Restart Claude Code, type /mcp, pick chrisx and sign in with your ChrisX account. Then say "Set up my marketing." Later, say "make my short" or "cut my video" and point Claude at your video.

**Codex** (the terminal, the Codex app or the ChatGPT desktop app, which share one setup). In a terminal, run these 3 lines, 1 at a time:

```
codex plugin marketplace add AI-ChrisLee/chrisx-plugin
```

```
codex plugin add chrisx@chrisx
```

```
codex mcp login chrisx
```

Your browser opens ChrisX: sign in with your ChrisX account and click Allow. Then open Codex in a folder for your business and say "Set up my marketing." Later, say "make my short" or "cut my video" and point Codex at your video. The video skills install ffmpeg and Whisper and download a speech model, and send the finished short to ChrisX, so in Codex's default sandbox it asks you to allow network once.

Codex's plugin hook (the one line that offers to set up a workspace) is optional: Codex asks you to review and trust a plugin's hooks, and everything works without it.

## What make my short and cut my video need

- **ffmpeg**, which cuts the video and puts your words on screen.
- **A local Whisper**, which turns your voice into words with timestamps: `mlx-whisper` on Apple Silicon Macs, `faster-whisper` everywhere else.
- **Python 3.**

You don't install them yourself. The first time you make a short or cut a video, your AI checks what's missing, tells you what it is about to install, and installs it once you say OK (ffmpeg with Homebrew on a Mac, Whisper in its own folder inside the plugin's data directory). The speech model is about 1.5 GB and downloads once.

## Music

Shorts come out without music. Add a sound in Instagram or TikTok when you post, or give your AI any audio file you own and it goes under your voice.

## Links

- ChrisX: https://chrisx.ai
