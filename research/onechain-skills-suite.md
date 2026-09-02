# ONEchain Skills Suite

Last updated: 2026-09-02

## Status

The `to-nexus/one-skills-suite` bootstrap installs nine of ten CROSS Chain skills into `$CROSS_SKILLS_DIR` (default `~/cross-skills`) and symlinks them under `~/.claude/skills`. These installation directories are session-local in remote coding environments; this repository records the reproducible setup but does not contain the installed third-party skills.

## Bootstrap

Review the umbrella repository and each installer before running third-party scripts:

```bash
git clone https://github.com/to-nexus/one-skills-suite /tmp/one-skills
cd /tmp/one-skills
bash bootstrap.sh
```

If a locked-down environment blocks the umbrella script, inspect `services.list`, clone the repositories individually, and review each `install.sh` before running it.

## Installed skills (9/10)

| Skill | Purpose | Signing requirement |
|---|---|---|
| `cross-dex-trade` | GameToken AMM swaps and liquidity | Required for writes |
| `cross-prediction` | PUNCH.WIN prediction markets | Required for writes, unless its gateway/PIN route is used |
| `cross-crossd` | CrossDefi bridge between BSC and CROSS | Reads work without signing; bridging requires it |
| `cross-rewards` | Staking and reward pools | Required for writes |
| `cross-nft` | CrossNFT marketplace | Reads work without signing; buying/listing/offers require it |
| `cross-shop` | cross.shop game store | Distributed version has limited pre-capture functionality and no `PRIVATE_KEY` setting |
| `cross-explorer` | Chain explorer | Read-only |
| `cross-forge` | Token launch and bonding curve | Required for deploy/trade |
| `cross-wave` | CROSS WAVE campaigns | Distributed version is read-only and has no `PRIVATE_KEY` setting |

Exactly six installed skills declare `PRIVATE_KEY` in their current `.env.example`: `cross-dex-trade`, `cross-prediction`, `cross-crossd`, `cross-rewards`, `cross-nft`, and `cross-forge`. `cross-wave` was incorrectly included in an earlier seven-skill count; it does not consume a private key in the distributed version.

## Failed skill (1/10): `skill-cross-stake`

```text
git clone https://github.com/to-nexus/skill-cross-stake.git
fatal: could not read Username for 'https://github.com': terminal prompts disabled
```

Anonymous access also returns HTTP 404 while the nine sibling repositories resolve. This points to the repository being private, renamed, or removed—not to a retryable sandbox failure. The umbrella checklist entry claiming it shipped is stale relative to current public access.

Next action: ask the to-nexus maintainers for the current repository URL or access instructions. Do not repeatedly retry the clone or place GitHub credentials in shell commands, documentation, or logs.

## Wallet status

A disposable EOA was previously generated in one ephemeral session:

- Address: `0x034E8911aa8433A41e471B3b672196544cCAd35F`
- Its private key was reportedly placed only in the six key-consuming skills in that container.
- The key was never committed and may be lost when that container is reclaimed.
- The wallet was reported as unfunded.

Do not treat that address as durable or production-ready. Do not fund it unless the key is recovered locally and the address is verified from that recovered key.

The target design is now a phone-controlled smart account plus a separate managed automation signer. Trust Wallet is preferred for human ownership, with MetaMask Mobile as the fallback. The existing skills require a signer adapter before they can use this design; replacing `PRIVATE_KEY` with a managed provider is not merely an environment-variable change.

See [ONEchain Wallet and Skill Wiring](./onechain-wiring.md) for the architecture and implementation checklist.

## Remaining work

- [ ] Confirm `skill-cross-stake` location or access with to-nexus.
- [ ] Verify official CROSS network and WalletConnect parameters.
- [ ] Select a CROSS-compatible smart-account and managed-signer stack.
- [ ] Make Trust Wallet the human owner and configure a separate restricted automation signer.
- [ ] Pilot the signer adapter in one transaction skill using negligible funds.
- [ ] Migrate the other five transaction skills and disable production raw-key paths.
- [ ] Validate that read-only skills operate without signer credentials.
- [ ] Add CI secret scanning and tests that reject committed `.env` files.

## Sources

- https://github.com/to-nexus/one-skills-suite
- https://github.com/to-nexus/one-skills-suite/blob/main/CHECKLIST.md
