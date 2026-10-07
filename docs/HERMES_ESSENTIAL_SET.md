# Hermes — Minimal Essential Set (documented only, no changes made)

**Date:** 2026-08-24 · **Version:** v0.20.5 (2026.8.19)

Hermes bundles ~54 plugins with the core install; they are **opt-in by default**.
Only the ones below are enabled and load. Everything else is inert — no cleanup needed.

## Enabled plugins (the wheat)

| Plugin | Purpose | Config ref |
|---|---|---|
| `image_gen/fal` | Image generation via FAL.ai (FLUX 2 Pro) | `image_gen.provider = fal`, model `fal-ai/flux-2-pro` |
| `platforms/a2a` | Bot-to-bot DMs across machines/gateways | `a2a_agents.*` → bots on `127.0.0.1:9900` |

## Bots (A2A roster) — all routed through :9900

| Bot | Role / capabilities |
|---|---|
| foreman | routing, orchestration, kanban, digest |
| engineer | build, wiring, ArduPilot, RTK, electronics |
| researcher | research, sourcing, specs, market-data |
| brim | 3D-print, OrcaSlicer, Klipper, OpenSCAD |
| survivor | offline, local-model, fallback |

## Disabled (bundled, inert — leave alone)

52 bundled plugins are already disabled. Do **not** delete them from disk — the framework references them and deleting risks the install. They stay out of the way unless you explicitly enable one:

`hermes plugins list` → shows all 54 with enabled/disabled status.
Enable on demand: `hermes plugins enable <name>` (e.g. `image_gen/xai`, `telegram-platform`).

## Two commands are your index

```bash
hermes tools list      # toolsets (enabled/disabled)
hermes plugins list    # all plugins + descriptions
```

## Known stale reference (NOT changed — flag only)

- `video_gen` in config points at provider `comfyui-h3`, but the `video_gen/comfyui`
  plugin is **not** in the enabled list. If video gen stops working, either enable
  `hermes plugins enable video_gen/comfyui` or set a different provider. Left as-is per request.

## Reference docs

https://hermes-agent.nousresearch.com/docs
