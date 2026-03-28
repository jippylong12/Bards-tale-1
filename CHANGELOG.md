# Changelog

All notable changes to this project will be documented in this file.
Format follows [Keep a Changelog](https://keepachangelog.com/).

## [0.3.0] - 2026-03-27

### Identified (20 routines — combat system)
- `select_random_hero` — enemy AI picks a living hero to target
- `handle_battle_actions` — processes attack and rogue hide options
- `select_spell_target` — "Cast at" prompt for choosing enemy group
- `check_party_alive` — returns whether any hero still has HP
- `combat_flee_check` — compares party vs enemy speed to determine escape
- `calc_defense_rating` — effective AC from level, class, equipment, randomness
- `select_combat_target` — full target selection UI (hero numbers, group letters)
- `find_special_weapon` — searches inventory for equipped special attack item
- `calc_combat_initiative` — turn order from class, level, combat wins + randomness
- `lookup_addr_table` — resolves index to address for spell/ability dispatch
- `print_combat_actor` — prints acting hero name or enemy group letter
- `process_action_key` — generic menu key dispatcher (E/T/D/P/N keys)
- `party_disbelieve` — "The party disbelieves..." illusion check
- `spend_spell_points` — deducts spell cost (halved with certain equipment)
- `post_combat_cleanup` — removes dead heroes, reorganizes groups, resets state
- `process_special_event` — handles triggered events (lighting, bard effects)
- `find_equipped_by_type` — generic inventory search by special attack type
- `award_experience` — distributes XP by party size, increments combat wins
- `enemy_joins_party` — random enemy joins roster, prints "jumps into your party!"
- `process_bard_song` — applies song effects (stat boosts, healing, AC)

### Verified
- Binary still matches original after all renames

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
