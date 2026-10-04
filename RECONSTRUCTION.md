# SV08 Max, reconstructed

This fork adds what `Sovol3d/SV08MAX` doesn't carry: Sovol's own Klipper history for the SV08 Max, every SV08 Max OTA package found on Sovol's server, and the Klipper tree each package shipped. Sovol's `main` is left as published.

## Branches and tags

| Ref | What it is |
|---|---|
| `main` | `Sovol3d/SV08MAX` as published: a June 2025 snapshot of a Max's `/home/sovol`, without history |
| `reconstruction` | `main` plus this file |
| `klipper/vendor` | Sovol's internal Klipper repository for the SV08 Max, branch `klipper-eddy_contact_probe`: 97 commits from `a6dc07c` "first commit for sv08mini" to `d4031b3` (2025-10-18), with the original hashes, authors, dates and messages |
| `klipper/shipped` | the Klipper tree in each OTA package, one commit per package |
| `ota/packages` | every SV08 Max OTA package found, unpacked, one commit per package, oldest first |
| `shipped/<version>` | the Klipper tree in that package |

## Where the history comes from

Every SV08 Max package from 2025-02-21 on ships `/home/sovol/klipper` with its `.git`. The 2025-10-18 package (2.1.9) has 104 commits and contains every commit from every earlier package, so nothing was rewritten between releases. Its branch `klipper-eddy_contact_probe` is the Max line.

The first 49 commits are shared with the Sovol Zero and end at the Zero's 1.3.7 release, `cc8afd8`. The Max line branches there on 2025-01-24 (`45f7046`, "add eddy contact homing"). The same `.git` also carries the Zero's own main branch to its 1.4.5; that is left out here, since it's on `rpcyan586/SOVOL-ZERO` and `sharkovich/sovol-zero-klipper`.

The `klippy/` in `Sovol3d/SV08MAX` matches the vendor commits from `181d7aa` "1.9.3" (2025-05-09) to `ae62c9f` (2025-05-26). The history continues past it to 2025-10-18.

Every commit on `klipper/vendor` is Sovol's original object, so it can be checked against a Max:

```
cd ~/klipper
git log -1 --format=%H
git cat-file -e d4031b3 && echo present
```

## Versions

A package's version is the `version=` line in `home/sovol/printer_data/build/.version.cfg`. The Debian control version is `0.1.0` in every package, and `menu.cfg` says 1.0.0 throughout, so neither identifies a release.

| Package | Version | Klipper HEAD in the package | Uncommitted in the package |
|---|---|---|---|
| 2025-02-18 | 1.0 | none; the code is the Zero's 1.3.7 `cc8afd8` plus `menu.cfg` | — |
| 2025-02-21 | 1.1 | `c79d176` 2025-02-21 | menu.cfg |
| 2025-02-24 | 1.3.0 | `c79d176` 2025-02-21 | menu.cfg |
| 2025-02-26 | 1.4.0 | `55e75e4` 2025-02-26 | menu.cfg |
| 2025-02-28 | 1.4.3 | `f33eb5e` 2025-02-28 | menu.cfg |
| 2025-03-03 | 1.4.8 | `f33eb5e` 2025-02-28 | menu.cfg |
| 2025-03-07 | 1.5.0 | `f33eb5e` 2025-02-28 | menu.cfg |
| 2025-03-08 | 1.5.1 | `f33eb5e` 2025-02-28 | menu.cfg |
| 2025-03-11 | 1.5.2 | `f33eb5e` 2025-02-28 | menu.cfg, gcode_move.py |
| 2025-03-12 | 1.5.3 | `f33eb5e` 2025-02-28 | menu.cfg, gcode_move.py |
| 2025-03-14 | 1.5.5 | `feaa25d` 2025-03-14 | menu.cfg, gcode_move.py |
| 2025-03-17 | 1.5.7 | `9490d5a` 2025-03-15 | menu.cfg, gcode_move.py |
| 2025-03-20 | 1.6.0 | `be024d5` 2025-03-20 | menu.cfg, gcode_move.py |
| 2025-03-24 | 1.6.3 | `aa34ee6` 2025-03-24 | — |
| 2025-03-28 | 1.6.5 | `aeb4421` 2025-03-28 | — |
| 2025-03-31 | 1.6.8 | `aeb4421` 2025-03-28 | — |
| 2025-04-07 | 1.7.2 | `f5cf3f0` 2025-04-07 | — |
| 2025-04-10 | 1.8.0 | `50658f7` 2025-04-10 | — |
| 2025-04-11 | 1.8.1 | `824b9ca` 2025-04-11 | — |
| 2025-04-12 | 1.8.2 | `824b9ca` 2025-04-11 | — |
| 2025-04-14 | 1.8.3 | `b551f98` 2025-04-14 | — |
| 2025-04-15 | 1.9.0 | `35a60be` 2025-04-15 | — |
| 2025-04-16 | 1.9.1 | `ccf1ab8` 2025-04-16 | — |
| 2025-04-18 | 1.9.2 | `f288f06` 2025-04-18 | — |
| 2025-05-09 | 1.9.3 | `119b2b1` 2025-05-09 | — |
| 2025-05-14 | 1.9.8 | `cfcf030` 2025-05-13 | — |
| 2025-06-13 | 2.0.9 | `ae62c9f` 2025-05-26 | bed_mesh.py, queuelogger.py |
| 2025-06-27 | 2.1.4 | `f80d36c` 2025-06-27 | — |
| 2025-10-18 | 2.1.9 | `d4031b3` 2025-10-18 | — |

So the Max's 1.0 package shipped the Zero's 1.3.7 Klipper, and its own branch first reached printers in 1.1. From 1.4.0 every package also ships `src/UC1701.c`, `src/UC1701.h`, `src/ws2811.c` and `src/ws2811.h`, the screen and LED drivers that commit `55e75e4` removed from the branch.

## About the reconstructed commits

`klipper/shipped` and `ota/packages` are my commits, not Sovol's. Each is dated to the newest file in its package, so `git log` follows Sovol's timeline, and each message carries the package's SHA-256 and the HEAD and uncommitted edits of the package's own `.git`.

`klipper/shipped` is each package's Klipper files as shipped, with Python caches left out. The packages don't ship `lib/`, so neither does this line. The 1.0 commit has the Zero's `cc8afd8` as its parent.

`ota/packages` is each package as unpacked: installed files at their install paths, control files and maintainer scripts under `DEBIAN/`. Three things are left out of every package: its Klipper `.git`, which is `klipper/vendor`; the touchscreen app's compiler intermediate `zhongchuang/build/src/libsrc.a`, 27 MB per build (the program itself, `zhongchuang/build/zhongchuang_klipper`, is kept); and Moonraker's database files, which are withheld.

## What's in the packages

Besides Klipper: Mainsail, Sovol's printer configs (`printer_data/config`, `patch/`), the power-loss recovery scripts (`plr.sh`, `clear_plr.sh`), the touchscreen program and its display image (`众创klipper.tft`), `root/mcu_update.sh`, and `root/klipper.bin`, an STM32F401 Klipper build from 2024-02-18 (`v0.12.0-113-g28f06a10-dirty`, built on a host named `mkspi`) that predates this history.

The touchscreen program's source is in `main` under `home/sovol/zhongchuang/`, as Sovol published it in June 2025. The packages carry only its builds.

## Licensing

Klipper and Mainsail are GPL-3.0; see `COPYING` on the Klipper branches. Sovol's touchscreen program, configs and scripts carry no licence statement. They are here as shipped, for reference, and this repository grants no licence over them.
