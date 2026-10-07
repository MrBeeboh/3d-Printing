# SURVIVOR LOG — 2026-08-19 (Qwen3.8 speed investigation)

## Context
Michael reported responses felt slower than the ~27–31 tok/s benchmark in `qwen38-hermes-optimization` skill §2b. Investigated live on :51520.

## Findings (measured, b10430 build)
| Test | Result |
|---|---|
| 64-token completion, short prompt | 3.2s wall → **~20 tok/s** decode (MTP active, no contention; only `llama-qwen38-mtp.service` running on card2, ollama has no models loaded) |
| ~10k-token context first eval | **14.5s** for the whole request (~700 t/s prompt-eval — that's fine), but this is what makes agent turns feel slow: every turn re-sends growing conversation + tool outputs, and cache-reuse (256) is auto-disabled because mmproj/VLM loaded |
| Same 10k context immediately repeated | **0.8s** total → KV cache reuse works when the prefix repeats; cold prefixes are the cost driver |

So: decode speed ≈ ~20 tok/s steady, not a regression from contention (orphan-instance bug did NOT recur). The "slower than I can read" feel is dominated by (a) long-context prompt eval per turn as sessions grow and (b) my thinking tokens before answering. Not a driver fault this time — the xe GT reset noise in dmesg was from an earlier unrelated crash of `auto-cpufreq` process, not llama-server; MTP service has been up continuously since 16:40 today.

## Q4_K_S experiment — DEAD (documented pitfall)
Downloaded unsloth/Qwen3.8-27B-GGUF → Qwen3.8-27B-UD-Q4_K_S.gguf (~14 GiB). **Segfaults on load+first matmul** before generating a single token, reproducible on BOTH Arc cards (level_zero:0 and :1), with/without `SYCL_PI_LEVEL_ZERO_USE_ASYNC_EXECUTION=0`.

GDB backtrace (repro):
```
#0  0x00000000 in ?? ()   ← null pointer call
#1  ur_command_list_manager::isGraphCaptureActive()  libr_adapter_level_zero_v2.so.0
...
#6  sycl::_V1::ext::oneapi::experimental::async_free(handler&, void*)  libsycl.so.9
#7  queue_impl::submit_impl(...) → #8 queue::submit_without_event_impl
#9  async_free(queue const&, void*, ...)   ← called during EVERY submit when not graph-capturing
#10 reorder_qw(ggml_tensor const*, sycl::queue*)    libggml-sycl.so.0 (llama.cpp b10430)
#11 ggml_sycl_mul_mat → #12 ggml_backend_sycl_graph_compute_impl ... llama_decode during server load test
```
Diagnosis: **Intel oneAPI 2026.1 runtime bug** — the experimental `async_free` path (enabled by default in this libsycl build) null-dereferences inside the level-zero v2 adapter on Q4_K_S tensor layouts, while Q4_K_M works fine with identical flags. Not a corrupt download: header parses byte-for-byte identically to known-good K_M (same arch `qwen35`, same KV layout), GGUF magic OK.

**File deleted after diagnosis** (`/home/mike/.lmstudio/models/qwen38/Qwen3.8-27B-Q4_K_S.gguf`) — 15 GiB freed. If a future llama.cpp build or oneAPI update ships, re-test before assuming K_S is permanently unusable; the bug may be in either side (llama.cpp's `reorder_qw` async_free call pattern vs Intel adapter).

## Speed levers actually available right now
1. **Newer llama.cpp builds** — each release often improves Gated DeltaNet/MTP paths on SYCL; re-benchmark after any update (§2b matrix in the skill is the baseline to beat: single-GPU+MTP = 31 tok/s).
2. **Drop mmproj if vision isn't needed for a session** → `--cache-reuse 256` becomes active again (currently no-op with VLM loaded) → repeated long prefixes re-eval much cheaper. Trade-off: lose inline image understanding. Not done — needs operator go-ahead since it changes deployed behavior of the MTP service.
3. **Keep sessions shorter / prune old context** — cold-prefix prompt eval is the dominant latency as conversations grow; decode itself holds ~20 tok/s regardless of history length once evaluated.

## Status
- `llama-qwen38-mtp.service` (:51520, card2) healthy and unchanged since 16:40 today — do not restart unnecessarily (restart re-pays the load cost).
- No config changes made during this investigation except deleting the broken K_S file.
