# Workspace

The working set is thirteen repositories, cloned side by side. This file
replaces the guidance that used to live in the root `CLAUDE.md` and
`AGENTS.md` of the `fletchervaughn-workspace` repo.

```
workspace/bootstrap.sh                    # clone everything into ~/work
workspace/bootstrap.sh --cluster lightning
workspace/repos.tsv                       # the manifest, one row per repo
```

## Why the workspace repo is not used

`witchinghourartcollective/fletchervaughn-workspace` is a git repository of a
home directory. It carries 300+ top-level entries: dotfiles, caches, package
manager state, downloads, screenshots, tarball backups, vendored mining
binaries, and multi-megabyte JSON dumps. It is over 100 GB.

None of that is needed to work on the code. The thirteen repositories below
total roughly 344 MB, and the linking layer that the workspace root actually
provided is this file. The size problem was never a hosting problem; it was a
home directory under version control.

Two consequences worth keeping in mind:

- **Do not clone it.** Not into a cloud session, not onto a metered
  connection. Read individual files through the GitHub API when something in
  it is genuinely needed.
- **Its sensitive files are git-crypt encrypted.** `.gitattributes` puts
  `.ssh/**`, `.gnupg/**`, `.git-credentials`, `.env`, `.env.local`,
  `**/*.pem`, `.lnd/**`, the TON keystore, the wallet backup archives and
  `SENSITIVE-CREDENTIALS-INVENTORY.md` through the git-crypt filter, plus
  filename backstops for `**/wallet.db`, `**/channel.backup`, `**/*.macaroon`,
  `**/*seed*.txt`, `**/*xprv*` and similar. Spot-checking `.lnd/lnd.conf`
  through the API returns a GITCRYPT header rather than plaintext, so the
  filter is active and not merely configured.

  Two things this does not do, worth remembering rather than acting on:
  git-crypt encrypts file contents, not paths or sizes, so the tree itself
  still describes what exists and where; and the protection lasts exactly as
  long as the git-crypt key stays out of the repo and off shared hosts.
  Mirroring the repo somewhere the key also ends up removes the protection.

## Repository map

### Lightning
The active cluster.

| Repo | What it is |
|---|---|
| `lnd-ops-subrepo` | Ops scripts and systemd units for both LND nodes. Start here. `scripts/test.sh` runs with no node attached. |
| `access-tool` | Docker-compose service, backend and frontend |
| `lnc-web` | Lightning Node Connect for the browser |
| `phoenix` | Phoenix wallet, Android and iOS |
| `lightning-kmp` | Kotlin Multiplatform Lightning implementation |

Two nodes: the workstation (`local` role) and phunkii (`remote` role). Both
run the same scripts from `lnd-ops-subrepo/bin`, selected by `LND_ROLE`.

### Wallet and finance

| Repo | What it is |
|---|---|
| `agentic-wallet-policy` | Rules-based wallet policy plus a dependency-free validator |
| `finance` | Beancount ledger. Validate with `bean-check main.bean`, not a test runner. Default branch is `finish-wallet-recovery`. |

### Apps

| Repo | What it is |
|---|---|
| `witching-hour-app` | Next.js app with onchain hooks |
| `Witching-hOUR-Live-App` | Live desktop experience. The largest repo at 198 MB. |
| `mirrorz` | Empty, initial commit only |

### Support

| Repo | What it is |
|---|---|
| `life-system` | Personal system, journal, and this manifest |
| `ecosystem` | Python package with docs and tests |
| `phigit-os-v2-handoff` | Handoff notes. Default branch is `agent/phigit-os-v2-handoff`. |

## Cross-project conventions

Carried over from the workspace root. A repo's own `CLAUDE.md` wins over
these.

- **Work at the repo level.** Each repo has its own toolchain. There is no
  build, test, or lint command spanning the set.
- **Commits:** short, imperative, scoped to the area, e.g.
  `Fix txGuard false-positive blocking valid swaps`.
- **Secrets:** never commit secrets, wallet material, or generated key files.
  They belong in a local env file the repo ignores.
- **Node and TypeScript:** read the repo's `package.json` scripts first.
- **Python:** use the repo's own venv. `finance` is a ledger, not a test suite.
- **Kotlin:** `phoenix` and `lightning-kmp` build with Gradle via `./gradlew`.
- **Authorized tasks:** once a task is explicitly authorized, continue through
  safe in-scope diagnostics, repairs, retries and validation without asking
  again for each step. This does not bypass runtime tool approval dialogs.

## Wallet and transaction safety

This rule outranks convenience and carries into every repo here.

- **Only execute a transaction, channel open or close, on-chain send, or any
  other fund-moving action when told to do that specific action.** A prior
  general go-ahead does not carry to a new amount, peer, destination, or
  session. Get a fresh explicit instruction each time.
- **Never change a number** — an amount, fee rate, peer, destination, or
  channel size — from what was specified, even where a different value looks
  more correct or safer. Stop and ask.
- Applies to every wallet and node in the set: LND, the agentic wallet
  policy, and any script that opens or closes channels, sends funds, or
  creates a credential with write or spend scope.
- Read-only diagnostics are exempt. `getinfo`, `walletbalance`,
  `listchannels`, `pendingchannels` and similar are always fine.
- Prefer dry-run, read-only, or testnet variants when validating.

## Cloud sessions

A cloud session clones from GitHub over its own network. Nothing is uploaded
from a local machine, so a metered connection carries only the conversation.

Attach the repos individually. Adding one mid-session works too, so the
starting set does not have to be complete.
