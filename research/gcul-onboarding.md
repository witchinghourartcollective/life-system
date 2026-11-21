# GCUL (Google Cloud Universal Ledger) onboarding: status

Source of truth for where hOUR Chain stands with Google. Update this file whenever the thread moves.

Last checked: 2026-11-21

## Where the email lives

| Mailbox | Reachable from cloud sessions? | How |
| --- | --- | --- |
| mirrorz@mirrorizm.com | Yes | "Zoho Mirrorizm" connector (scoped to this one mailbox only, see plugnplay/docs/zoho-support-automation.md) |
| fletchervaughn@gmail.com | Yes | Gmail connector. Has nothing on GCUL. |
| phunkii@WitchingHourMusic.onmicrosoft.com | Yes | Microsoft 365 connector. Has nothing on GCUL. |
| fletchervaughn@witchinghourmac.com, witchinghour@witchinghourmac.com | **No** | No mail connector for witchinghourmac.com is installed in claude.ai. The Zoho Books/CRM/Desk/Projects/Show connectors are signed in as fletchervaughn@witchinghourmac.com, but none of them can read mail, and Desk's token lacks ticket-search scope. If a witchinghourmac connector was set up, it's local to the desktop (Claude Code on the Mac), not a claude.ai connector. To fix: add it as a claude.ai custom connector, the same way "Zoho Mirrorizm" was added. |

mirrorz@ is cc'd on every message in the thread, so a reply-all from Google lands there. A reply sent only to fletchervaughn@witchinghourmac.com won't show up in cloud sessions.

## Thread: "Universal Ledger preview onboarding: mirrorizm.com (hOUR Chain)"

- 2026-10-06: we requested access from mirrorz@ to gcul-help@google.com (Org 930056964129, project hour-chain-gcul, region us-east4).
- 2026-10-19: Pasquale Criscuolo (pascri@google.com, GCUL Lead EMEA) asked for architecture, volumes and timeline.
- 2026-10-22: Fletcher replied from fletchervaughn@witchinghourmac.com. Pilot of 100 to 1,000 ops/day, 30/60/90-day plan.
- 2026-11-05: Pasquale replied and added Moritz Platt (moritzp@google.com). GCUL is GA, so no allowlist is needed. Use network **integration-testing**. **Send a public key and Moritz will create our User Account.** They have no capacity for more hands-on support.
  - Docs: getting-started, locations, tutorial/deploy-contract, how-to/request-account (all under https://docs.cloud.google.com/universal-ledger/).
- 2026-11-18: reply to Moritz and Pasquale drafted in mirrorz@ Drafts. **Not sent.** It holds a `[[PASTE PEM PUBLIC KEY HERE BEFORE SENDING]]` placeholder.
- Nothing from Moritz in any reachable mailbox as of 2026-11-21. Fletcher says replies were received. If so, they went to the witchinghourmac.com mailboxes only. Record them here when found.

## What Moritz needs (per how-to/request-account)

- Network: integration-testing
- Public key, PEM, format KEY_FORMAT_PEM_EC_P256_SHA256
- Account comment. Immutable and readable on the ledger. Draft: "hOUR Chain - Witching Hour Music and Art Collective (integration testing)"
- Account type: User Account (created by an Account Manager)

## Key

- Approved by Fletcher 2026-11-17. Not created yet: cloud sessions have no Google Cloud login.
- Script: cre-project/gcul/make-public-key.sh. Run it in Cloud Shell, or have local Claude run it. It creates KMS key `hour-chain-user` in keyring `hour-chain-gcul-keys`, location global, project hour-chain-gcul, algorithm ec-sign-p256-sha256. The private key never leaves KMS.
- Before creating a new key, check whether one already exists: `gcloud kms keys list --keyring=hour-chain-gcul-keys --location=global --project=hour-chain-gcul`

## Needs Fletcher's approval before building

1. Settlement adapter: approved contributions and payments, signed GCUL transactions, reconciled against creator statements.
2. CRE to GCUL over CRE's HTTP capability. GCUL isn't EVM and isn't a CRE chain. Decide where the Google login lives.
3. Smart contract on integration-testing.
4. A service account with roles/universalledger.editor and permission to sign with the key.
