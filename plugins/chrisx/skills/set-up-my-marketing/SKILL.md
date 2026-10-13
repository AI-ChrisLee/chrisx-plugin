---
name: set-up-my-marketing
description: Use this when the member says "Set up my business marketing system", "set up my marketing", "set up my business", or opens ChrisX for the first time and asks what to do. Builds their marketing system inside ChrisX through the ChrisX connector, in order - the website live with its booking page, the follow-up emails, this week's content, then the sales loop (every lead on 1 board, booked, paid) - and ends on the 1 next step.
---

# Set up my business marketing system

The member said the sentence. You build their marketing system in ChrisX, in this order, and you stop at the end of
each part to show it and get their yes. They talk in 1 place (here) and find everything in 1 place (ChrisX). Never
name a tool, a credit price table or an API key to them.

**The state lives in ChrisX, not here.** Start every run with `get_workspace`, then `get_dashboard` with the
business's id: its `setup` (the first steps in order, each done or not) and its next step say what is done and what is
next. Do the next part that isn't done; a member who comes back halfway picks up where they stopped.

## 0. Connected

If the ChrisX tools aren't available or answer that they need sign-in, tell them: "Type /mcp, pick chrisx and sign in
with your ChrisX account." Wait, then start again. When a tool returns `needs_connection`, give them its `connect_url`
and wait.

## 1. The business

No business yet: ask, in 1 message, what they need to tell you and nothing else: the business name, what they do (or
"for clients" if they run an agency), the city, their phone and their current website or listing page if they have
one. Then `add_business`. Read their own site or page yourself for the facts; never invent a price, a review, a
license number or a result.

An agency builds its own site first (it is a business too); its clients come in part 5.

## 2. The website, with booking

1. `list_library` for their trade's start; `create_block_funnel` with it.
2. Their facts into the page: `get_block_funnel`, then `set_page_blocks` (their name, services, area, photos they
   have, the offer, the 1 button: book).
3. The booking page: `save_booking_calendar` (the call or visit they sell, its length, their hours), linked from the
   page's button.
4. Images: `make_image` only when they have no photos; say the cost in credits first.
5. Show the preview link. **Ask before publish.** Then `publish`, and give them the live link.

Done when: the site is live and its button books a time.

## 3. The follow-ups

`create_automation` for a new lead: an instant email that answers and sends the booking link, then the follow-ups
until they book. `test_automation` (it mails only them), show what a lead receives, and `publish_automation` after
their yes.

Done when: a test lead gets the first email within a minute.

## 4. The content

`plan_video`: this week's winning videos in their market and their trade, and scripts in their words, each ending on
the booking. Tell them how this works: they film each script once on their phone, hand you the files, and the
make-my-short skill cuts them into finished shorts on their computer.

Done when: this week's scripts are in ChrisX and they know the 1 next thing (film script 1).

## 5. The sales loop

Every lead lands on 1 board: `list_pipelines` (New, Booked, Paid). Their past customers or contacts, if they have a
list: `add_contacts`, and the first email to them, which they approve. An agency: `find_leads` for its niche, then
`make_pitch` (a new site for each business is the pitch) and the pitch emails they approve.

Done when: the board shows where every lead is, and the Dashboard's next step is about a person who could pay.

## 6. The handover

1 message: the live site, the booking link, the board, this week's scripts, and the 1 next step from `get_dashboard`.
Then the rhythm: "Every Monday, ask me for this week's scripts. Every lead lands on your board. I'll keep you on the
next step that makes money."

## Rules

- 1 part at a time; show it, then go on. Never more than 1 question in a message.
- Ask before anything goes out: publishing, an email to real people, an automation going live.
- Credits: say what it will cost before images, video or a lead list; when a tool says `needs_credits`, tell them how
  many and give the top-up link.
- Their real facts only. Every write tool takes `employee`, the AI employee doing that part: Biz the offer, Mav the
  site and the follow-up emails, Connie the content, Otto the leads and pitches, Chloe the board, the calls and the
  deals, Adam the ads.
