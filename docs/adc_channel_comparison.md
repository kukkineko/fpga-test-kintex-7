# Single-channel ~1 GSPS ADC + support parts (LCSC live listings)

Checked 2026-11-18. Stock and price come from the live LCSC product API (qty 1, USD).
Candidate discovery used the jlcparts mirror of the LCSC/JLC DB (snapshot 2026-09 to 11-16).
Passives, connectors and PCB are **not** costed (estimate +$1.5 to $3 per channel).

## ADC options (>= 500 MSPS equivalent, 8-12 bit, in stock on LCSC)

| Option | ADC | Bits | Rate | Interface | LCSC | Stock | 1 pc | 30 pc | Notes |
|---|---|---|---|---|---|---|---|---|---|
| A | ADI HMCAD1511TR | 8 | 1 GSPS single-ch (4 ch at 250) | LVDS + SPI | C661813 | 102 | $26.65 | $22.41 | Genuine ADI, cheapest true 1 GSPS part |
| B | Acelamicro AAD12Q0250 | 12 | 4 x 250 (1.1 GHz clk) | LVDS + SPI | C53145096 | 47 | $61.40 | $58.43 | No datasheet in DB; SNR 59.8 dB. Confirm 1 GSPS interleave mode first |
| C | 2x Corebai CBM94AD34-500 | 12 | 2 x 500 | LVDS | C476439 | 8 | $87.97 each ($175.94) | $83.55 each | Needs 2 phase-matched clocks and FPGA-side interleave. Stock too thin |
| - | AD6643BCPZ-250 (ADI) | 11 | 250 | LVDS | C514232 | 44 | $96.07 | | Too slow |
| - | ISLA212P20 / AD9286 / AD9484 (500 MSPS) | 8-12 | 500 | LVDS | various | 0 | | | Listed on LCSC but out of stock |

## Support chain, per channel (live verified)

| Function | Part | LCSC | Stock | 1 pc |
|---|---|---|---|---|
| AC input, single-ended to diff | Mini-Circuits ADT1-1WT+ (0.4-800 MHz) | C6835853 | 1346 | $5.24 |
| Alt: DC-coupled diff driver | TI LMH6554 | C701927 | 242 | $12.54 |
| Alt: DC-coupled diff driver | ADI ADA4930-1 | C578938 | 1918 | $10.69 |
| Sample clock synth (35-4400 MHz) | ADI ADF4351BCPZ | C654681 | 142 | $13.58 |
| 100 MHz reference XO (LVDS) | SiTime SiT9121AC-2B2-33E100 | C836760 | 490 | $5.07 |
| Clock fanout (for option C) | ADI ADCLK944BCPZ | C514318 | 191 | $12.09 |
| 1.8 V analog LDO (low noise) | ADI LT3042EMSE | C461518 | 2295 | $4.66 |
| 1.8 V digital LDO | TI LP5907MFX-1.8 | C92498 | 21170 | $0.20 (min 5) |
| 3.3 V LDO for PLL | ADI ADP7118AUJZ-3.3 | C194022 | 4331 | $1.78 |

## Channel totals (no passives)

| Option | ADC | Input | Clock | Power | Total |
|---|---|---|---|---|---|
| A (8-bit, AC-coupled) | 26.65 | 5.24 | 18.65 | 6.64 | **~$57.2** |
| A with LMH6554 (DC-coupled) | 26.65 | 12.54 | 18.65 | 6.64 | ~$64.5 |
| B (12-bit quad) | 61.40 | 5.24 | 18.65 | 6.64 | ~$91.9 |
| C (2x 12-bit 500 MSPS) | 175.94 | 10.48 | 30.74 | ~13 | ~$230 |

## Recommendation

- **Option A** is the only one that is both cheap and well documented: genuine ADI, 1 GSPS in single-channel mode, healthy stock. The catch is 8 bits (49.8 dB SNR).
- For **12 bits**, B is the cost winner, but only if the Acelamicro datasheet confirms 12 bits at 1 GSPS in interleaved mode. I could not find it. C works but costs about 4x A and the 8 pieces in stock is not enough for volume.
- No in-stock genuine 12-bit 1 GSPS part (ADS54J, AD9680, ADC12DJ) exists on LCSC today.

## Caveats

- Kintex-7 LVDS inputs run to about 1.25 Gbps per pair on HR banks, so a 1 GSPS 8-bit LVDS ADC needs DDR deserialization (HMCAD1511 outputs 8 bits as 1-bit lanes at up to 1 Gbps DDR). Check the bank speed grade.
- ADF4351 phase noise limits SNR above about 200 MHz input. Fine for 8 bit. For 12 bit use an LMK04828 ($22.04, C478068) instead.
- Part availability is a snapshot. Re-run `live.sh` before ordering.

## Full single-channel board estimate (Option A + Kintex-7), USD per board

Live LCSC ladders on 2026-11-18. Build: HMCAD1511 + ADF4351/100 MHz XO + XC7K160T-2FFG676I + DDR3 capture buffer + W25Q128 flash + 2x TPS65261 + LDOs.

| Qty | ADC chain | FPGA | DDR3 + flash + power | Misc* | PCB** | **Total / board** |
|---|---|---|---|---|---|---|
| 1 | 56.2 | 87.0 | 23.6 | 14 | 55 | **~$236** |
| 10 | 53.0 | 87.0 | 22.2 | 12 | 8.5 | **~$183** |
| 50 | 47.7 | 82.9 | 19.0 | 10 | 5.5 | **~$165** |
| 100 | 46.0 | 82.9 | 17.4 | 9 | 4.2 | **~$158** |

*Estimate: passives, 2x SMA, JTAG, USB-C/UART, LEDs. Not looked up.
**Estimate: 6-layer ~100x80 mm, ENIG, impedance controlled. JLCPCB prices could not be fetched. Qty 1 means one 5-pc minimum order. Assembly (BGA reflow) is not included.

Stock limits: XC7K160T-2FFG676I has 69 pcs, HMCAD1511 102, ADF4351 142, so 100 boards is not fully covered today. The FPGA price is far below authorized-distributor pricing, so treat it as remark/counterfeit risk and test or source from AMD distributors for production.
