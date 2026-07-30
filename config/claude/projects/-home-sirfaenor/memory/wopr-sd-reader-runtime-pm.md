---
name: wopr-sd-reader-runtime-pm
description: "Il lettore SD interno del PC \"wopr\" (Realtek RTS525A, rtsx_pci) disconnette la scheda a intermittenza per colpa del runtime PM — fix con power/control=on"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 9424ee05-ab14-4e55-aa45-87cb09a191f5
---

Sul PC "wopr" il lettore SD interno (Realtek RTS525A PCIe, `0000:02:00.0`, driver `rtsx_pci`) fa disconnettere/riconnettere la scheda SD a intermittenza. Sintomi in `journalctl -k`: `mmc0: cannot verify signal voltage switch` ogni ~8s, `error -110 doing runtime resume`, `card removed` + re-detect.

Causa: il runtime power management sospende la scheda e al resume fallisce la rinegoziazione della tensione UHS-I (SDR104, 1.8V).

Fix (verificato 2026-07-07): `echo on > /sys/bus/mmc/devices/mmc0:aaaa/power/control` — è il device **della scheda** (subsystem mmc) quello decisivo; disattivare il PM solo sul device PCI non basta. Reso permanente con `/etc/udev/rules.d/99-sdcard-no-pm.rules` (regole su SUBSYSTEM mmc e sul PCI 10ec:525a).

Nota: sudo su wopr usa il lettore di impronte ma via `!` va spesso in timeout; `pkexec` (dialogo grafico polkit) funziona più affidabilmente per i comandi root.
