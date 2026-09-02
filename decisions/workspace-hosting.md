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
2. Getting the credentials out of a git repository.
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
  not migrate it anywhere. Migrating copies the credentials to a second host.

Cloudflare stays worth using for what it is already good at here: the app
front ends. `witching-hour-app` has a `deploy:cloudflare` script.

## Before anything else

The repository contains, committed and readable by anyone with access:

- Eight SSH private keys under `.ssh/`, including `id_rsa_github` and three
  signing keys
- `.git-credentials`
- `.gnupg/`, `.env`, `.env.local`
- `private.pem`, `ca-key.pem`, `server-key.pem`, `cert_key.pem`
- A TON keystore and wallet backup archives
- `SENSITIVE-CREDENTIALS-INVENTORY.md`

Rotate all of it. Deleting the files does not help on its own, because the
history still holds them. Rotation is the fix; archiving the repo afterwards
is cleanup.

## Review Date

Once the credentials are rotated.
