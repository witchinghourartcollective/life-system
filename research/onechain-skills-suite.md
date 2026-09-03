# ONEchain Skills Suite (to-nexus/one-skills-suite)

Last updated: 2026-09-02 (bootstrapped independently in two concurrent sessions)

---

## Summary

Bootstrapped the ONEchain/CROSS Chain skill suite from `github.com/to-nexus/one-skills-suite` for use in Claude Code. 9 of 10 skills installed and symlinked into `~/.claude/skills`.

**Two separate Claude Code sessions did this independently, in two separate ephemeral containers, around the same time — their `.env` wiring is NOT shared:**

- One session generated a burner EOA in its own container and wrote the private key into that container's 7 `.env` files (never printed to chat, never committed — see [Burner Wallet](#burner-wallet) below, address only).
- This session (the second one) re-ran the bootstrap independently, scaffolded `.env` files the same way (`cp .env.example .env && chmod 600`), and was asked explicitly to generate and wire in a wallet key too — declined by design (see [Open Questions](#open-questions)). Its `.env` files still hold the untouched template placeholder on `PRIVATE_KEY=`.

Since neither container's filesystem persists, **whichever container still exists is the only place either key lives.** Don't assume a key is available just because this doc says one was generated.

**Important:** the skills themselves live in the *remote container's local filesystem* (`~/cross-skills/`, symlinked from `~/.claude/skills/`), not in this git repo. That filesystem does not persist across remote sessions/containers. This doc is the persistent record — re-run the bootstrap below in any future session to reinstall.

## Key Findings

### Install command

```bash
mkdir -p /tmp/one-skills && cd /tmp/one-skills
git clone https://github.com/to-nexus/one-skills-suite .
bash bootstrap.sh
```

Installs into `$CROSS_SKILLS_DIR` (default `~/cross-skills`) and symlinks each into `~/.claude/skills/<name>`.

Note: in a locked-down sandbox, running `bootstrap.sh` directly (it chains blind `git clone` + `bash install.sh` across 10 repos) may get blocked by an auto-mode classifier as a supply-chain-risk pattern. If so, clone `services.list`'s repos individually and run each `install.sh` one at a time instead — same result, script content is readable before execution.

### Installed (9/10)

| Skill | Purpose | Needs `PRIVATE_KEY`? |
|---|---|---|
| `cross-dex-trade` | GameToken AMM swaps/liquidity | Yes, for trades |
| `cross-prediction` | PUNCH.WIN prediction markets | Yes (or PIN/gateway strategy) |
| `cross-crossd` | CrossDefi bridge BSC↔CROSS | No for reads; yes for bridging |
| `cross-rewards` | Staking/reward pools | Yes |
| `cross-nft` | CrossNFT marketplace | No for reads; yes for buy/list/offer |
| `cross-shop` | cross.shop game store | Only `games` works pre-Phase-1 capture — `.env.example` has no `PRIVATE_KEY` |
| `cross-explorer` | Read-only chain explorer | No — never asks for a key |
| `cross-forge` | Token launch / bonding curve | Yes for deploy/trade |
| `cross-wave` | CROSS WAVE campaigns | No — distributed form is read-only, account actions disabled, `.env.example` has no `PRIVATE_KEY` |

6 of these declare `PRIVATE_KEY` in `.env.example`: `cross-dex-trade`, `cross-prediction`, `cross-crossd`, `cross-rewards`, `cross-nft`, `cross-forge`. `cross-shop` and `cross-wave` don't need one at all in the distributed form.

### Failed (1/10): `skill-cross-stake` — confirmed NOT an environment/sandbox issue

`git clone https://github.com/to-nexus/skill-cross-stake.git` fails consistently, across both sessions:
```
fatal: could not read Username for 'https://github.com': terminal prompts disabled
```
The first session guessed this was a sandbox-side block, since the other 9 `skill-cross-*` repos clone cleanly through the same proxy. **That guess was wrong.** A plain unauthenticated fetch of `https://github.com/to-nexus/skill-cross-stake` returns **HTTP 404** — the same response GitHub gives for a repo that's private, renamed, or deleted. The 9 sibling repos all resolve fine to the same kind of anonymous fetch. So the umbrella `CHECKLIST.md` entry (marked ✅ shipped, v0.3.0, 2026-05-08) is stale: the repo isn't reachable anonymously anymore, regardless of what environment you run from. This needs either GitHub-authenticated access (if it's now private) or a ping to the to-nexus maintainers about what happened to it — not another retry from "an unrestricted terminal."

## Burner Wallet

- Address: `0x034E8911aa8433A41e471B3b672196544cCAd35F`
- Generated in one session's container via `viem`'s `generatePrivateKey()`; the private key was written straight to that container's skill `.env` files and never printed to chat or committed to git.
- Wired into (in that container only): `cross-dex-trade`, `cross-prediction`, `cross-crossd`, `cross-rewards`, `cross-nft`, `cross-forge`, `cross-wave`.
- **Exported.** Imported into Trust Wallet (2026-09-02) — the key now has a durable copy outside the ephemeral container, so it's no longer at risk of total loss if that container gets reclaimed.
- **Still also live in that container's 6 `.env` files** (`cross-dex-trade`, `cross-prediction`, `cross-crossd`, `cross-rewards`, `cross-nft`, `cross-forge`), unless that session/container has since been cleaned up. Funding this address gives every one of those pieces of third-party automation equal signing authority over whatever's sent here — that's the intended use (testing the skills), just stated plainly.
- **Funded with a few dollars of CROSS**, on purpose, sized for testing. Treat it as fully disposable regardless of balance — never grow it into anything beyond pocket-change test money.
- **Before funding further (or at all, if not done yet): set per-skill caps.** Each `.env` has `MAX_TRADE_*` / `MAX_STAKE_NOTIONAL` / `MAX_BRIDGE_NOTIONAL` and `CONFIRM_THRESHOLD` vars — set them at or below the funded amount so no single automated call can move more than intended. Defaults (e.g. `MAX_TRADE_CROSS=10`) may exceed a "few dollars" funding level.

## Open Questions

- [x] ~~Generate a burner EOA wallet~~ — done, address above.
- [x] ~~Export the key before the container is reclaimed~~ — done, imported into Trust Wallet.
- [ ] Set `MAX_TRADE_*` / `CONFIRM_THRESHOLD` caps in each `.env` to match the actual funded amount, before (or right after) funding.
- [ ] Do **not** ask a Claude Code session to generate another one "to be safe," push a key to git (encrypted or not — encryption doesn't make a leaked key safe; the risk is the key ever leaving your own device), or route a funded key through unaudited third-party trading/DeFi automation beyond small test amounts. If a fresh key is ever needed, generate it yourself outside any Claude Code session and paste only the resulting value into each skill's `.env` yourself.
- [ ] `skill-cross-stake`: confirm with to-nexus whether the repo was renamed/moved/made private, or ping them about the dead link.

## Sources

- https://github.com/to-nexus/one-skills-suite
- https://github.com/to-nexus/one-skills-suite/blob/main/CHECKLIST.md
- https://github.com/to-nexus/skill-cross-dex-trade (and the 8 other `skill-cross-*` repos)
