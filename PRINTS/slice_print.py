#!/usr/bin/env python3
"""
slice_print.py — ONE-SHOT: slice → splice → upload → (optionally start) for the
Ender-3 V3 SE via Moonraker. Canonical workflow documented in
docs/PRINT-OPERATIONS.md. Read that first.

Usage:
  python3 slice_print.py --stl part.stl --name my_part [--fast] [--tpu] [--supports] [--start]

  --stl        input STL (required)
  --name       name on the printer (required; gcode file name without .gcode)
  --fast       fast profile (0.28/2 walls/15% rectilinear) — default is quality
  --tpu        Overture TPU profile (0.20/3 walls/25% gyroid, slow, no z-hop)
  --supports   inject breakaway support settings into the process preset
  --start      start the print after upload (DO NOT use without operator go)

Slicer: OrcaSlicer (operator's slicer of record). Orientation is baked into
the STL — the slicer does NOT auto-rotate; verify first-layer footprint in the
gcode before printing (docs/PRINT-OPERATIONS.md §5).

Prints: estimate, spliced header check, upload result, and with --start a 15s
verification (state, bed target, progress).
"""
import argparse, os, re, subprocess, sys, time, urllib.request, urllib.parse, json

HOST = "http://192.168.0.18:7125"

QUALITY = ["--layer-height=0.2", "--first-layer-height=0.2", "--perimeters=3",
           "--fill-density=20%", "--fill-pattern=gyroid",
           "--solid-infill-speed=180", "--travel-speed=150", "--first-layer-speed=30"]
FAST = ["--layer-height=0.28", "--first-layer-height=0.28", "--perimeters=2",
        "--fill-density=15%", "--fill-pattern=rectilinear",
        "--solid-infill-speed=200", "--travel-speed=200", "--first-layer-speed=40"]

def run(cmd):
    print("$", " ".join(cmd))
    p = subprocess.run(cmd, capture_output=True, text=True)
    out = (p.stdout + p.stderr)
    for line in out.splitlines():
        if any(k in line.lower() for k in ["estimated", "error", "warning", "exporting"]):
            print(" ", line.strip())
    if p.returncode != 0:
        print("FAILED rc=", p.returncode)
        sys.exit(1)
    return out

def splice(gcode_path, header=None):
    src = open(gcode_path).read().split('\n')
    start = next((i for i, ln in enumerate(src) if ln.startswith('G1 ')), 0)
    body = src[start:]
    body = [ln for ln in body if not re.match(r'M(104|109|140|190)', ln)]
    body = [ln for ln in body if not ln.startswith('SET_VELOCITY_LIMIT')]
    header = list(header or PLA_HEADER)
    out = header + body
    if not any(ln.startswith('M84') for ln in out[-10:]):
        out += ["M104 S0", "M140 S0", "M84"]
    fixed = gcode_path.replace('.gcode', '_fix.gcode')
    open(fixed, 'w').write('\n'.join(out))
    return fixed, header

def api(path, method="GET", data=None, files=None):
    if files:
        import uuid
        boundary = uuid.uuid4().hex
        parts = []
        for k, v in files.items():
            parts.append(f"--{boundary}\r\nContent-Disposition: form-data; name=\"{k}\"; filename=\"{v[0]}\"\r\nContent-Type: application/octet-stream\r\n\r\n".encode() + v[1] + b"\r\n")
        body = ("--" + boundary + "--\r\n").encode().join(parts)
        req = urllib.request.Request(HOST + path, data=body, method="POST")
        req.add_header("Content-Type", f"multipart/form-data; boundary={boundary}")
    else:
        req = urllib.request.Request(HOST + path, method=method)
        if data: req.data = json.dumps(data).encode()
    with urllib.request.urlopen(req, timeout=15) as r:
        return json.loads(r.read().decode())

ORCA = "/home/mike/Applications/OrcaSlicer.AppImage"
MACHINE = "/home/mike/.config/OrcaSlicer/user/default/machine/Ender-3 V3 SE (Klipper).json"
FILAMENT = "/home/mike/.config/OrcaSlicer/system/Creality/filament/Creality Generic PLA @Ender-3V3-all.json"
FAST_PROC = "/tmp/v3se_0.28_draft.json"              # 0.28 / 2 walls / 15% rectilinear
QUALITY_PROC = "/home/mike/.config/OrcaSlicer/system/Creality/process/0.20mm Standard @Creality Ender3V3SE 0.4.json"
TPU_PROC = "/home/mike/Documents/3d_Printing/configs/process_0.20mm_tpu_v3se.json"
TPU_FILAMENT = "/home/mike/Documents/3d_Printing/configs/filament_overture_tpu_v3se.json"
TPU_HEADER = ["; TPU - spliced via slice_print.py",
              "PRINT_START BED=40 EXTRUDER=220", "M220 S100", "M221 S100", "M106 S0",
              "G90", "G21", "M83",
              "SET_PRESSURE_ADVANCE ADVANCE=0.02"]
PLA_HEADER = ["; SENTINEL - spliced via slice_print.py",
              "PRINT_START BED=55 EXTRUDER=200", "M220 S100", "M221 S100", "M106 S255",
              "G90", "G21", "M83"]

# Breakaway support settings injected into a COPY of the process preset
# (Orca CLI does NOT take support flags on the command line — they belong
# in the preset; see docs/PRINT-OPERATIONS.md §2/§5).
#
# ⚠️ VERIFIED 2026-09-11: these MUST be Orca-native values. An earlier version of
# this dict used PrusaSlicer names and silently produced ZERO supports:
#   "support_type": "normal"          -> INVALID. Orca wants "normal(auto)" / "tree(auto)".
#                                        A bad enum does NOT error — Orca just generates no
#                                        supports, and the slice looks fine in a line count.
#   "support_angle"                   -> Prusa-only; Orca uses support_threshold_angle.
#   "support_buildplate_only"         -> Prusa-only; Orca uses support_on_build_plate_only.
# ALWAYS verify the spliced gcode contains `;TYPE:Support material` AND
# `;TYPE:Support material interface` before claiming supports are on.
SUPPORT_KEYS = {
    "enable_support": "1",               # Orca presets store bools as string "0"/"1"
    "support_type": "normal(auto)",      # NOT "normal" — that enum is invalid
    "support_style": "organic",          # organic/tree = easiest to release
    "support_threshold_angle": "40",
    "support_on_build_plate_only": "1",  # no support-on-model welding
    "support_interface_layers": "3",
    "support_interface_spacing": "0.3",
    "support_interface_loop_pattern": "1",
    "support_top_z_distance": "0.3",
}

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--stl", required=True)
    ap.add_argument("--name", required=True)
    ap.add_argument("--fast", action="store_true")
    ap.add_argument("--tpu", action="store_true")
    ap.add_argument("--supports", action="store_true")
    ap.add_argument("--start", action="store_true")
    a = ap.parse_args()

    if a.tpu and a.fast:
        print("FAILED: --tpu and --fast are mutually exclusive")
        sys.exit(1)
    filament = TPU_FILAMENT if a.tpu else FILAMENT
    splice_header = TPU_HEADER if a.tpu else PLA_HEADER
    proc = TPU_PROC if a.tpu else (FAST_PROC if a.fast else QUALITY_PROC)
    if a.supports:
        # inject breakaway support settings into a temp copy of the preset
        with open(proc) as f:
            preset = json.load(f)
        preset.update(SUPPORT_KEYS)
        proc_tmp = f"/tmp/{a.name}_proc.json"
        with open(proc_tmp, "w") as f:
            json.dump(preset, f)
        proc = proc_tmp
        print("supports: injected breakaway settings into", proc)

    outdir = f"/tmp/{a.name}_orca"
    os.makedirs(outdir, exist_ok=True)
    cmd = [ORCA, a.stl, "--slice", "0", "--outputdir", outdir,
           "--orient", "1", "--arrange", "1", "--allow-rotations", "--ensure-on-bed",
           "--load-settings", f"{proc};{MACHINE}",
           "--load-filaments", filament]
    run(cmd)

    # Orca writes <name>_1.gcode + result.json into the outputdir
    import glob
    gcodes = sorted(glob.glob(os.path.join(outdir, "*_1.gcode")))
    if not gcodes:
        print("FAILED: no gcode produced in", outdir)
        sys.exit(1)
    gcode = gcodes[0]
    try:
        res = json.load(open(os.path.join(outdir, "result.json")))
        for plate in res.get("sliced_plates", []):
            w = plate.get("warning_message")
            if w:
                print("SLICER WARNING:", w)
    except Exception as e:
        print("no result.json to check:", e)

    fixed, header = splice(gcode, header=splice_header)
    print("spliced ->", fixed)
    print("header:", header[1] if len(header) > 1 else "??")

    # upload with correct filename
    data = open(fixed, 'rb').read()
    r = api("/server/files/upload?overwrite=true", files={"file": (f"{a.name}.gcode", data)})
    print("upload:", r.get("result", {}).get("action", r))

    if a.start:
        r = api(f"/printer/print/start?filename={urllib.parse.quote(a.name + '.gcode')}", method="POST")
        print("start:", r)
        time.sleep(15)
        q = api("/printer/objects/query?print_stats=state,filename,print_duration&heater_bed=temperature,target&extruder=temperature,target&virtual_sdcard=progress")
        st = q["result"]["status"]
        print("VERIFY:", st["print_stats"]["state"], "|", st["print_stats"].get("filename"),
              "| bed %.0f/%.0f" % (st["heater_bed"]["temperature"], st["heater_bed"]["target"]),
              "| nozzle %.0f/%.0f" % (st["extruder"]["temperature"], st["extruder"]["target"]),
              "| progress %.1f%%" % (st["virtual_sdcard"]["progress"] * 100))
    else:
        print("STAGED only. Operator approval required before start.")

if __name__ == "__main__":
    main()
