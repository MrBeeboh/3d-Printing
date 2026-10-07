# SURVIVOR LOG — 2026-08-20 (Router mode: all models available, NOTHING preloaded)

## Operator request
"Make all of them available in the picker. Do not preload any of them. No models should be currently loaded. I will pick one as I feel necessary."

## Solution: llama.cpp router mode (llama-server.service, :8080, provider `local-sycl`)
The router (`llama-server-direct` launcher) serves every GGUF symlinked in `/home/mike/models/library/` with **lazy load**:
- Boot: **nothing loaded** — router parent process only (~0.1 GB RSS). Verified.
- First request to a model → router spawns a child llama-server that loads that model on demand. Verified (9B loaded in ~7.5s incl. load, then served).
- `--models-max 1`: only ONE model loaded at a time; requesting another model replaces the child (verified: 9B → 27B swap, old child gone).
- `--models-autoload` loads at boot ONLY models whose preset has `load-on-startup` — none of ours do (verified in server-models.cpp source).

## Models exposed (16 total in library; the 4 operator candidates):
| Picker name | File | Size | Notes |
|---|---|---|---|
| Qwen3.8-9B-Distill-Q4_K_M | ~/lmstudio/models/qwen38/Qwen3.8-9B-Distill-Q4_K_M.gguf | 5.78 GB | empero-ai distill of 2.4T-A95B; MMLU 0.751; **fastest (56 tok/s gen, 4.3s/10k prefill)**; no vision |
| Qwen3.8-9B-Distill-Q5_K_M | ~/lmstudio/models/qwen38/Qwen3.8-9B-Distill-Q5_K_M.gguf | 6.64 GB | same, +12% slower |
| Qwen3.5-9B-The-Defiant-Fable-Uncnr-Heretic-NEO-MAX-Q4_K_S | ~/lmstudio/models/DavidAU/...NEO-IMATRIX-MAX-MTP-GGUF/Qwen3.5-9B-...-Q4_K_S.gguf | 6.1 GB | DavidAU uncensored; ~50 tok/s; **vision only via dedicated instance (mmproj-F16 in same folder), NOT in router mode** |
| Qwen3.8-27B-Q4_K_M | ~/lmstudio/models/qwen38/Qwen3.8-27B-Q4_K_M.gguf | 17 GB | the old slow one, kept available per operator |

Other library models (Qwen3.6 family, Mistral, Nemotron, Qwen3-Next-80B, etc.) also exposed — all lazy.

## Changes made
1. **`/home/mike/.config/llama-active-model.env`** → rewritten to ROUTER mode (`LLAMA_ROUTER=1`, `LLAMA_MODELS_MAX=1`, card2). Backup: `.bak-20260820`. (Was `LLAMA_ROUTER=0` single-model 27B — would have overridden router mode.)
2. Symlinks added: `Qwen3.8-9B-Distill-Q4_K_M.gguf`, `Qwen3.8-9B-Distill-Q5_K_M.gguf` in `/home/mike/models/library/`. (27B + DavidAU links already existed; DavidAU link now valid — was dangling.)
3. **Stopped + disabled `llama-qwen38-mtp.service`** (the preload service on :51520). Started `llama-server.service` (router :8080). Ports 51520/51521 now free.
4. **config.yaml** (survivor profile): replaced `local-sycl-mtp` provider with `local-sycl` (api :8080/v1, `discover_models: true`, explicit model list: the 4 candidates, context_length 262144). Backups: `.bak-router`, `.bak-9b-swap`.
5. **models.json**: removed local-sycl-mtp entry; added/confirmed local-sycl entries: `Qwen3.8-9B-Distill-Q4_K_M` (fff0774b), `Qwen3.8-9B-Distill-Q5_K_M` (703fb1bf), `Qwen3.8-27B-Q4_K_M` (1dfc0c1b), DavidAU (003b6502). Backup: `.bak-router`.

## Revert
- Router → single-model: restore `llama-active-model.env.bak-20260820`, enable `llama-qwen38-mtp.service`.
- Picker config: restore config.yaml/models.json `.bak-router`.

## Notes / gotchas
- **Desktop app must refresh/restart** to see new provider/models (models.json + config read at startup).
- Router mode = **no vision** (mmproj per-model in router UNVERIFIED; DavidAU mmproj sits in its folder but router doesn't pair it). Vision needs a dedicated single-model instance (e.g. `llama-qwen38-9b` launcher pattern + `--mmproj`) — that preloads one model, so it conflicts with "nothing loaded"; flag if operator wants it.
- `--stop-timeout` flag exists for graceful model kill in router mode; default idle behavior leaves last-used model loaded until replaced (verified). Operator picks a model → it stays loaded until they pick another.
- Killed leftover DavidAU VL test server (pid 186579) that had survived an earlier kill (was on :51521/card1).
- Router pinned to card2 (`level_zero:1`) — card1 stays free for ComfyUI/H3 per the unit's Aug 6 comment.
