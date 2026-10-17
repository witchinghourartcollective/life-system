# Inbox

Quick capture. Process later.

---

## To Do

- [ ] Put the new Project-Rainfall archive token into Bitwarden (replaces the old one; old value is dead)
- [ ] Commit the uncommitted `~/.git` changes on next backup: `.gitattributes`, `functions/project_rainfall_function/{index.js,catalyst-config.json}`, `bin/stratus-upload-test.sh`
- [ ] Delete leftover test objects from `witching-hour-stratus-bucket` (`probe_*`, `iso_*`, `arc_*`, `t*.txt`, `realarc.tgz*`, `rawprobe.txt`, `final.txt`, `dbg_*`, `archive-selftest.txt`)
- [ ] Decide: Catalyst vs. existing GCP always-on setup for 24/7 hosting of disk-heavy / must-be-up workloads
- [ ] Structural fix for `~/.git` bloat: filter-repo old encrypted DB-blob history, or stop versioning live `.lnd/.lit` DBs in the backup repo
- [ ] whm-onchain-agent has no dry powder (USDC ~$0 Base / $1 Polygon / $0 BNB, positions all underwater). Decide: fund with USDC + ~$5–10 ETH on Base for gas, OR authorize realizing losses on the stuck positions, OR leave it holding. Trader is running and RPC is fixed — just needs capital.
- [ ] Consider turning on `MARKET_REGIME_ENTRY_GATE_ENABLED=true` for whm-onchain-agent once funded (pauses new buys in a BEAR macro regime; `npm run trade:regime` shows current read — TRANSITION as of 08-28)
- [x] Document the nine installed ONEchain skills and correct the signing count — see [[onechain-skills-suite]]
- [x] Define the managed-signer target with Trust Wallet as human owner — see [[onechain-wiring]]
- [ ] Ask to-nexus whether `skill-cross-stake` was renamed, removed, or made private
- [ ] Verify official CROSS network and WalletConnect parameters
- [ ] Select a CROSS-compatible smart-account and managed-signer provider
- [ ] Pilot the signer adapter in one transaction skill with negligible funds
- [ ] Add CI secret scanning and tests that reject committed `.env` files

## Someday / Not Now

-

## Ideas

-
- [ ] Fix lnd.witchinghourmac.com DNS: grey-cloud A record → 45.55.55.122 (currently CF-proxied, 9735 unreachable)
- [ ] Paste new hourly health-check prompt into the Desktop scheduled task
- [ ] Decide whether to refund the trader at all (never worked in ~1 year); if yes, set a bar for what "working" means first
- [ ] Check why Catalyst LND watchdog + trade_health_function did not alert
- [x] WHM-LND: 961,893-sat channel with peer 02dd5438… is inactive; find out why (peer offline?) before doing anything with it — active again as of 09-26 (Naghust, 33.7k local)

- [ ] whm-flywheel: route a share of take-profit ETH into auto-compounding yield (Aave v3 / Moonwell / Morpho on Base — pick highest rate at the time; aTokens accrue every ~2s block). Revisit once profits are flowing. (2026-09-25)
- [ ] 09-30: WHM-LND: any forward OUT via Naghust, or any successful refill at 1000ppm? If neither, turn the rebalancer off. It is not doing anything
- [ ] Send GCUL onboarding email (draft: ~/cre-project/gcul/onboarding-email.md): fill in Org ID + new project ID first
- [x] Deploy CoinCircuitBreaker on Base: 0xBFeDCca4dE6cF908C1cf375D430DaDDc15C9bdca (10-02)
- [ ] Review/merge whm-flywheel PR #1, build+import new image, bump tag in whm-infra PR #1, merge
- [ ] When CRE deploy access is approved: `cre account link-key`, setExpectedAuthor on the breaker, `cre workflow deploy coin-breaker --target production-settings`
- [x] Before Mon 10-05 11:30 Chainlink meeting: verify CoinCircuitBreaker on Basescan (done 10-02) (standard-input JSON in ~/cre-project/coin-breaker/contracts)
- [ ] Prep for Chainlink meeting Mon 10-05 11:30 (goal, asks, demo)
- [ ] Run gateway:send 0.01 4817→4817 once the 0.02 Gateway deposit is credited (`npm run -s gateway:balances`) — 2026-10-03
- [ ] Open the GitLab MR for witching-hour-app `a2a-agent-card` — 2026-10-03
- [ ] GoBTC Pay: in merchant.gobtcpay.com check which receiving wallet is linked. If you want checkout payouts beside your GoMining GoBTC Pay wallet, re-link via Receiving Wallet → Start wallet link and scan with the GoMining app. Ask GoMining support whether the merchant account can be tied to the GoMining account. (2026-10-06)
- [ ] GoBTC Pay: replace the placeholder $5/$20/$50 "Support" items in src/lib/gobtcpay.ts with real offerings (2026-10-06)
- [ ] witchinghourmac.com: purge the CF cache (dashboard → Caching → Purge Everything) so Google sees the new SEO homepage; the edge Cache Rule is still serving the old HTML. Or create a token with Zone → Cache Purge (2026-10-07)
- [ ] Google Search Console: add witchinghourmac.com + mirrorizm.com as Domain properties, hand over the TXT values for DNS, submit sitemaps, request indexing (2026-10-07)
- [ ] Put witchinghourmac.com in IG/SoundCloud/Bandcamp/YouTube/Zora bios; send the profile URLs (incl. Spotify) for the structured-data sameAs (2026-10-07)
- [ ] Mirrorizm SEO: approve the title/description reframed as visual art, fashion and street art (2026-10-07)
