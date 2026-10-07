# Zero 3W OV5647 Camera — Hardware Pipeline (2026-08-19 research + updates)

**Source:** RK3566_OV5647_camera_pipeline_research.md (researcher subagent deliverable)

## Current deployed (on Zero)
Scripts updated to research-based HW path:
- Sensor full 1920x1080 Bayer into ISP.
- ISP does demosaic + scale.
- Capture NV12 on mainpath (zero software convert).
- mppjpegenc direct.
- Sensor flips for 180° (free).
- 1280x720 (16px aligned) default for MPP.

See `/usr/local/bin/printer-cam-setup.sh` and `printer-cam-http.py` on the Zero for the exact current code.

## Key gains (quantified in research)
- CPU: from software stages (~15-60%) to mostly mppjpegenc (target <5-10% total).
- Res/FPS: up to 1920x1080@30 or stable 1280x720@30 (vs previous 640-1280@12).
- Quality: 3A (when enabled) for adaptive AE/WB/denoise vs manual fixed gain.

## Blockers right now (2026-08-20)
- CSI link down: `rockchip-csi2-dphy0: No link between dphy and sensor`
- No /dev/video0 format.
- Service inactive.
- **Fix:** physical reseat of 22-pin FPC at Zero (contacts DOWN, blue tab UP). Then 15-pin at camera if needed. Power cycle after.

## 3A
Per research: remove Conflicts and stop rkaiq from printer-cam.service once link is solid. Use the ov5647_rpi-camera-v1p3_default.json calib. Drop manual exposure lock.

## To verify after reseat
```bash
# on Zero
/usr/local/bin/printer-cam-setup.sh
v4l2-ctl -d /dev/video0 --get-fmt-video
gst-launch-1.0 -q v4l2src device=/dev/video0 io-mode=4 num-buffers=5 ! video/x-raw,format=NV12,width=1280,height=720 ! fakesink
systemctl restart printer-cam
curl -I http://127.0.0.1:8080/?action=stream
# CPU
top -b -n1 | head -5
ps aux | grep gst
```

## Files
- Research: docs/zero3w-ov5647-pipeline-research.md
- On-box scripts: the optimized versions
- Moonraker: [webcam printer] points at :8080 (already correct)

Once link is up, this is the step-change path: full hardware from sensor through ISP/RGA (if added) to MPP.


## Mount for Zero 3W + camera (2026-08-19/20)

New design: `PRINTS/zero3w_printer_cam_mount.scad`

- `zero3w_sbc_holder.stl` — tray for Radxa Zero 3W (Pi Zero hole pattern, M3 frame mounts)
- `zero3w_cam_holder.stl` — 25° tilted cradle for OV5647 M12 + UC-376 adapter

Print separately. Camera holder aims lens down at bed.

Source scad is parametric — change `tilt`, dimensions as needed.

Preview in the scad shows rough placement on a frame extrusion.

This completes the physical mounting side of the camera project so the optimized pipeline has something to look at.


## FINAL WORKING STATE (2026-08-20) — camera stream online
- **Resolution:** 1280x720 UYVY @ 12 fps, mppjpegenc HW encode
- **Orientation:** upright — sensor flips 0/0 (was 1/1 = upside down)
- **Exposure/gain:** exp=1100 (max), gain=950 (persisted in setup.sh)
- **Gamma:** 2.0 in gst pipeline (http.py)
- **Server:** ThreadingHTTPServer (stream + snapshot coexist — was single-threaded blocking)
- **Measured:** mean brightness 59 (was 32), p95 90, ~200KB 1280x720 JPEG
- **Service:** printer-cam.service active, restart-safe
- **Limits:** dim scene, low contrast — real fix = LED bar (Creality 24V 5W ordered, arriving 2026-08-20)
- **Links:** stream http://192.168.0.18:8080/?action=stream · snap .../?action=snapshot · Fluidd :4408

Once LED installed, re-tune: likely drop gain toward 500-700 and gamma toward 1.4 for cleaner contrast (lower noise).

## ROBUSTNESS (2026-08-20) — self-healing verified
- **Camera self-heal:** http.py now re-runs printer-cam-setup.sh after 3 consecutive gst failures (media-ctl/format/flips re-established). TESTED: force-killed gst mid-stream, it recovered a real image on its own — no manual power cycle.
- **Brightness = ambient only (2026-08-20, Harold's decisive test):** heated bed 54.1C left frame at mean 27.3 (vs 26.8 cold) — OV5647 M12 lens has an IR-cut filter, so bed heat/IR contributes NO visible light. Do NOT tune exposure/gain against bed warmth. Dark frame with cold idle printer = correct manual-AE read of a dim scene. LED bar (arriving 2026-08-20) is the only real brightness fix.
- **MCU USB drop (powersave)**: `usbcore.autosuspend=-1` in /proc/cmdline + live; no suspend timers/targets exist. Nothing can sleep the board.
- **Klipper wedge after failed print**: klipper-recover.timer polls every 30s, firmware_restarts only when MCU present + klippy error/shutdown + NO active print. Safe — cannot kill a running job.
- **Crash recovery**: Restart=always on klipper, moonraker, printer-cam (RestartSec 3-10).
- **Boot**: all 4 (klipper, moonraker, printer-cam, klipper-recover.timer) enabled + active.
- Verified live: force-kill test passed; boot-enable confirmed.

Threshold: stream/snapshot at :8080, Fluidd :4408, Moonraker :7125.
