# 2026-08-28 — Survivor: local models missing from provider dropdown / local models "not working"

## Symptom (Michael)
- Provider/model dropdown did not show all local models (only 1: `Qwen3.8-9B-Distill`).
- Selecting a local model failed ("local models do not work") — despite a fix earlier today.

## Root cause (verified, not guessed)
The desktop app runs ONE `serve` process per profile; the model picker (GET /api/model/options →
`build_model_options_payload` → `list_authenticated_providers`) reads the **active chat profile's** config.

- The earlier fix (20:41–20:45) worked in the **default** profile: `custom` provider → llama-server
  router `http://127.0.0.1:8080/v1` (11 models listed, chat completion verified).
- The **survivor** profile config (`/home/mike/.hermes/profiles/survivor/config.yaml`) still pointed
  `local-sycl` at `http://127.0.0.1:51520/v1` with ONE model (`Qwen3.8-9B-Distill`).
  **Nothing listens on :51520** → dropdown showed 1 model, and using it failed.
- Reproduced with the exact GUI code path: `local-sycl: api_url=http://127.0.0.1:51520/v1, total_models=1`.

## Fix applied
`hermes --profile survivor config set ...` (config file: `/home/mike/.hermes/profiles/survivor/config.yaml`):
- `providers.local-sycl.api` / `base_url` → `http://127.0.0.1:8080/v1` (live router)
- `key_env` → `HERMES_CUSTOM_LOCAL_SYCL_API_KEY` (present in ~/.hermes/.env); removed stale `api_key: sycl-router`
- `model` (default) → `Qwen3.8-9B-Distill-Q6_K`
- `models` → all 10 chat models from the router catalog with context_lengths
  (Mistral-Small-3.2-24B 131072; Qwen3-VL-30B 131072; Qwen3-Next-80B, Qwen3.8-27B(-UD/-Uncensored),
  Qwen3.6-35B, Qwen3.6-27B-Fable, Ornith-1.5-35B, Qwen3.8-9B-Distill-Q6_K 262144)

`load_config()` is mtime-cached → serve process picks change up without restart.

## Verification
- `build_model_options_payload(load_picker_context(), refresh=False)` (exact GUI path, survivor context):
  `local-sycl: api_url=http://127.0.0.1:8080/v1 | 10 models` (all listed).
- Live endpoint test: `POST :8080/v1/chat/completions` model Qwen3.8-9B-Distill-Q6_K →
  `LOCAL_OK`, 0.98 s total, ~54 tok/s prompt. mmproj correctly absent from static list.

## Notes for cloud team
- llama-server on :8080 is systemd-user `llama-server.service` (via ~/.local/bin/llama-server-direct).
  `LLAMA_MODELS_MAX=1` in ~/.config/llama-active-model.env is INTENTIONAL (one resident model, prevents
  VRAM overcommit) — router still lists all models. Do not "fix" it back to 8 without Michael's go.
- ORPHAN: llama-server pid 46501 on :54981 (Qwen3.8-9B-Distill-Q6_K, ~3.4 GB RSS) — nothing in any
  config references :54981. Leftover test instance; candidate for kill (ask Michael).
- Survivor system prompt still documents :51520 on-demand launcher (survivor-launch) — now redundant
  since survivor config uses the :8080 router; consider updating survivor-launch later.
