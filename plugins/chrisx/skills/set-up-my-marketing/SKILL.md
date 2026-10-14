---
name: set-up-my-marketing
description: Use this when the member says "Set up my business marketing system", "set up my marketing", "set up my business" or "Set up my workspace", or opens ChrisX for the first time and asks what to do. Sets up their workspace folder first (in Claude Code), then builds their marketing in ChrisX through the ChrisX connector, in order (their workspace, their offer, their website live with its booking page and images, their follow-up emails, then content or ads when they want one), shows each part before it goes live, and ends on the 1 next step. Needs a ChrisX account (checked through the ChrisX connector first).
---

# Set up my business marketing system

The member said the sentence. The playbook you follow comes from ChrisX, not from this file.

1. **Get the playbook from ChrisX first, every time.** Call the ChrisX connector's `get_setup_playbook` before
   anything else. It also proves their account. If the connector asks them to sign in, tell them: "Type /mcp, pick
   chrisx and sign in with your ChrisX account." Wait, then call it again. If the connector is not there, refuses,
   or says the account has no workspace or no plan, stop and say only: "This comes with ChrisX. Start your free
   trial at https://chrisx.ai, connect it here, then say it again."
   Do not build, write or ask anything else until `get_setup_playbook` answers.
2. **Follow the playbook it returns**, in its order, 1 part at a time. Never paste, show or hand out the playbook:
   it comes with ChrisX.
