# Handoff: 1 GSPS ADC channel sourcing + board cost (2026-11-18)

## Goal
Find a ~1 GSPS, 8-12 bit ADC (or 2x500 MSPS) plus all support parts for one channel, compare real active listings (LCSC first), then cost a 1-ch and 4-ch Kintex-7 board at 1/10/50/100 pcs incl. PCB, and estimate 100-pc manufacturing.

## Where the work is
- Repo `kukkineko/fpga-test-kintex-7`, branch `ccr-9730baef-8p4tdd` (pushed, no PR opened).
- `docs/adc_channel_comparison.md`: options, BOMs with LCSC part numbers, 1-ch and 4-ch cost tables.
- `docs/live_check.sh`: prints live LCSC stock and price for part codes, e.g. `./live_check.sh C661813`. Uses curl; Python urllib gets 403.
- Local PC folder (`C:\Users\thelp\Documents\projecc\fpga-dev-kit`) was NOT updated: not shared with the cloud session. Run `git fetch origin ccr-9730baef-8p4tdd && git checkout ccr-9730baef-8p4tdd` in the local clone.

## Findings
- Only in-stock, genuine ~1 GSPS part on LCSC: ADI HMCAD1511TR (C661813), 8-bit, $26.65 (1) / $22.41 (30+), 102 pcs.
- 12-bit candidate: Acelamicro AAD12Q0250 (C53145096), $61.40, 47 pcs. No datasheet found; unverified that it does 12-bit at 1 GSPS.
- 2x CBM94AD34-500 (C476439): 12-bit 500 MSPS, $87.97 each, 8 pcs. Poor value.
- 500 MSPS parts (ISLA212P20, AD9286, AD9484, AD9434) are listed at stock 0.
- Other vendors (from search snippets, not live): real 12-bit 1 GSPS (ADS54J20, TI direct, live) is about $500 for 1 pc, about $250 per channel. 8-bit 1 GSPS elsewhere is $200+. LCSC is far cheaper.
- Single channel (HMCAD1511 + ADF4351 + FPGA + DDR3): ~$236 / $183 / $165 / $158 per board at 1/10/50/100.
- 4-ch board: ~$470 / $360 / $318 / $303 per board (~$76-117 per channel).
- 100 pcs, 4-ch, manufactured: ~$36-39k (~$360-400 per board) with assembly and overhead, a rough estimate.

## Caveats
- PCB, assembly, passives and connectors are estimates; JLCPCB pricing was not reachable.
- FPGA (XC7K160T-2FFG676I, C966964) at ~$87 is far below normal distributor pricing: likely remarked or grey market. Authentic parts could roughly double board cost.
- Stock cannot cover 100 boards today: 69 FPGAs, 102 HMCAD1511, 142 ADF4351.
- Aggregators: Findchips is JS-rendered (no data), Octopart 403, DigiKey 403, Mouser and ADI not reachable via proxy. Nexar API (needs key) is the right route.
- Two scripted scrape attempts (LCSC search POST, bulk TI pages) were refused by the permission classifier and not worked around.

## Environment
- Personal cloud env `fpga-test-kintex-7` (env_013NknRdNA6eiwRQnbyxX3Pf) allows: lcsc.com, wmsc.lcsc.com, yaqwsx.github.io, mouser, digikey, ti.com, analog.com, findchips, octopart, oemsecrets.
- jlcparts DB (2.8 GB sqlite) was downloaded to the session scratchpad only; not in the repo. Source: https://yaqwsx.github.io/jlcparts/data/cache.zip plus cache.z01-z06. `zip -s 0` truncates it; stream-inflate the concatenated parts (skip 4 bytes + local header) instead.

## Next steps
1. Get the AAD12Q0250 datasheet; confirm 12-bit at 1 GSPS interleaved.
2. Price an authentic XC7K160T from an AMD distributor.
3. Set up Nexar (Octopart) API key for multi-vendor price and stock.
4. Export a JLCPCB BOM CSV with LCSC codes and get a real PCB/assembly quote.
5. Check Kintex-7 bank/LVDS limits for 1 Gbps DDR lanes and pin planning for 4 ADCs.
