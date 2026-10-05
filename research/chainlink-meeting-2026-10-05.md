# Chainlink meeting brief: Mon 2026-10-05, 11:30–12:00 ET

Last updated: 2026-10-04 (one-pager: [[chainlink-meeting-2026-10-05-onepager]])

With [[noel-wilamowski]] (organizer) and [[ash-nathan]], both at smartcontract.com. MNDA signed 10-02
(Witching Hour Music ↔ SmartContract Inc, to 2028-10-02). Anything they share stays out of public repos/PRs.

---

## Summary

**Three asks, in this order:**
1. **CRE deploy access.** The request is pending (org `org_TsTEYPSQJD4JYeXe`, "Deploy Access: Not enabled").
   You have a workflow ready to ship today.
2. **Partnership / funding.** What programs fit a solo music-tech builder (grants, BUILD, credits, co-marketing)?
3. **Technical help.** Confidential Workflows beta, plus connecting CRE to non-EVM ledgers (GCUL).

**Lead with what's built, not the vision.** hOUR Chain is pre-alpha, and the coin volumes are tiny.
What's real and impressive is a working, tested CRE workflow on your own assets, done in 2 days.

**Second proof point (new 10-04): a live, spec-compliant agent that gets paid.** The Witching Hour
A2A agent (A2A v0.3.0) is public at `agent.witchinghourmac.com`. It sells a $0.01 skill over x402 on 12
mainnet chains via Circle Gateway, and a daily job sweeps revenue into a yield vault. It's the
"agents paying agents" story, and it's where CRE fits next: verifiable data for those agents.
Mention it after the circuit-breaker demo. Don't lead with it.

## Your 60-second intro

"I run Witching Hour Music, an independent label, and I'm building hOUR Chain: rights, provenance,
and royalty settlement for creators, settling on Base. Our artists have creator coins on Zora, and
I run an automated treasury bot that accumulates them. This week I built a CRE workflow that watches
those pools on Base and pauses the bot if a pool crashes or liquidity gets pulled. The contract is
live on Base, it's fork-tested, and the bot checks it before every buy in production. I'm waiting on deploy access so the workflow can write the pause."

## Demo (2 minutes, see the script below)

1. Live simulation against Base mainnet (~30s)
2. Fork crash test results (`RESULTS.md`): it trips at −25% price / −71% liquidity
3. The contract on Basescan (verify it first)

## What to ask

**Access**
- Can you expedite deploy access? What's the review criterion?
- `private` (Chainlink-hosted) registry vs `onchain:ethereum-mainnet`: which is right for a Base-only workflow?
- Pricing/limits once deployed: cost per execution, cron frequency limits.

**Partnership / funding**
- What programs exist for early builders (grants, BUILD, hackathon tracks)? What does a strong application look like?
- Is there interest in a music/creator-economy case study? (royalty settlement, creator-coin safety)

**Technical**
- Confidential Workflows (private beta): can we join? Use case: royalty/streaming revenue data that
  shouldn't be public before settlement.
- Non-EVM: we're onboarding to Google Cloud Universal Ledger (not a CRE chain). Is the HTTP capability
  plus Google OAuth the right path, or is native support planned?
- Data source pattern for streaming royalties ("bring your own data", like PoR/NAV): how should we attest
  offchain royalty statements onchain?

**Agents**
- Is Chainlink working on agent-to-agent commerce (A2A, x402)? We have a live A2A agent taking x402
  payments. Would a CRE workflow that attests an agent's data or verifies its payment receipts be interesting?

**Give them value (template feedback): both NAV bugs are now fixed, with tests**
- Host: `api.m0.xyz` is dead. Our copy points at `https://mnav.m0.xyz/api/rpc` (what their own M0 adapter uses).
- Float math: the template did `JSON.parse` → float subtraction → `parseUnits(nav.toString(), 18)`, which
  gives `3208070.0437240005`-style answers and throws if JS prints exponent form. Fixed in
  `~/cre-project/reserves/nav/workflow.ts`: it reads the exact decimal digits from the response, scales
  them to 18-decimal BigInts, subtracts as integers, and runs consensus `median` on the BigInt. It fails
  closed on missing fields or exponent notation. 5 new tests, 11/11 pass (`bun test`).
  On 10-04 live data the exact NAV is **3212989.346253**; the float version is off in the last digits.
- Dispute workflow finality behavior needs a README note.
- Offer: "I have the NAV fix with tests. Want a PR, and which repo?"

## Watch for

- Don't promise volumes or users you don't have. "Pre-alpha, solo, shipping fast" is a fine position.
- If they offer a follow-up, get a named next step and a date before hanging up.
- Note who owns what: Noel organized, so Noel is likely the relationship owner.

## Open questions

- [ ] Noel's and Ash's roles (BD? DevRel? Solutions?). Ask at the start: "What do you each focus on?"
- [ ] Was the meeting from the `cre account access` request, or something else?

---

## Demo script

**Setup before the call:** terminal open, font enlarged, `cd ~/cre-project/coin-breaker`.
Have the Basescan contract tab and `RESULTS.md` open.

**Step 1: live read on Base (~30s).** Say: "This is the workflow running in the CRE simulator against Base mainnet right now."
```bash
cd ~/cre-project/coin-breaker
cre workflow simulate coin-breaker --target local-simulation --non-interactive --trigger-index 0
```
Point at: `Comparing finalized block … vs … (1800 blocks back)` and the per-coin `price … bps, liquidity … bps -> OK`.
Say: "Finalized blocks, so every DON node reads identical state. It compares now to an hour ago."

**Step 2: it trips on a real crash.** Show `RESULTS.md` section 3. Say: "On an Anvil fork of Base, selling
the bot's entire bag only moved price 4%, so it stays quiet. A real crash, 2.4M coins in an hour, trips it
on liquidity drop."

**Step 3: it's real onchain.** Show the Basescan tab for `0xBFeDCca4dE6cF908C1cf375D430DaDDc15C9bdca`.
Say: "The receiver is deployed and verified. It only accepts reports from your Base forwarder. The bot reads
`isPaused` before every buy, live in production since 10-03. The workflow writing the pause is what needs deploy access."

**Fallback if the live sim fails (RPC hiccup):** show `RESULTS.md` section 1 and move on.

**Step 4 (optional, 30s, only if they ask about agents): the A2A agent.**
```bash
curl -s https://agent.witchinghourmac.com/.well-known/agent-card.json | jq '{name, protocolVersion, preferredTransport, skills: [.skills[].id]}'
curl -s https://agent.witchinghourmac.com/a2a/jsonrpc -H 'content-type: application/json' \
  -d '{"jsonrpc":"2.0","id":1,"method":"message/send","params":{"message":{"kind":"message","messageId":"demo","role":"user","parts":[{"kind":"text","text":"is the bull run over?"}]}}}' | jq '.result.artifacts[0].parts[0].data'
```
Say: "Any agent can discover it from the card and call it. The paid skill quotes $0.01 on 12 chains, and the revenue sweeps to a vault daily."
Be honest if asked: revenue is ~$0 so far. Buyers need a funded Circle Gateway deposit, and few agents have one yet.

**Before the call (Sunday):** fix this machine's DNS first. WARP currently can't resolve
`*.witchinghourmac.com`, so Step 4 and anything else on your own domains will fail. Re-run the Step 1 sim
after the fix too: on 10-04 the simulator's HTTP calls were timing out through WARP.

---

## Commands reference

**Verify the contract on Basescan (do before Monday)**
- Basescan → contract → Contract tab → *Verify and Publish*
- Compiler type: Solidity (Standard-Json-Input) · Version: v0.8.20+commit.a1b79de6 · License: MIT
- Upload `~/cre-project/coin-breaker/contracts/CoinCircuitBreaker.standard-input.json`
- Constructor args (if asked): `000000000000000000000000f8344cfd5c43616a4366c34e3eee75af79a74482`

Or with a Basescan/Etherscan API key:
```bash
cd ~/cre-project/coin-breaker/contracts && forge verify-contract 0xBFeDCca4dE6cF908C1cf375D430DaDDc15C9bdca \
  src/CoinCircuitBreaker.sol:CoinCircuitBreaker --chain base \
  --constructor-args 000000000000000000000000f8344cfd5c43616a4366c34e3eee75af79a74482 \
  --etherscan-api-key <your key> --watch
```

**Read-only checks**
```bash
R=https://base.drpc.org; B=0xBFeDCca4dE6cF908C1cf375D430DaDDc15C9bdca
cast call $B 'owner()(address)' --rpc-url $R                # 0x0f8aA33C…4817
cast call $B 'getForwarderAddress()(address)' --rpc-url $R  # 0xF8344CFd…4482
cast call $B 'isPaused(address)(bool)' 0xf2813da8320ae7d5516bb325c6a69151d7a1baa1 --rpc-url $R
```

**Account status**
```bash
cre whoami          # look for "Deploy Access"
cre registry list
```

**After deploy access is approved (owner runs these)**
```bash
cre account link-key --target production-settings   # needs CRE_ETH_PRIVATE_KEY in your env
cast send 0xBFeDCca4dE6cF908C1cf375D430DaDDc15C9bdca 'setExpectedAuthor(address)' <linked owner address> \
  --rpc-url https://base.drpc.org --interactive      # from 0x0f8a…4817
cd ~/cre-project/coin-breaker && cre workflow deploy coin-breaker --target production-settings
```

## Sources

- `~/cre-project/coin-breaker/RESULTS.md`
- whm-flywheel PR #1, whm-infra PR #1 (github.com/witchinghourartcollective)
- CRE forwarder directory: https://docs.chain.link/cre/guides/workflow/using-evm-client/forwarder-directory-ts.md
