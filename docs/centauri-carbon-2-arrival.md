# Centauri Carbon 2 Combo — arrival brief (ETA Mon 2026-09-07)

Ordered from Elegoo US, **$399** (official page: $399.00 USD, ~~$449.00~~ = −11%).
**Decision confirmed 2026-09-04: operator keeping CC2 Combo over the Bambu P1S Combo** —
the P1S's $150–180 premium buys ecosystem maturity, not capability, and newer/hotter
tech from an established vendor won the call.
**Owner (operator ruling 2026-10-06/07): `Designer`** — the bot formerly called `brim` owns
the 3D-printing / CAD lane, so CC2 has a named owner again. Route CC2 work to `@designer`;
the lane is not unowned and the machine does not sit idle for lack of a dispatcher.
**All spec data below verified against the official Elegoo US product page (full read
2026-09-04)** — features, in-the-box, specifications, Q&A, footnotes, warranty policy.
Anything from external reviews is labeled as such. Earlier drafts of this doc carried
reseller-sourced errors (0.08–0.48 mm layer range, "LAN" connectivity, TPU adapter only);
those are corrected here.

## What you bought (official specs)

| Spec | CC2 Combo (official) | vs Ender-3 V3 SE |
|---|---|---|
| Build volume | 256 × 256 × 256 mm | 220 × 220 × 250 |
| Motion | CoreXY, dual 4260 steppers, die-cast frame; ≤500 mm/s (rec. 250); accel default 10,000 / max 20,000 mm/s² | bed slinger |
| Accuracy | ±0.1 mm; layer 0.1–0.4 mm (rec. 0.2) | ±0.1-ish |
| Nozzle | 0.4 mm **brass-hardened steel**, **350 °C** max; titanium-alloy heat break | ~260 °C class |
| Bed | 110 °C max, 121-point auto-leveling, dual-sided spring steel (textured PEI + PLA-specific side) | lower max |
| Enclosure | Full + thermal cover, Smart Grille auto-vent, LED lighting | none |
| Chamber heat | **No active chamber heater** — Elegoo Q&A (Apr 2026): none "at this time" | n/a |
| Color | CANVAS 4-color, 4-in-1 hub, auto refill, tangle detect, RFID | single |
| Camera | Yes (built-in) | none |
| Display | 5" color capacitive touch | stock LCD |
| Sensing | 31 sensors: clog, runout, cutter status, grille check, fan self-check, bed overheat, power-loss recovery | basic |
| Noise | ≤45 dB (Elegoo Lab: Silent Mode, aux fan off; review-measured 44–47 avg, peak 54) | louder, open |
| Network | **USB + Wi-Fi** (official spec — no Ethernet port). No cloud/account needed (Elegoo Q&A: local Wi-Fi + slicer works without app or account) | via Zero 3W host (Moonraker :7125) |
| Power | Rated 350 W @ 110 V; 1100 W @ 220 V | ~250 W |
| Dims/weight | Machine 500 × 480 × 743 mm, 19.35 kg net / 23.8 kg gross; pkg 490 × 495 × 560 | smaller, open |
| Files | Input STL/OBJ/3MF/**STEP**; output gcode | STL/3MF |
| OS | ELEGOO OS; slicer: ElegooSlicer (rec.), Orca, Cura | Klipper |

## In the box (official list, verbatim from product page)

Centauri Carbon 2 printer, Touch Screen, Power Cord, 4-Pin Cable, Unclogging Pin,
Allen Key, Screwdriver, Filament Sample, Spare Nozzle Wiper, User Manual, USB Flash
Drive, Scraper Blade, Spool Holder Module (×4), Filament Hub, CANVAS Mounting
Bracket, **Thermal Cover**, PTFE Tube (×4), Nozzle Wiper Assembly.

⚠️ **Order promos are checkout upsells, not automatic** (page shows Qikify upsell
widgets): "Free Accessory Kit for Centauri Series" (1 per printer) and the
"Get 2 kg Filaments for Just $1" ($400) bundle. **Verify both are on the order.**

## Official material support (spec page footnotes)

- Ideal: PLA / PETG / ABS / ASA. Capable: TPU / PC / PA / PET / fiber-reinforced.
- **TPU on the Combo**: install the printed Flexible Filament Adapter (STL + guide on
  the USB drive) **and disconnect the CANVAS cable** before TPU printing.
- Fiber-reinforced filaments run through CANVAS but are abrasive — Elegoo recommends
  inspecting/replacing feed parts with extended use.
- Spool holder fits **53–58 mm inner diameter**; larger spools need a printed adapter.
- RFID auto-detection works only on Elegoo RFID-tagged spools; generic spools select
  material manually. Shelf PLA (2 black, 2 white) is fine with manual profiles.

## Warranty map (official Elegoo US policy — read carefully)

- Whole machine + **CANVAS feeder module internals** (motherboard, feeder motor,
  gearbox/cutter, hub, spool holders excl. claws): **12 months**.
- **Extruder / printhead kit: 6 months** (limited; man-made damage excluded).
- **No warranty (consumables):** nozzle, hotend, heater, thermistor, PTFE tube, build
  plate, wiper, support claws, manual, tools, packaging.
- Returns: 14 days quality-related = refund/replace/repair, shipping on Elegoo.
  Non-quality returns only unopened within 14 days, restocking fee 5–15%.
- US support only in region of purchase; Elegoo does not support outside it.

## Workflow reality (primary + verified community)

- Elegoo Slicer = official (fork of OrcaSlicer); tuned CC2 profiles + integrated
  device control (WiFi send/start). Stock OrcaSlicer and Cura are listed as supported
  for slicing, but stock-Orca remote management is broken (GitHub #12212) — slice in
  Orca/Cura and transfer via Elegoo Slicer/USB, or use Elegoo Slicer end-to-end.
- Phone/remote: ELEGOO Matrix app (start prints remotely, monitoring, alerts) and
  Nexprint model hub feed Elegoo Slicer. No account needed for local-network
  firmware/slicer use (Elegoo Q&A, Mar 2026).
- Printer OS is ELEGOO OS — self-contained, no Zero 3W in its loop, not a Moonraker
  machine. Source published (github.com/elegooofficial/CentauriCarbon2).
- Practical split for this house: **Elegoo Slicer drives CC2, stock Orca still drives
  the Ender via Moonraker.**

## Known issues / honest caveats

- CANVAS color changes ~1:10 min each (review-measured); purge waste real — slice and
  read material vs flush totals before trusting waste claims. 91% first-attempt success
  in one 6-week / 34-print test (community); CANVAS load/change complaints exist.
- **4 colors max, no expansion** (Elegoo Q&A, Jan 2026: "It only supports 4-color
  printing."). Spools exposed side-mounted — no drying in the system.
- 250 °C load preset is too cold to flush PC/PA residue when switching back to PLA —
  heat the nozzle manually before the swap (reviewer finding, matches note 4 reality).
- WiFi stability complaints in early firmware; Elegoo patched post-launch; use USB if
  flaky. Run OTA firmware update before first print.
- No active chamber heat (Elegoo: not planned "at this time"); fine for ABS/ASA
  passively, but large PC/nylon parts will test it.
- Amazon aggregate 3.9/5 (289) mostly reflects the above, not print quality, which
  reviews rate excellent (Tom's HW 4.0, TechRadar 5/5 value, PCMag positive).

## Day-1 checklist (Sep 7+)

1. Unbox; inventory against the official box list above; **keep the box**.
2. **Confirm the free Accessory Kit and any "$1 filament" bundle are on the order**
   (checkout upsells — if missed, contact Elegoo support before it ships).
3. Placement: 500 × 480 mm footprint + right-side spool access + rear waste chute +
   thermal-cover clearance above. Stable table; 110 V outlet (350 W rated @ 110 V);
   power-loss recovery built in, no UPS needed.
4. Power on → OTA firmware update → full-auto calibration (121-point leveling).
5. Mount CANVAS per manual; load spools (ID 53–58 mm); manual profiles for shelf PLA.
6. Connect to house Wi-Fi (192.168.0.x); static-reserve the IP in the TP-Link.
7. Install Elegoo Slicer on HAL2026 (Orca fork — profile conventions transfer).
8. First job: single-color Benchy (shelf PLA). Then 2-color, then 4-color, reading
   waste numbers. Log results in `docs/` (project rule).
9. Ender-3 V3 SE workflow untouched until operator decides the CC2's role.

## Open questions (decide when it lands)

- ~~Keep the Ender-3 V3 SE as a second machine (parallel prints, fallback) or retire it?~~
  **Closed 2026-10-06 — operator: "not relevant, delete."** Do not re-raise it; the Ender
  stays in service under its documented workflow (`AI-QUICKSTART.md`).
- Does this become a separate project tree or stay inside `3d_Printing/` docs?

## CC2 Combo vs Bambu P1S Combo (P1S prices: Bambu US store / Best Buy, Sep 2026)

| | CC2 Combo | P1S Combo |
|---|---|---|
| Price (US street) | **$399** (paid; ~~$449~~) | **$549–579** (Bambu $579, Best Buy ~$550) |
| Build volume | 256³ | 256³ |
| Max colors | 4 (fixed — official) | 4 per AMS → 16 w/ 4×AMS + hub |
| Nozzle | Brass-hardened, **350 °C** | 300 °C max |
| Bed | 110 °C | 100 °C |
| Active chamber heat | No (official: none planned) | No |
| Network | USB + Wi-Fi, no account (official) | Account+cloud default; LAN mode exists |
| Screen / camera | 5" touch + built-in cam | small mono screen, no cam |
| Slicer | Elegoo Slicer (Orca fork) — early | Bambu Studio — mature |
| Multicolor record | CANVAS ~7 mo | AMS years, huge installed base |
| Ecosystem / longevity | Young; shorter data | Mature; parts, community, resale |

Field context (verify prices before acting): CC2 (non-combo) $339; emoji CC2 combo
$449; X1C Combo ~$1,249 (same 256³ class, adds LiDAR, still 300 °C); Bambu A1 Combo is
open-frame (no ABS); QIDI Q1 Pro is the budget machine with active chamber heat but
single-color; Creality K2 Plus Combo is bigger (305³) and $1k-class.

Bottom line: the $150–180 P1S premium buys maturity (software, AMS proof, community,
parts, resale), not capability. CC2 wins on price, hotend temp (real for CF/nylon),
screen/camera, noise, and no-account operation — at the cost of a younger software
ecosystem and shorter longevity data. For this operator (cost-sensitive, LAN-first,
engineering materials, ≤4 colors), CC2 is the right buy; P1S wins if >4 colors,
zero-fuss WiFi, or proven multi-year reliability matter more than the delta.
