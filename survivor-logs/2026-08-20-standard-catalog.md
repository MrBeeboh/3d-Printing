# 2026-08-20 — back to standard catalog

Operator: stop inventing extra plumbing. Models in local-sycl. Pick in Hermes. Nothing preloaded. Do not strip vision.

Done:
- llama-qwen38-mtp.service stays disabled (was a dedicated preload)
- llama-server.service :8080 is the catalog
- LLAMA_MODELS_MAX=8 (was 1 — that was the restriction)
- vision models in library subdirs so mmproj attaches: Qwen3.8-27B, DavidAU 9B, Qwen2.5-VL-3B
- distill Q4/Q5 in library as normal files
- all models listed as unloaded
- distill keys added to ~/.hermes/config.yaml local-sycl
