# Configs — staged for deployment to the Zero 3W

These are the reference config files for the stock-board Ender-3 V3 SE Klipper setup, staged here so printer-arrival day is copy-and-go.

## Files

| File | Source | Purpose |
|---|---|---|
| `printer-creality-ender3-v3-se-2023.cfg` | 0xD34D/ender3-v3-se-klipper-config | Main printer config → becomes `printer.cfg` on the host |
| `prtouch.cfg` | 0xD34D/ender3-v3-se-klipper-config | Pressure-touch (CR Touch style) probe module |
| `macros.cfg` | shubham0x13/ender-3-v3-se-klipper | PRINT_START, load/unload, Z-offset, bed mesh macros |

Sources per the jpcurti fork's official doc: `e3v3se_docs/configuration.md`.

## Deploy (arrival day)

On the Zero 3W (`root@radxa-zero3.local` or `192.168.0.18`):

```sh
# 1. Main config + probe module
cp printer-creality-ender3-v3-se-2023.cfg ~/printer_data/config/printer.cfg
cp prtouch.cfg ~/printer_data/config/prtouch.cfg
echo '[include prtouch.cfg]' >> ~/printer_data/config/printer.cfg

# 2. Display support (jpcurti fork)
cat >> ~/printer_data/config/printer.cfg <<'EOF'
[e3v3se_display]
language: english
logging: False
EOF

# 3. Macros
cp macros.cfg ~/printer_data/config/macros.cfg
echo '[include macros.cfg]' >> ~/printer_data/config/printer.cfg

# 4. Verify serial path matches the plugged-in printer:
ls -l /dev/serial/by-id/
# Expected: usb-1a86_USB_Serial-if00-port0 (CH340 on stock board)
# Edit ~/printer_data/config/printer.cfg [mcu] serial: if it differs.

# 5. Restart
systemctl restart klipper
```

## Notes

- The staged `[mcu] serial:` is `usb-1a86_USB_Serial-if00-port0` (CH340) — **verify against the actual device** after plugging in the printer; revise if the by-id name differs.
- Flash the printer-side firmware first (see `docs/printer-arrival.md`) or klippy will find no MCU.
- Optional: add `[e3v3se_display MACROn]` entries to put macros on the printer screen (see jpcurti `e3v3se_docs/configuration.md`).
