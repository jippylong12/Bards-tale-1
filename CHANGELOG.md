# Changelog

All notable changes to this project will be documented in this file.
Format follows [Keep a Changelog](https://keepachangelog.com/).

## [0.2.0] - 2026-03-27

### Added
- Makefile for cross-platform builds (`make` / `make verify` / `make clean`)
- `.gitignore` for build artifacts

### Verified
- SjASMPlus v1.22.0 compiles cleanly on macOS ARM (Apple Silicon M3)
- Recompiled binary matches original byte-for-byte (`NO vital diffs found`)
- Build produces both `bt.tap` (ZX Spectrum tape image) and `bt.bin` (raw binary)

## [0.1.0] - 2026-03-27

### Added
- Initial import of partially reversed Bard's Tale ZX Spectrum disassembly
- 107 identified core code routines
- 61 unidentified core code routines
- City level with 40 code files (26 identified, 14 unknown)
- Full macro library (60+ RST 10h dispatch macros)
- Constants for classes, races, statuses, items, spells, directions
- Character and enemy struct offset definitions
- Data tables: monsters, spells, items, city map, icons, font
- Original binary memory dumps for verification
- Windows compile script with binary diff verification
- ROADMAP.md with milestone plan for completing reverse engineering
