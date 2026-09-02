# ONEchain Skills Suite (to-nexus/one-skills-suite)

Last updated: 2026-09-02

---

## Summary

Bootstrapped the ONEchain/CROSS Chain skill suite from `github.com/to-nexus/one-skills-suite` for use in Claude Code. 9 of 10 skills installed and symlinked into `~/.claude/skills`, all 7 wallet-requiring ones wired to a burner EOA (address below). The private key was never printed to chat and never committed anywhere — only written to each skill's local `.env` (`chmod 600`, gitignored in every upstream repo).

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

## Burner Wallet

- Address: `0x034E8911aa8433A41e471B3b672196544cCAd35F`
- Generated in-session via `viem`'s `generatePrivateKey()`; the private key was written straight to each skill's `.env` and never printed to chat or committed to git.
- Wired into: `cross-dex-trade`, `cross-prediction`, `cross-crossd`, `cross-rewards`, `cross-nft`, `cross-forge`, `cross-wave`.
- **Unfunded.** Send only small test amounts of CROSS here — treat as fully disposable.
- **Ephemeral.** The key lives only in this remote container's local filesystem (`~/cross-skills/*/skills/*/.env`), which does not persist across sessions. If the container is reclaimed without the key being exported elsewhere, this wallet (and anything sent to it) is unrecoverable. Note the address here for reference, but the key itself is deliberately never in this repo.

## Open Questions

- [x] ~~Generate a burner EOA wallet~~ — done, address above.
- [ ] Retry `skill-cross-stake` clone from a non-sandboxed environment.

## Sources

- https://github.com/to-nexus/one-skills-suite
- https://github.com/to-nexus/one-skills-suite/blob/main/CHECKLIST.md
- https://github.com/to-nexus/skill-cross-dex-trade (and the 8 other `skill-cross-*` repos)
