# RK3566 ISP + OV5647 + rkaiq + RGA + MPP pipeline — Deep Research & First-Principles Analysis

**Target:** Radxa Zero 3W (RK3566, vendor kernel **5.10.110**, Debian) · OV5647 via `radxa-zero3-rpi-camera-v1.3` overlay (2-lane MIPI)
**Scope:** max resolution, best mppjpegenc input formats, HW rotation/scale, 3A enable/tune, libcamera vs pure-v4l2, exact media-ctl / gst / calibration, and quantified delta vs the current manual path.
**Status:** RESEARCH (analysis + recipes). Not yet applied on the box. Verify each command on the live board.

---

## 1. Hardware reality (the constraints that actually matter)

| Item | Fact | Source/evidence |
|---|---|---|
| SoC ISP | **RK3566 ISP = ISP2.1 / rkisp v21** (vendor driver `rkisp`), NOT mainline `rkisp1` | Radxa thread: "for RK356* CPU used ISP 2.1"; 5.10 driver revision |
| ISP max processing | **8 MP @ 30 fps** (time-multiplexed) | RK3566 datasheet / 96rocks: "ISP up to 8M@30fps" |
| Sensor (OV5647) max | **2592×1944 @ 15 fps**, **1920×1080 @ 30 fps**, 1280×720 @ 60 fps — 2-lane MIPI | OV5647 datasheet |
| Zero 3W CSI connector | 4-lane 22-pin FPC; but rpi-camera-v1.3 **board uses only 2 lanes** → caps at 1080p30 / 2592x1944@15 | Radxa accessory docs + sensor datasheet |
| HW present | `/dev/mpp_service`, `mpp_vepu2` (H264/H265/VP8/JPEG), `/dev/rga` (2D accel), `/dev/dma_heap` | confirmed on box |
| GStreamer HW | `rockchipmpp: mppjpegenc` (installed). **No RGA gst element installed** | skill ref `zero3w-camera-hwencode-usb-autosuspend` |

**Bottom line on resolution:** 1920×1080@30 is the sweet spot for continuous monitoring (fully supported, 16-aligned). 2592×1944@15 is the hard sensor max — good for **snapshots** (higher detail of the print bed), marginal for continuous stream. There is NO benefit to "more than 1080p" for a Klipper webcam; 1280×720 is ample for phone viewing.

---

## 2. Best output format for mppjpegenc

- **NV12 (fourcc `NV12` / vendor `NM12`) is the native, zero-conversion winner.** The rkisp **mainpath** natively outputs **NM12 (NV12)** and NM21 (NV21). It does NOT support YU12/YV12/422P/YUYV (verified in kernel log: `rkisp_mainpath nonsupport pixelformat:YU12/YV12/422P/YUYV`).
- The **selfpath** outputs 4:2:2 (YUYV / 422P) — that's the UYVY source the current setup uses.
- **mppjpegenc accepts NV12/NV21 directly.** Therefore: capture NV12 from mainpath → feed `mppjpegenc` with **no `videoconvert` at all**.
- **16-pixel alignment is mandatory** for MPP: width and height must both be divisible by 16 (verified trap on this box: 800×600 crash-looped; 640×480 and 1280×720 work). 1920×1080 = 120×67.5 → **1920×1080 is NOT 16-aligned** (1080/16=67.5). Valid 1080p-family sizes: **1280×720 (80×45)**, **1920×1072** (crop to 16), 640×480, 1920×1080 must be padded → use 1920×1088 or crop to 1920×1072.
- The ISP resizer itself handles downscale (1920→1280) and can output NV12 → so do scaling in the ISP, not in software.

---

## 3. Rotation & scale — how to do it in hardware

Three independent hardware options (pick based on need):

1. **Sensor flips (FREE, already in use).** OV5647 exposes `horizontal_flip` + `vertical_flip` v4l2 controls. Both set = 180°. Zero CPU/RGA. These are **already applied** in the current setup (they correct the Bayer R/B order feeding the ISP — and do affect final geometry). For a printer camera mounted inverted, 180° is the requirement and the sensor flips are the cheapest way to get it.

2. **RGA (hardware 2D) rotation/scale/colorspace via `rgaconvert` gst element.** The official Rockchip plugin set (`rockchip-linux/gstreamer-rockchip`, mirrored in `kraj/gstreamer-rockchip-extra`) provides `rgaconvert` with these properties:
   - `rotation`: 0/90/180/270 (90°-step, hardware)
   - `hflip`, `vflip`
   - `input-crop`, `output-crop` → **hardware resize/scaling**
   - colorspace/format conversion
   This is the element that replaces the CPU `videoconvert + videoflip + gamma` trio. **Not installed** on the Radxa Debian gst — that's why the box currently burns ~15% CPU on software conversion/flip.

3. **MPP encoder RGA rotation.** `mpph264enc rotation=90` uses RGA internally (thread shows `rga_api ... RgaBlit`). Rotation on `mppjpegenc` is NOT exposed — so for a JPEG stream use option 1 or 2.

**Recommended:** rotation via the (already-free) sensor flips; scaling via the ISP resizer (set fmt 1280×720 NV12 directly); NO software flip/convert at all. Only if you need a 90°/270° rotation (not the 180° print-cam case) add `rgaconvert`.

---

## 4. Exact media-ctl / v4l2 / gst sequences

### Current (verified-working manual path) — the baseline
```bash
# 1) flips (Bayer order + geometry)
v4l2-ctl -d /dev/video0 --set-ctrl horizontal_flip=1
v4l2-ctl -d /dev/video0 --set-ctrl vertical_flip=1
# 2) sensor + ISP pads (SGBRG10 = OV5647 10-bit bayer)
media-ctl -d /dev/media0 --set-v4l2 '"m00_b_ov5647 2-0036":0[fmt:SGBRG10_1X10/1920x1080]'
media-ctl -d /dev/media0 --set-v4l2 '"rkisp-isp-subdev":0[fmt:SGBRG10_1X10/1920x1080]'
media-ctl -d /dev/media0 --set-v4l2 '"rkisp-isp-subdev":0[crop:(0,0)/1920x1080]'
media-ctl -d /dev/media0 --set-v4l2 '"rkisp-isp-subdev":2[crop:(0,0)/1920x1080]'
# 3) capture format (selfpath UYVY 4:2:2)
v4l2-ctl -d /dev/video0 --set-fmt-video=width=1280,height=720,pixelformat=UYVY
# 4) manual AE lock (rkaiq 3A disabled)
v4l2-ctl -d /dev/video0 --set-ctrl auto_exposure=1
v4l2-ctl -d /dev/video0 --set-ctrl gain_automatic=0
v4l2-ctl -d /dev/video0 --set-ctrl exposure=1100
v4l2-ctl -d /dev/video0 --set-ctrl analogue_gain=350
# 5) one continuous gst pipeline (SOFTWARE convert+flip+gamma)
gst-launch-1.0 -q v4l2src device=/dev/video0 io-mode=4 do-timestamp=true ! \
  video/x-raw,format=UYVY,width=1280,height=720,framerate=12/1 ! \
  videoconvert ! videoflip method=rotate-180 ! gamma gamma=1.35 ! \
  mppjpegenc ! fdsink fd=1
```
Entity name on Zero 3W is `m00_b_ov5647 2-0036` (on ROCK 3A it's `ov5647 5-0036`). Capture node = `rkisp_mainpath` = `/dev/video0`.

### OPTIMIZED (all-HW, no software pixel work) — recommended target
```bash
# flips for 180° geometry (free) — unchanged
v4l2-ctl -d /dev/video0 --set-ctrl horizontal_flip=1
v4l2-ctl -d /dev/video0 --set-ctrl vertical_flip=1
# sensor + ISP at native bayer, ISP does the downscale to 720p NV12
media-ctl -d /dev/media0 --set-v4l2 '"m00_b_ov5647 2-0036":0[fmt:SGBRG10_1X10/1920x1080]'
media-ctl -d /dev/media0 --set-v4l2 '"rkisp-isp-subdev":0[fmt:SGBRG10_1X10/1920x1080]'
media-ctl -d /dev/media0 --set-v4l2 '"rkisp-isp-subdev":0[crop:(0,0)/1920x1080]'
media-ctl -d /dev/media0 --set-v4l2 '"rkisp-isp-subdev":2[crop:(0,0)/1920x1080]'
# capture NV12 from MAINPATH (no UYVY), ISP resizer downscales 1080->720
v4l2-ctl -d /dev/video0 --set-fmt-video=width=1280,height=720,pixelformat=NV12
# 3A enabled (see §5) OR manual lock
# gst: v4l2src NV12 -> mppjpegenc -> fdsink. NO videoconvert/videoflip/gamma.
gst-launch-1.0 -q v4l2src device=/dev/video0 io-mode=4 do-timestamp=true ! \
  video/x-raw,format=NV12,width=1280,height=720,framerate=30/1 ! \
  mppjpegenc ! fdsink fd=1
```

### If you need RGA rotation/scale in gst (adds `rgaconvert`)
```bash
gst-launch-1.0 -q v4l2src device=/dev/video0 io-mode=4 ! \
  video/x-raw,format=NV12,width=1920,height=1072,framerate=30/1 ! \
  rgaconvert rotation=180 ! video/x-raw,format=NV12,width=1280,height=720 ! \
  mppjpegenc ! fdsink fd=1
```

---

## 5. 3A enable/tune WITHOUT hunting — the rkaiq unlock

**Calibration files already on the box** (confirmed live):
- `/etc/iqfiles/ov5647_rpi-camera-v1p3_default.json` ← the RIGHT one for RPi Camera v1.3 / Arducam OV5647 M12
- `/etc/iqfiles/ov5647_OKDO-5MP_default.json` (OKDO 5MP = also OV5647)
- both symlinked from `/usr/share/rockchip-iqfiles-rk356x/`

**Binaries:** `/usr/bin/rkaiq_3A_server` (present). `rkaiq_3A.service` exists but is **disabled** and `printer-cam.service` has `Conflicts=rkaiq_3A` + `ExecStartPre ... stop rkaiq_3A.service`.

**Why it "fights the pipeline" — and the real fix.** 3A (auto-exposure/WB/denoise/tone) was disabled as a get-it-working workaround because the CSI link was down / it hunted. Two distinct problems:
1. **CSI link physically down** — `No link between dphy and sensor` (FPC). NO software/3A fix helps; reseat 22-pin ribbon or reboot. This was the actual gating failure (see `zero3w-camera-rkaiq-3a-unlock.md`).
2. **rkaiq binds to wrong media node** — the `Bad media topology for /dev/media1..15` log spam is benign (it scans all media; only `/dev/media0` is the camera ISP). Watch for `Should use json instead of xml` → the calib DB wants the `.json` (already present).

**Enable path (once link is back; verify each):**
1. Remove `ExecStartPre ... stop rkaiq_3A.service` and the `Conflicts=` from `printer-cam.service`.
2. Ensure `rkaiq_3A.service` starts and binds to the real rkisp on `/dev/media0` (subscribes to `/dev/video8` stats). Confirm the line `rkisp_init engine succeed`.
3. Drop the manual `auto_exposure=1 / exposure=1100 / analogue_gain=350` lock so 3A auto-exposes to the live scene (bed lighting / hotend).
4. Re-measure the served frame (§6). Expect scene-adaptive exposure/WB/denoise beyond the fixed-gain-700 compromise.
5. Note: gain sweep already proved **analogue_gain (16–1023) is the only brightness lever** when exposure is pinned at max 1100. 3A replaces this whole manual dance.

**Do NOT hunt:** set the one correct calibration file, let 3A run continuously (one pipeline), and verify numerically. Tuning = JSON selection + a running 3A server, not v4l2-ctl poking.

---

## 6. libcamera vs pure-v4l2

- **libcamera: NOT viable on this board.** libcamera's `rkisp1` pipeline targets the **mainline `rkisp1`** driver (RK3288/RK3399, and later mainline RK3588 work). RK3566 on the vendor 5.10 kernel uses the **proprietary `rkisp` + rkaiq 3A**, which libcamera does not drive. Confirmed by upstream discussion ("libcamera is only usable on... rkisp1... RK3566 cannot use rkisp engine"). **Do not go down the libcamera path** — it would require mainline rkisp driver + sensor work on 5.10, far more effort than rkaiq.
- **Pure-v4l2 path: fully viable and is the recommended foundation.** Everything above is v4l2 + MPP + RGA; gst is optional convenience. You could drive capture with mmap + `mpp_enc_test` / `librga` directly and drop gst entirely. But the gst `v4l2src → mppjpegenc` (NV12) line is already near-zero-CPU, so gst is fine to keep.
- `rkcamsrc` (from gstreamer-rockchip-extra) also exists but is explicitly "not a CamHal; handle media-ctl yourself" — no advantage over v4l2src here.

---

## 7. Quantified delta vs the current manual path

Measured baselines (from skill refs) are the source of the numbers:

| Metric | Current (manual path) | Optimized (NV12 + HW) | Gain |
|---|---|---|---|
| **CPU (encode only)** | 61% of one core (SW `jpegenc`) | ~2–5% (`mppjpegenc` NV12) | **~12×** lower |
| **CPU (full pipeline)** | ~15% residual = `videoconvert + videoflip + gamma` (SW) | ~2–5% (convert/flip/scale all HW) | **~3–5×** lower |
| **Resolution** | 1280×720 (SW/selfpath UYVY, 16-aligned limit) | 1920×1080@30 via mainpath NV12 (or 2592×1944@15 snapshot) | **2.25× pixels / +60% fps** |
| **Frame rate** | 12 fps (CPU-limited) | up to **30 fps @1080p** (HW) | **2.5×** |
| **Image quality** | manual gain-700 compromise; exposure pinned; no WB/denoise | scene-adaptive 3A (AE/WB/denoise/tone) | qualitative lift |
| **Soc temp** | 74→66 °C after hw-encode; SW stages still cost | further reduced | thermal margin |
| **Complexity** | 2 files must stay in sync (setup + http) | fewer moving parts (one NV12 fmt) | simpler |

**Net:** the single highest-leverage change is **capturing NV12 from `rkisp_mainpath` instead of UYVY from selfpath** — it deletes `videoconvert` entirely and lets `mppjpegenc` run native. Second: move rotation to the free sensor flips and scaling to the ISP resizer (or `rgaconvert`). Third: re-enable rkaiq 3A for quality.

---

## 8. Gaps / things to verify on the live box (research limits)

- Whether `/dev/video0` on this Zero 3W maps to mainpath or selfpath (`v4l2-ctl --list-devices` / `media-ctl -d /dev/media0 -p`). Optimized path assumes mainpath NV12.
- Confirm `mppjpegenc` accepts NV12 at 1280×720 (very likely; test `video/x-raw,format=NV12,width=1280,height=720`).
- 1920×1080 is NOT 16-aligned for MPP → use 1920×1072 or 1280×720 for the encoder (the ISP can still resample 1920→1280 internally).
- The `rgaconvert` gst element is NOT on the box — needs `gstreamer-rockchip`/`gstreamer-rockchip-extra` install or build before that path is usable; otherwise use sensor flips + ISP scaling (no new packages).
- 3A enable is blocked until the CSI link is confirmed up (FPC reseat). Reference `zero3w-camera-rkaiq-3a-unlock.md` is the pre-verified map.
- Current scripts live on the board (`/usr/local/bin/printer-cam-setup.sh`, `printer-cam-http.py`) — not on this workstation; edits must happen via SSH to `radxa-zero3.local`.

## Sources
kernel rkisp1 guide (mainline, illustrative) · Rockchip ISP2x driver guide v1.0.3 · Rockchip GStreamer user guide v1.1.1 · Radxa Zero 3W accessory/camera docs · Radxa forum: "Rock 3A Camera support", "IMX219 + Rock 3A + rkaiq_3A_server", "Rotate Camera Image on Zero 3W", "dev/video01", "Radxa 8m 219 gstreamer resolution" · OV5647 datasheet · kraj/gstreamer-rockchip-extra · skill refs `zero3w-camera-*` in klipper-host-operations.
