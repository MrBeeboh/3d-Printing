#!/usr/bin/env python3
"""
Slice a part with the OrcaSlicer Wave-Overhangs fork and VERIFY the wave
toolpath was actually emitted (WAVE_OVERHANG_* gcode markers).

IMPORTANT: wave overhangs are NOT in stock OrcaSlicer. You MUST use the fork:
  ~/Applications/OrcaSlicerWaveOverhangs_Linux_V0.4.0.AppImage
  (github.com/dennisklappe/OrcaSlicer-WaveOverhangs, v0.4.0, 2026-07-19)

Usage:
  python3 wave_slice_verify.py --stl PART.stl \
      [--process configs/wave_overhang_coupon_process.json] \
      [--outdir /tmp/wave_out] [--name jobname]

Exit code 0 = wave markers found (wave IS applied). Prints a summary.
Exit code 1 = NO wave markers (wave NOT applied) — see the troubleshooting notes.
Exit code 2 = slicer failed to run.

The output is a raw slicer gcode — it is NOT printable yet. It still needs the
PRINT_START header splice (see docs/PRINT-OPERATIONS.md §3) before upload.
"""
import argparse, glob, os, re, subprocess, sys

FORK = os.path.expanduser(
    "~/Applications/OrcaSlicerWaveOverhangs_Linux_V0.4.0.AppImage")
MACHINE = os.path.expanduser(
    "~/Documents/3d_Printing/configs/machine_enderv3se_klipper_wave.json")
FILAMENT = os.path.expanduser(
    "~/Documents/3d_Printing/configs/filament_generic_pla_blue_wave.json")


def find_output_gcode(outdir):
    cands = glob.glob(os.path.join(outdir, "*.gcode"))
    if not cands:
        return None
    return max(cands, key=os.path.getmtime)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--stl", required=True)
    ap.add_argument("--process",
                    default="~/Documents/3d_Printing/configs/"
                            "wave_overhang_coupon_process.json")
    ap.add_argument("--outdir", default="/tmp/wave_out")
    ap.add_argument("--name", default="wave_coupon")
    a = ap.parse_args()

    process = os.path.expanduser(a.process)
    outdir = os.path.expanduser(a.outdir)
    os.makedirs(outdir, exist_ok=True)

    cmd = [FORK, os.path.abspath(a.stl), "--slice", "0",
           "--outputdir", outdir,
           "--load-settings",
           f"{MACHINE};{process}",
           "--load-filaments", FILAMENT]
    print("SLICER:", " ".join(cmd))
    r = subprocess.run(cmd, capture_output=True, text=True)
    print("--- slicer stdout tail ---")
    print("\n".join(r.stdout.splitlines()[-15:]))
    if r.returncode != 0:
        print("SLICER FAILED rc=", r.returncode, file=sys.stderr)
        print(r.stderr[-2000:], file=sys.stderr)
        sys.exit(2)

    gcode = find_output_gcode(outdir)
    if not gcode:
        print("NO gcode produced", file=sys.stderr)
        sys.exit(2)
    txt = open(gcode).read()
    n_build = txt.count("; WAVE_OVERHANG_BUILD")
    n_config = txt.count("; WAVE_OVERHANG_CONFIG")
    n_start = txt.count("; WAVE_OVERHANG_START")
    n_end = txt.count("; WAVE_OVERHANG_END")

    print(f"gcode: {gcode}")
    print(f"WAVE_OVERHANG_BUILD  : {n_build}")
    print(f"WAVE_OVERHANG_CONFIG : {n_config}")
    print(f"WAVE_OVERHANG_START  : {n_start}")
    print(f"WAVE_OVERHANG_END    : {n_end}")

    if n_start == 0:
        print("\nNO WAVE TOOLPATH. Likely causes (check in order):")
        print(" 1. Stock Orca was used, not the fork (most common).")
        print(" 2. wave_overhangs not '1' in the process json.")
        print(" 3. Orca did not classify any region as overhang -> check")
        print("    Strength > Detect overhang walls = ON, and the geometry")
        print("    truly overhangs >~45 deg.")
        print(" 4. wave_overhang_min_length filtered everything (lower it).")
        print(" 5. Community gotcha: wave won't start if wall thickness equals")
        print("    the wall_loops requirement (no real unsupported lip).")
        sys.exit(1)

    # Echo the first region banner (full wave config) for a sanity read.
    m = re.search(r"; WAVE_OVERHANG_CONFIG[^\n]*", txt)
    print("\nFirst region banner:\n " + (m.group(0) if m else "(none)"))
    print("\nOK: wave toolpath present. Slice is RAW — splice the PRINT_START")
    print("header (docs/PRINT-OPERATIONS.md §3) before printing.")


if __name__ == "__main__":
    main()
