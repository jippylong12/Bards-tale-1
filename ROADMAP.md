# Bard's Tale ZX Spectrum - Reverse Engineering Roadmap

## Project Overview

Partial reverse engineering of **The Bard's Tale** (1988 ZX Spectrum port).
Z80 assembly, compiled with SjASMPlus. Original work done 2020-2022.

## Current State (v1.0.0)

The codebase contains a disassembly of the full game binary (`$5B00-$FFFF`) with the
original memory dumps in `original/` for byte-level verification.

### What exists

- **107 identified code files** — routines with meaningful names (e.g. `fight_or_run`,
  `process_spell`, `create_char`, `movement`)
- **61 unidentified core code files** — labeled `___UNKNOWN`
- **24 unidentified city/level code files** — in `levels/city/`
- **Full macro library** — 60+ macros wrapping the RST 10h dispatch system
- **Constants defined** — character classes, races, statuses, time-of-day, directions,
  icons, screen addresses, character struct offsets, enemy struct offsets
- **Data tables** — monsters, spells, items, spell costs, light durations, summon
  creatures, city map, icons, font data
- **Compile script** (Windows `.bat`) with binary diff verification against original
- **Original binary dumps** for verification

### What works

- The assembly is structurally complete — all addresses from `$5B00` to `$FFFF` are
  accounted for in the include chain
- Binary diff verification exists to confirm recompiled output matches original
- Compilation has not been verified on macOS yet

### What doesn't work / is missing

- No macOS/Linux build script (only `_compile_bt.bat` for Windows)
- 85 routines across core + city code remain unidentified
- Many game variables (`VAR_00` through `VAR_76`) are unnamed
- Many character/enemy struct offsets are unnamed (`CHAR_12`, `ENEMY_10`, etc.)
- Several data tables are unnamed (`___table_83` through `___table_95`)
- No dungeon levels included (only `levels/city/`)
- No documentation of the RST 10h dispatch system
- No cross-reference map of which routines call which

---

## Milestones

### v0.2.0 — Build & Run on macOS (DONE)

- [x] Create cross-platform build script (Makefile)
- [x] Verify SjASMPlus compiles cleanly on macOS/ARM (v1.22.0)
- [x] Create `recompile/` output directory if missing
- [x] Verify binary diff against original dumps passes
- [x] Add `.gitignore` for build artifacts
- [x] Document emulator setup (Fuse for macOS) in README

### v0.3.0 — Reverse Engineer Combat System (19 files) (DONE)

All 19 combat routines identified, renamed, and verified.

- [x] `6746-680C` — calculate_combat_initiative
- [x] `680D-6857` — select_random_hero (enemy targeting)
- [x] `6977-69B7` — handle_battle_actions (attack/hide)
- [x] `6A03-6A26` — select_spell_target
- [x] `6A27-6A48` — check_party_alive
- [x] `6A66-6AC5` — combat_flee_check
- [x] `6ACC-6B23` — calc_defense_rating
- [x] `6BC2-6C82` — select_combat_target (UI)
- [x] `6D05-6D2B` — find_special_weapon
- [x] `7144-719A` — lookup_addr_table (spell/ability dispatch)
- [x] `719B-71AF` — print_combat_actor
- [x] `73A6-73E7` — process_action_key (menu key handler)
- [x] `7906-794C` — party_disbelieve (illusion check)
- [x] `794D-7966` — spend_spell_points
- [x] `7967-7A31` — post_combat_cleanup
- [x] `7A67-7A9D` — process_special_event
- [x] `7A9E-7AB7` — find_equipped_by_type
- [x] `7F79-7FB2` — award_experience
- [x] `7FB3-7FF1` — enemy_joins_party
- [x] `7FF2-8064` — process_bard_song

### v0.4.0 — Reverse Engineer Encounter Generation (4 files) (DONE)

- [x] `656A-65FE` — generate_encounter
- [x] `669A-6705` — enemy_group_advance
- [x] `5C17-5C50` — calc_xp_thresholds
- [x] `64CA-64DB` — check_item_effect

### v0.5.0 — Reverse Engineer Character/Party System (14 files) (DONE)

- [x] `7590-75A4` — check_spell_cost
- [x] `75A5-75BE` — use_and_break_item
- [x] `75BF-7624` — calc_armor_class (Monk level bonus, equipped weapon/shield)
- [x] `7625-7638` — recalc_party_ac
- [x] `7639-7663` — add_item_to_hero (class equip eligibility)
- [x] `76B9-76EC` — calc_xp_for_level (per-class thresholds)
- [x] `771C-773B` — add_to_bcd_number (12-digit BCD math)
- [x] `7766-7779` — check_heroes_alive
- [x] `77B0-77D7` — store_bcd_and_compare (overflow check)
- [x] `7828-78A7` — summon_creature (enemy becomes ally)
- [x] `78A8-78CB` — apply_anti_magic
- [x] `78CC-78D9` — process_dungeon_step
- [x] `7DB8-7DF8` — regenerate_hp_sp
- [x] `7DF9-7E37` — regen_equipped_effects

### v0.6.0 — Reverse Engineer Magic/Damage System (8 files) (DONE)

- [x] `7AB8-7BEC` — calc_attack_damage (melee: weapon, AC, class, Monk/Hunter specials)
- [x] `7BF4-7C4D` — calc_enemy_attack (monster attack vs hero)
- [x] `7C4E-7CD2` — apply_damage_to_group (kill enemies, shift survivors)
- [x] `7CD3-7DB3` — apply_damage_to_hero (death, stoning, poison, level drain, possession)
- [x] `819B-81D4` — check_spell_valid (caster type vs spell class validation)
- [x] `81D5-82BD` — resolve_spell_effect (full spell resolution + damage output)
- [x] `82BE-82D1` — tick_spell_duration (decrement timer, cleanup on expire)
- [x] `82D7-82FB` — start_spell_or_song (init duration, store ID, activate)

### v0.7.0 — Reverse Engineer Spell Effect Handlers (8 files) (DONE)

Note: originally labeled "dungeon" — turned out to be spell effect dispatch targets.

- [x] `8314-8412` — spell_breath_attack (area damage + status effects)
- [x] `8413-8496` — spell_stat_modifiers (AC/defense/attack buffs)
- [x] `8497-8517` — spell_heal_and_cure (HP restore, cure poison/paralysis/nuts)
- [x] `851A-85EB` — spell_summon_monster (create ally from summon table)
- [x] `85EC-8606` — calc_monster_hp (HP from spec table + random)
- [x] `8607-861A` — spell_reveal_secret (underground secret passage reveal)
- [x] `861B-8625` — spell_flee_effect (spell-assisted escape)
- [x] `8626-8648` — spell_ac_modifier (party/enemy AC buff/debuff)

### v0.8.0 — Reverse Engineer Remaining Core + Print/Display (7 files) (DONE)

- [x] `8649-86A9` — show_location_info ("You face East, in Skara Brae" / dungeon coords)
- [x] `86AA-86C4` — spell_attack_bonus (attack power buff)
- [x] `8778-87B4` — adjust_value_updown (UI: +/- value selector)
- [x] `8889-8895` — roll_damage_dice (B random d4 rolls added to HL)
- [x] `88E5-890C` — print_large_number (multi-digit formatted output)
- [x] `890D-891C` — toggle_speed_flag (animation speed toggle)
- [x] `C00A-C038` — print_item_name_padded (right-pad item name to 11 chars)

### v0.9.0 — Reverse Engineer City/Level Code (14 files) (DONE)

All code UNKNOWN files now identified. Only data/table UNKNOWN files remain.

- [x] `C18C-C19D` — movement_dispatch (entry routing for movement/sinister events)
- [x] `E4F4-E50C` — shift_price_buffer (BCD right-shift for price display)
- [x] `E50D-E54B` — display_inventory_list (show items with equip markers + prices)
- [x] `E54C-E561` — get_inventory_selection (validate 1-8 item choice)
- [x] `E5F3-E5FF` — format_item_price (price display formatting helper)
- [x] `E8A8-E8BB` — compare_char_attrs (4-byte attribute block comparison)
- [x] `E8BC-E8CB` — copy_char_params (save/restore params during class change)
- [x] `EBAB-EBB3` — adjust_stat_floor (subtract with zero floor + add)
- [x] `EBB4-EBC2` — add_16bit_carry (16-bit addition with carry propagation)
- [x] `EF70-EFD1` — proc_sinister_street (evil magic encounter on Sinister Street)
- [x] `EFD2-F13E` — render_3d_view (core 3D dungeon rendering engine)
- [x] `F13F-F178` — display_walls_creatures (wall/creature layer rendering)
- [x] `F1A9-F258` — render_sprite_3d (3D sprite decoder and renderer)
- [x] `F259-F28E` — decode_sprite_mask (pixel transparency mask decoder)

### v1.0.0 — Code Identification Complete (DONE)

All 75 code UNKNOWN routines identified and renamed.

- [x] Verify final binary still matches original

---

## Milestone 2: Documentation & Naming Cleanup (v1.1.x)

Completing the remaining symbolic naming so the source reads like real code,
not hex offsets. Each patch version is independently verifiable.

### v1.1.0 — Name Game Variables (70 unnamed) (DONE)

- [x] Traced and named all 70 `VAR_xx` game variables in `constants.asm`
- [x] Updated all references across 100+ assembly files
- [x] Verified binary matches after all renames

### v1.2.0 — Name Character & Enemy Struct Offsets (12 unnamed) (DONE)

- [x] Named 7 CHAR offsets: SPEED, SAVED_STATS, ATTACK_SPEC, DEFENSE_SPEC, SPECIAL_FLAG, BACKUP_PARAMS, SWAP_STATS
- [x] Named 5 ENEMY offsets: ACTIVE_FLAG, COMBAT_DATA, SPEED, ATTACK_SPEC, SPECIAL_FLAG
- [x] Verified binary matches

### v1.3.0 — Name Data Tables & Macros (31 unnamed) (DONE)

- [x] Named 13 `___table_xx` → spell state trackers, combat flags, key codes
- [x] Named 18 `RST_10_xx` macros → meaningful dispatch names (CHECK_FLEE_RESULT, SELECT_TARGET, etc.)
- [x] Verified binary matches

### v1.4.0 — Architecture Documentation (DONE)

- [x] ARCHITECTURE.md: RST 10h dispatch system
- [x] ARCHITECTURE.md: Memory map ($0000-$FFFF)
- [x] ARCHITECTURE.md: Character struct (100 bytes, all fields)
- [x] ARCHITECTURE.md: Enemy struct
- [x] ARCHITECTURE.md: Combat flow diagram
- [x] ARCHITECTURE.md: Spell system + effect dispatch
- [x] ARCHITECTURE.md: 3D rendering pipeline

### v1.5.0 — Cross-Reference Map (DONE)

- [x] CROSS_REFERENCE.md: All 80+ spells mapped to effect handlers
- [x] CROSS_REFERENCE.md: City location dispatch table
- [x] CROSS_REFERENCE.md: Main game loop call graph
- [x] CROSS_REFERENCE.md: Full combat call graph

### v1.6.0 — Source-Derived Game Guide & Easter Eggs

Game knowledge extracted directly from the assembly — real numbers, hidden
mechanics, and secrets that aren't in any manual.

- [x] `guide/EASTER_EGGS.md` — hidden mechanics, secrets, oddities found in the code
- [x] `guide/COMBAT.md` — damage formulas, initiative, class advantages, flee mechanics
- [x] `guide/CLASSES.md` — per-class breakdown with actual stat scaling from source
- [x] `guide/MAGIC.md` — spell system deep dive, costs, durations, which spells stack
- [x] `guide/EXPLORATION.md` — city layout, dungeon tips, encounter rates, day/night
- [x] `guide/ITEMS.md` — equipment system, special weapon types, breakage chances
- [x] `guide/LEVELING.md` — XP formulas per class, level thresholds, stat growth

---

## File Inventory

| Category | Identified | Unknown | Total |
|----------|-----------|---------|-------|
| Core code | 107 | 0 | 107 |
| City/level code | 40 | 0 | 40 |
| Data files | — | 26 | 26 |
| Tables | — | — | 12 |
| Graphics | — | — | 2 |
| **Code Total** | **147** | **0** | **147** |

---

## Milestone 3: Game Enhancements — Tiered by Feasibility

Once we modify actual assembly instructions, the binary will no longer
match the original. Verification shifts to: compile + load in emulator +
smoke test.

**Constraints discovered during analysis:**
- Only ~181 bytes of free space in the binary ($FA9B-$FB50)
- Total RAM: 48K, game uses 42K ($5B00-$FFFF)
- All addresses are hardcoded — inserting code shifts jump targets
- Self-modifying code is used throughout
- No native ZX Spectrum → ARM port has ever been done

### Verification Strategy (post-v1.x)

1. Build with `make` — must compile without errors
2. Load `recompile/bt.tap` in Fuse — must boot to Guild
3. Smoke test: create character, walk around, enter combat, cast spell
4. Regression: specific feature being changed must work as intended

---

### v2.x — Low-Hanging Fruit (small byte changes, proven safe)

These modify only a few bytes each and don't require new routines.

#### v2.0.0 — Add WASD Movement Support (DONE)

- [x] Add W = forward, S = kick/back, A = turn left, D = turn right
- [x] Keep I/J/K/L working (legacy controls preserved)
- [x] 31 bytes used in free space at $FA9B (150 remaining)
- [x] Smoke tested: WASD and IJKL both work in city

#### v2.1.0 — Reduce Encounter Rate (DONE)

- [x] Changed first ambush threshold from 3Fh to 7Fh (1 byte at $5B19)
- [x] Encounter rate: 1/8192 per step (was 1/4096) — half as frequent
- [x] Smoke tested: noticeably fewer random encounters while walking

#### v2.2.0 — Speed Up Combat Animations

The `change_speed` routine uses a delay loop. Reduce the default
combat speed value from 5 to 2 (1 byte change in INIT_GAME).

- [ ] Change VAR_COMBAT_SPEED initial value
- [ ] Smoke test: combat text appears faster

#### v2.3.0 — Disable City Monsters Cheat as Toggle

The NOCITYMONSTERS define already exists but requires recompilation.
Add a runtime toggle key (e.g. F1) that sets VAR_AMBUSH_FLAG to
skip combat in the city.

- [ ] Hook a key check in the main loop (~10 bytes in free space)
- [ ] Toggle a flag that bypasses city_ambush
- [ ] Smoke test: press key, walk around, no encounters

#### v2.4.0 — Show Coordinates on Screen

The `show_location_info` routine already prints "You face [direction]"
but only when you press a specific key sequence. Add persistent
coordinate display.

- [ ] Add coordinate print call after each movement
- [ ] Uses existing show_location_info code, just called more often
- [ ] Smoke test: coordinates update as you move

---

### v3.x — Medium Difficulty (needs creative solutions, might work)

These require new routines in the ~181 bytes of free space, or clever
reuse of existing code. May require multiple attempts.

#### v3.0.0 — Spell Code Hint on Cast Screen

When casting, show the 4-letter codes of known spells (compact list).
Needs ~80-120 bytes of new code in free space at $FA9B.

- [ ] Write spell list walker routine in free space
- [ ] Hook into who_cast_spell before "Spell to cast:" prompt
- [ ] Filter by hero's spell level per class
- [ ] Smoke test: cast screen shows known spell codes

#### v3.1.0 — Party Auto-Attack

Add a key that makes all heroes repeat "Attack" without prompting.
Needs to store last action per hero and bypass the options menu.

- [ ] Reserve 6 bytes for last-action-per-hero buffer
- [ ] Add key check in battle_options (~20 bytes)
- [ ] Auto-execute stored action on key press
- [ ] Smoke test: press key, all heroes attack automatically

#### v3.2.0 — Quick Save to Memory

Instead of tape save (which requires the Guild), save game state to
a memory buffer. Won't persist across power-off but lets you checkpoint.

- [ ] Find/create a 128-byte buffer for state snapshot
- [ ] Add key to trigger save (copy GAME_VARIABLES block)
- [ ] Add key to trigger load (restore from buffer)
- [ ] Smoke test: save in city, die, load, back at save point

#### v3.3.0 — Show HP in Stats Bar

The stats table already shows hero names. Add current/max HP display
by modifying print_stats_table.

- [ ] Modify stats rendering to include HP numbers
- [ ] Fit within existing screen layout (may need to abbreviate)
- [ ] Smoke test: HP visible and updates during combat

#### v3.4.0 — Combat Victory Sound

The beeper routine already exists (call_beeper). Add a short victory
jingle after enemies_killed.

- [ ] Compose 3-4 note jingle as beeper frequency/duration pairs
- [ ] Insert call after enemies_killed XP award (~10 bytes)
- [ ] Smoke test: win combat, hear jingle

---

### v4.x — Hard / Needs Human Intervention (may be impossible)

These hit fundamental ZX Spectrum constraints. Would likely require
either a different technical approach (emulator wrapper, C port) or
significantly more free memory than exists.

#### v4.0.0 — Standalone Mac App (Embedded Emulator)

Embed Fuse/libspectrum into a Swift wrapper. Auto-loads bt.tap, maps
keys to modern layout. This is a separate software project, not an
assembly mod.

- [ ] Research libfuse C API for programmatic control
- [ ] Create Xcode project with Fuse as embedded library
- [ ] Auto-load bt.tap, intercept keyboard for remapping
- [ ] Package as .app with icon and menu bar
- [ ] DIFFICULTY: Fuse may not have a clean embedding API

#### v4.1.0 — Full Spell Selection Menu

Show spell names (not just codes) with descriptions and costs.
Needs hundreds of bytes of new code + text data. The 181 bytes
of free space isn't enough.

- [ ] Would need to compress existing data or relocate code
- [ ] Or implement as external tool that patches the binary
- [ ] DIFFICULTY: Memory is completely full

#### v4.2.0 — Auto-Map with Visual Display

Track visited tiles as bitmap, render as overhead map.
Needs ~900 bytes for a 30x30 city bitmap + rendering code.

- [ ] No memory for the bitmap without removing existing features
- [ ] Could potentially use screen attribute area for storage
- [ ] DIFFICULTY: No free RAM, would corrupt display

#### v4.3.0 — Difficulty Modes (Classic vs Modern)

Multiple game modes with different XP curves, encounter rates, etc.
Needs branching logic throughout the game + mode selection UI.

- [ ] Would need ~200+ bytes of new branching code scattered
      across combat, XP, and encounter routines
- [ ] DIFFICULTY: Not enough free space, too many touch points

#### v4.4.0 — Enhanced Graphics

New or improved sprites, building art, monster portraits.
ZX Spectrum graphics are 1-bit with color attributes per 8x8 block.

- [ ] New art would need to be drawn within ZX Spectrum constraints
- [ ] Would replace existing graphics data (same byte count)
- [ ] DIFFICULTY: Requires pixel art skill in ZX Spectrum format

#### v4.5.0 — Full Sound/Music System

Multi-channel music via the beeper using pulse-width tricks.
Would need an interrupt-driven music player.

- [ ] ZX Spectrum beeper is single-channel, CPU-driven
- [ ] Music during gameplay would halt the game (CPU busy beeping)
- [ ] DIFFICULTY: Fundamental hardware limitation

---

## Notes

- The original reverse engineer used an interceptor/debugger hack (`hack_interceptor.asm`,
  `hack_tools.asm`) with conditional compilation (`DEFINE INTERCEPT`) — useful for
  runtime analysis
- Cheat defines exist: `KILLERS`, `MAXEXPIRIENCE`, `MAXGOLD`, `MAXLEVEL`, etc.
- Only the city level is included; dungeon levels load at `$C18C` and would replace
  the city data at runtime
- The compile script diffs recompiled binary against original to verify correctness —
  this is the ultimate validation that reverse engineering is accurate
