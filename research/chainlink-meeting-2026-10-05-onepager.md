# Chainlink call: one-pager · Mon Oct 5, 11:30–12:00 ET
Noel Wilamowski (organizer) · Ash Nathan · MNDA signed 10-02 · full brief: [[chainlink-meeting-2026-10-05]]

## The 30 minutes
| Time | What |
|---|---|
| 0–3 | Intros. **Ask first:** "What do you each focus on, and what made you want to talk?" |
| 3–6 | Your 60-second pitch (below) |
| 6–11 | Demo: live sim → crash result → Basescan contract |
| 11–24 | Your questions (priority order below), then listen |
| 24–30 | **Lock next steps:** who does what, by when |

## Your pitch (say it in your own words)
**One line:** "I'm building the automation and trust layer for an independent music label's on-chain economy, and CRE is the part that makes it verifiable."

**60 seconds:**
"I run Witching Hour Music and I'm building hOUR Chain: rights, provenance, and royalty settlement for creators, settling on Base. Our artists have creator coins on Zora, and I run a live treasury bot that accumulates them, takes profit, and trades an ETH/USDC grid to fund itself. It's been live for 8 days with zero unexplained restarts.

The problem: an unattended bot on thin creator-coin pools is exactly what gets drained when a pool crashes or liquidity is pulled. So this week I built a CRE workflow that watches those Uniswap v4 pools on Base every 5 minutes and pauses the bot if price or liquidity breaks. The receiver contract is deployed and verified on Base, and the bot checks it before every buy, in production today. The one missing piece is deploy access, so the workflow itself can write the pause."

**Why CRE and not a cron job (they will ask):**
- My own server deciding to pause my own bot is just a script. A DON reaching consensus on finalized-block data and delivering a **signed report** is verifiable by anyone, and that's the property I need when artists and fans have money in these coins.
- The same pattern carries to royalties next: **attest off-chain royalty data → settle on-chain.**

## Demo (2 min)
1. `cd ~/cre-project/coin-breaker && cre workflow simulate coin-breaker --target local-simulation --non-interactive --trigger-index 0`
   → "Live Base mainnet, finalized blocks, now vs one hour ago."
2. `RESULTS.md` §3: fork crash → "−25% price / −71% liquidity → trips. The bot's whole bag only moves price 4%, so normal selling never trips it."
3. Basescan `0xBFeD…9bdca` (verified) → "Only your forwarder can call it. The bot reads `isPaused` before every buy, live."
4. *(Optional)* A2A agent card + live call. Commands are in the full brief, Step 4. **Fix this machine's DNS before Monday, or this fails.**

## Questions, in priority order
**1. Access (the must-get)**
- "Can you expedite CRE deploy access? What does the review look for?"
- "Private registry vs on-chain registry for a Base-only workflow: which do you recommend?"
- "Pricing and limits: cost per execution, and is a 5-minute cron fine?"

**2. Partnership / funding**
- "What programs fit a solo builder at my stage: grants, BUILD, hackathons, credits?"
- "Would a creator-economy / music case study be interesting to you? I'm happy to write it up."

**3. Technical**
- "Confidential Workflows: can I join the beta? Royalty and streaming data shouldn't be public before settlement."
- "Best pattern to attest off-chain royalty statements on-chain? Is it the bring-your-own-data / PoR shape?"
- "Google Cloud Universal Ledger isn't EVM. Is HTTP plus OAuth the intended path, or is anything native planned?"

**4. Agents (only if there's time, or they bring it up)**
- "I also run a live A2A agent that takes x402 payments on 12 chains and sweeps revenue to a vault. Is Chainlink doing anything on agent-to-agent commerce, and would a CRE workflow that verifies agent data or receipts be interesting?"

**5. Give before you leave**
- "I found two bugs in your NAV starter template, the dead API host and float math, and **I've already fixed both, with tests.** There's also a missing README note on dispute finality. Want a PR? Which repo?"

## Don'ts
- Don't overstate scale. The coins are tiny ($0.15–0.38/day volume). "Pre-alpha, solo, shipping fast" is the honest pitch, and it's a strong one.
- Don't share anything they tell you outside the MNDA (no repos, no posts).
- Don't end without **a named next step plus a date.**

## Close
"What's the single best next step, and who owns it on your side?" Then write it down.
