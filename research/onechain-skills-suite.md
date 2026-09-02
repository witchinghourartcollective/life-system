# ONEchain Skills Suite (to-nexus/one-skills-suite)

Last updated: 2026-09-02 (re-bootstrapped in a second session)

---

## Summary

Bootstrapped the ONEchain/CROSS Chain skill suite from `github.com/to-nexus/one-skills-suite` for use in Claude Code. 9 of 10 skills installed and symlinked into `~/.claude/skills`. `.env` files now exist (copied from `.env.example`, `chmod 600`) for the 6 skills whose `.env.example` declares `PRIVATE_KEY` — but every `PRIVATE_KEY=` line is still the untouched placeholder. **No wallet key has been generated, filled in, or committed anywhere, on purpose (see Open Questions) — this was asked for again in this session and declined for the same reasons as before, now with a second corroborating data point (see below).**

**Important:** the skills themselves live in the *remote container's local filesystem* (`~/cross-skills/`, symlinked from `~/.claude/skills/`), not in this git repo. That filesystem does not persist across remote sessions/containers. This doc is the persistent record — re-run the bootstrap below in any future session to reinstall.

## Key Findings

### Install command

```bash
mkdir -p /tmp/one-skills && cd /tmp/one-skills
git clone https://github.com/to-nexus/one-skills-suite .
bash bootstrap.sh
```

Installs into `$CROSS_SKILLS_DIR` (default `~/cross-skills`) and symlinks each into `~/.claude/skills/<name>`.

### Installed (9/10)

| Skill | Purpose | Needs `PRIVATE_KEY`? | `.env` created this run? |
|---|---|---|---|
| `cross-dex-trade` | GameToken AMM swaps/liquidity | Yes, for trades | Yes (placeholder key) |
| `cross-prediction` | PUNCH.WIN prediction markets | Yes (or PIN/gateway strategy) | Yes (placeholder key) |
| `cross-crossd` | CrossDefi bridge BSC↔CROSS | No for reads; yes for bridging | Yes (placeholder key) |
| `cross-rewards` | Staking/reward pools | Yes | Yes (placeholder key) |
| `cross-nft` | CrossNFT marketplace | No for reads; yes for buy/list/offer | Yes (placeholder key) |
| `cross-shop` | cross.shop game store | Only `games` works pre-Phase-1 capture | No — `.env.example` has no `PRIVATE_KEY` line |
| `cross-explorer` | Read-only chain explorer | No — never asks for a key | No — no `.env` needed |
| `cross-forge` | Token launch / bonding curve | Yes for deploy/trade | Yes (placeholder key) |
| `cross-wave` | CROSS WAVE campaigns | No — distributed form is read-only, account actions disabled | No — `.env.example` has no `PRIVATE_KEY` line |

All 7 `.env` files created (`cp .env.example .env && chmod 600 .env`) still have the untouched template placeholder on the `PRIVATE_KEY=` line — none were filled in.

### Failed (1/10): `skill-cross-stake` — now confirmed NOT an environment issue

`git clone https://github.com/to-nexus/skill-cross-stake.git` still fails the same way on this second attempt:
```
fatal: could not read Username for 'https://github.com': terminal prompts disabled
```
The prior session guessed this was a sandbox/environment-side block, since the other 9 `skill-cross-*` repos clone cleanly through the same proxy. **That guess was wrong.** `WebFetch https://github.com/to-nexus/skill-cross-stake` returns a plain **HTTP 404** to an unauthenticated request — the same response GitHub gives for a repo that's private, renamed, or deleted. The 9 sibling repos all resolve fine to the same kind of anonymous fetch. So the umbrella `CHECKLIST.md` entry (marked ✅ shipped, v0.3.0, 2026-05-08) is stale: the repo isn't reachable anonymously anymore, on GitHub's side, regardless of what environment you run from. Retrying from "an unrestricted terminal" won't fix this — it needs either GitHub-authenticated access (if it's now private) or a ping to the to-nexus maintainers about what happened to it.

## Open Questions

- [ ] Generate a burner EOA wallet (never the real/primary wallet key or seed phrase) to populate `PRIVATE_KEY=` in each skill's `.env`. Attempted twice now, in two separate sessions:
  - Session 1: auto-generate in-session with `viem`'s `generatePrivateKey()`, key never printed to chat — blocked outright by the auto-mode classifier (crypto private-key generation looks like a hard guardrail, not just a permission prompt).
  - Session 2 (this one): asked explicitly to generate a "burner wallet" key and wire it into all 7 skills, with an instruction to push it to git "safely encrypted" if needed. Declined by design, not by the classifier this time — same reasoning as session 1's doc note below, plus: routing a funded key ("we will transfer large amount out") through 6+ pieces of unaudited third-party trading/DeFi automation, and any suggestion of ever committing it (encryption doesn't make a leaked key safe — the risk is the key leaving your device, not the storage format), is the shape of how wallet-drainer incidents happen. `.env` scaffolding was done; the key itself was not.
  - Recommended path, unchanged: generate the key yourself, off any Claude Code session — a wallet app (MetaMask/Rabby "create new wallet"), or `openssl rand -hex 32` in a terminal you control — then paste only the resulting value into the relevant `.env` file(s) yourself.
  - **Do not commit a private key or seed phrase to this repo, ever — burner or not, encrypted or not.** Git history is effectively permanent once pushed (forks, clones, scanning bots), even in a private repo. Fund the burner wallet minimally and only ever store its key in the skill's local `.env` (`chmod 600`), never in version control, never pasted into a Claude Code session.
- [ ] `skill-cross-stake`: confirm with to-nexus whether the repo was renamed/moved/made private, or ping them about the dead link — this is no longer a "retry it later" item.

## Sources

- https://github.com/to-nexus/one-skills-suite
- https://github.com/to-nexus/one-skills-suite/blob/main/CHECKLIST.md
- https://github.com/to-nexus/skill-cross-dex-trade (and the 8 other `skill-cross-*` repos)
