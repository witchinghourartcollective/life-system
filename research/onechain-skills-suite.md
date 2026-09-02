# ONEchain Skills Suite (to-nexus/one-skills-suite)

Last updated: 2026-09-02

---

## Summary

Bootstrapped the ONEchain/CROSS Chain skill suite from `github.com/to-nexus/one-skills-suite` for use in Claude Code. 9 of 10 skills installed and symlinked into `~/.claude/skills`. None are wired up with a wallet yet — no `PRIVATE_KEY` has been generated or committed anywhere, on purpose (see Open Questions).

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

| Skill | Purpose | Needs `PRIVATE_KEY`? |
|---|---|---|
| `cross-dex-trade` | GameToken AMM swaps/liquidity | Yes, for trades |
| `cross-prediction` | PUNCH.WIN prediction markets | Yes (or PIN/gateway strategy) |
| `cross-crossd` | CrossDefi bridge BSC↔CROSS | No for reads; yes for bridging |
| `cross-rewards` | Staking/reward pools | Yes |
| `cross-nft` | CrossNFT marketplace | No for reads; yes for buy/list/offer |
| `cross-shop` | cross.shop game store | Only `games` works pre-Phase-1 capture |
| `cross-explorer` | Read-only chain explorer | No — never asks for a key |
| `cross-forge` | Token launch / bonding curve | Yes for deploy/trade |
| `cross-wave` | CROSS WAVE campaigns | Read-only in distributed form |

### Failed (1/10): `skill-cross-stake`

`git clone https://github.com/to-nexus/skill-cross-stake.git` fails consistently in this sandboxed environment:
```
fatal: could not read Username for 'https://github.com': terminal prompts disabled
```
Retried 3x with backoff — same failure every time, unlike the other 9 repos which cloned cleanly. Explicitly attaching `to-nexus/skill-cross-stake` via the environment's repo-access tool was also denied by the session's permission classifier. The umbrella repo's `CHECKLIST.md` marks it public and shipped (v0.3.0, 2026-05-08), so this looks like an environment-side block rather than the repo being genuinely private — worth retrying from an unrestricted terminal, or from a fresh session.

## Open Questions

- [ ] Generate a burner EOA wallet (never the real/primary wallet key or seed phrase) to populate `PRIVATE_KEY=` in each skill's `.env`. Attempted to auto-generate one in-session with `viem`'s `generatePrivateKey()`, written straight to file with the key never printed to chat — blocked outright by the session's auto-mode classifier (crypto private-key generation appears to be a hard guardrail, not just a permission prompt).
  - Recommended path: generate the key yourself, off this session — a wallet app (MetaMask/Rabby "create new wallet"), or `openssl rand -hex 32` in a terminal you control.
  - **Do not commit a private key or seed phrase to this repo, ever — burner or not.** Git history is effectively permanent once pushed (forks, clones, scanning bots), even in a private repo. Fund the burner wallet minimally and only ever store its key in the skill's local `.env` (`chmod 600`), never in version control.
- [ ] Retry `skill-cross-stake` clone from a non-sandboxed environment.

## Sources

- https://github.com/to-nexus/one-skills-suite
- https://github.com/to-nexus/one-skills-suite/blob/main/CHECKLIST.md
- https://github.com/to-nexus/skill-cross-dex-trade (and the 8 other `skill-cross-*` repos)
