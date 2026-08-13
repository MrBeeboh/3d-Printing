# Fusion CAD + Cursor MCP (HAL2026)

Handoff from 2026-08-12. This is **not** Atom Chat work. Continue in a **new Cursor chat** with workspace `Documents/3d_Printing/` (or this file open). Do not mix with `/home/mike/atom-chat`.

## Goal

Drive Autodesk Fusion from Cursor on **HAL2026** (Linux Mint) to design 3D-print parts for the Ender-3 V3 SE. Fusion does **not** run on Linux. Live modeling uses Fusion’s **local desktop MCP** on a Windows mini PC, tunneled to HAL.

## Machines

| Machine | OS | Role |
|---|---|---|
| **HAL2026** | Linux Mint | Cursor / Grok. Does **not** run Fusion. |
| **KAMRUI Pinova P2** | Windows 11 (required: 23H2+) | Fusion desktop only. MCP host. |

### Pinova P2 (Fusion box)

- **CPU:** AMD Ryzen 3 7330U (Zen 3 Barcelo-R), 4C/8T, 2.3–4.3 GHz, 15 W
- **GPU:** Radeon Vega 6 (shared). Fine for one part; skip Render / Manufacture sim
- **RAM:** 16 GB — good hobby floor
- **Disk:** 256 GB SSD — tight; keep Windows + Fusion only; designs can stay in Autodesk cloud
- **Verdict:** Good enough for single 3D-print parts (brackets, mounts, housings). Above Autodesk Windows minimum (8 GB RAM, 2C/4T). Not for large assemblies.

**Keep Fusion light on the mini PC**

- Do **not** install Cursor or a local LLM on the Pinova. HAL runs the agent.
- One component, short timeline — not 200-part assemblies
- One 1080p or 1440p monitor, 100% scale, standard canvas graphics
- Do **not** use the triple-4K capability for Fusion
- Skip Manufacture simulation and Render

## Why not HAL, Grok Build, or Fusion web

- Autodesk Fusion is **Windows + macOS only**. No native Linux. Wine is unsupported and a bad MCP bet.
- Local Fusion MCP needs the **desktop** app, not the web client. It is **localhost-only** (no auth).
- **Grok Build / grok.com** cannot reach `127.0.0.1` on HAL or the mini PC.
- **Fusion Data MCP** (cloud) works from Linux but is hubs/projects/folders — **not** the 3D model.
- Fusion’s built-in Assistant is fine for a one-off cube; use Cursor on HAL for iterating print parts with files/git.

## Intended setup (not done yet)

1. Pinova: Windows 11, Fusion installed, document open.
2. Fusion → **Preferences → General → API** → enable **Fusion MCP Server** (default port **27182**).
3. From HAL:

```bash
ssh -L 27182:127.0.0.1:27182 user@pinova
```

Replace `user@pinova` with the real Windows SSH user/host. Do **not** bind `27182` on the LAN.

4. HAL Cursor → Settings → Tools & MCP → add:

```json
{
  "mcpServers": {
    "fusionMCP": {
      "url": "http://127.0.0.1:27182"
    }
  }
}
```

5. New Agent chat in the **3d_Printing** workspace (not atom-chat). Ask to inspect the active Fusion document before any edits.

Docs: https://help.autodesk.com/view/fusion360/ENU/?guid=FMCP-OVERVIEW

## Fallback if MCP is not up

Export STEP / STL / 3MF from Fusion on the Pinova. Work those files here (slicer, mounts, dimensions). No live timeline edits.

## Status

- [x] Pinova P2 judged OK for hobby Fusion
- [ ] Fusion installed on Pinova
- [ ] MCP enabled in Fusion
- [ ] SSH from HAL to Pinova
- [ ] Cursor MCP entry on HAL
- [ ] First read-only inspect of an open document
