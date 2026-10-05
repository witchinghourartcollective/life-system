# Where the workspace should live

---
**Status:** Open
**Opened:** 2026-09-02
**Closed:**
**Decision:** Recommended below, not yet confirmed
---

## Context

`fletchervaughn-workspace` is a git repository of a home directory, over
100 GB, containing 300+ top-level entries: dotfiles, caches, downloads,
tarball backups, vendored mining binaries, and multi-megabyte JSON dumps.
Cloning it is impractical, and on a hotspot it is impossible.

The question raised was whether DigitalOcean, Cloudflare, or GitLab is a
better home for it.

None of them is, because the size is not a hosting problem. It is a home
directory under version control. Any host would be asked to store the same
100 GB, and the same credentials would travel with it. See
[[WORKSPACE]] for the map of what actually needs to be versioned.

## Options

| Option | Upside | Downside | Gut Feel |
|--------|--------|----------|----------|
| Move the repo to GitLab | Nothing to rewrite | GitLab caps repositories at 10 GB on its paid tiers, so it does not fit. Copies eight SSH private keys to a new host. | No |
| Move it to a DigitalOcean droplet | Full control, cheap block storage | A droplet is not source control. Still 100 GB, still credential-bearing. | No |
| Move it to Cloudflare | R2 has no egress fees | R2 is object storage, not a git host. Right answer for the wrong half of the problem. | Partly |
| Stop versioning the home directory; split by data type | Working set drops to ~344 MB. Nothing to migrate. | Requires deciding where the large blobs go. | Yes |

## What I'm Optimizing For

1. Not moving 100 GB over a metered connection.
2. Keeping the git-crypt key off any host that holds the repository.
3. Not rewriting anything that already works.

## Decision

Split by what the data is, rather than picking one host for all of it.

- **Code → GitHub, as the thirteen separate repositories.** This already
  works and needs no migration. The full set is ~344 MB against 100 GB+.
  A cloud session clones them from GitHub over its own network, so a metered
  connection carries only the conversation.
- **Large blobs → object storage, never git.** Backups, product JSON dumps,
  media, screenshots, vendored binaries. Cloudflare R2 or DigitalOcean Spaces
  both work; R2's lack of egress fees is the tiebreaker when pulling them back
  down matters.
- **Secrets → a secret manager, never git.** Bitwarden is already in use.
- **Lightning nodes → a droplet**, which is what the phunkii node already is
  in substance. `lnd-ops-subrepo` now installs onto any host by role, so a
  second node is a checkout and one install command rather than a home
  directory copy.
- **`fletchervaughn-workspace` → stop pushing to it, then archive it.** Do
  not migrate it anywhere. The objection is the 100 GB and the risk of the
  git-crypt key following the repo to a new host, not the ciphertext itself.

Cloudflare stays worth using for what it is already good at here: the app
front ends. `witching-hour-app` has a `deploy:cloudflare` script.

## Correction: the credentials are encrypted

An earlier version of this document said the workspace repo carried eight SSH
private keys, `.git-credentials`, `.gnupg`, env files, PEM keys, a TON keystore
and wallet backups in the clear, and that all of it needed rotating. That was
wrong, and the error was mine: I read a directory listing and treated the
filenames as exposed secrets without checking the contents.

They are git-crypt encrypted. `.gitattributes` routes `.ssh/**`, `.gnupg/**`,
`.git-credentials`, `.env`, `.env.local`, `**/*.pem`, `.lnd/**`, the keystore,
the wallet backup archives and the credentials inventory through the filter,
with filename backstops for `**/wallet.db`, `**/channel.backup`,
`**/*.macaroon`, `**/*seed*.txt` and `**/*xprv*`. Fetching `.lnd/lnd.conf`
returns a GITCRYPT header, confirming the filter runs rather than just being
declared. No rotation is required on account of this repository.

Two limits are still worth knowing, as facts rather than actions:

- git-crypt encrypts contents, not paths or sizes. The tree still shows what
  exists and roughly how big it is.
- The protection holds only while the git-crypt key stays out of the repo and
  off shared machines. This is the real argument against mirroring the repo to
  another host: not the ciphertext, but the chance of the key following it.

`.gitattributes` also notes that `Documents/wallet*stuff/**` "was committed
unencrypted — see incident note" before being added to the filter. That is a
known, separately handled incident, not an open finding from this document.

## Review Date

When the large blobs are actually moved out of the workspace repo, or when
the repo is archived, whichever comes first.
