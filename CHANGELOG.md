# Changelog

All notable changes to this project will be documented in this file.
Format follows [Keep a Changelog](https://keepachangelog.com/).

## [1.2.0] - 2026-03-28

### Named (12 struct offsets)
- 7 character offsets: `CHAR_12`→`CHAR_SPEED` (used in defense/initiative), `CHAR_13`→`CHAR_SAVED_STATS` (possession swap), `CHAR_15`→`CHAR_ATTACK_SPEC` (damage dice), `CHAR_16`→`CHAR_DEFENSE_SPEC`, `CHAR_17`→`CHAR_SPECIAL_FLAG`, `CHAR_60`→`CHAR_BACKUP_PARAMS` (class change), `CHAR_63`→`CHAR_SWAP_STATS`
- 5 enemy offsets: `ENEMY_10`→`ENEMY_ACTIVE_FLAG`, `ENEMY_11`→`ENEMY_COMBAT_DATA`, `ENEMY_15`→`ENEMY_SPEED`, `ENEMY_16`→`ENEMY_ATTACK_SPEC`, `ENEMY_17`→`ENEMY_SPECIAL_FLAG`

### Verified
- Binary still matches original

## [1.1.0] - 2026-03-28

### Named (70 game variables)
All `VAR_xx` hex offsets in `constants.asm` replaced with meaningful names.
References updated across 100+ assembly files.

Examples: `VAR_00` → `VAR_PARTY_SIZE`, `VAR_53` → `VAR_TARGET_ID`,
`VAR_4D` → `VAR_ENEMY_COUNT`, `VAR_10` → `VAR_SPELL_ACTIVE`,
`VAR_38`/`VAR_39` → `VAR_VIEW_Y_OFFSET`/`VAR_VIEW_X_OFFSET` (3D rendering)

Variable groups identified: day/night cycle (5 vars), spell system (6),
combat state (6), damage pipeline (6), 3D view (2), treasure/loot (5)

### Verified
- Binary still matches original after all renames

## [1.0.0] - 2026-03-28

### Milestone
- **All 75 code routines identified** — zero UNKNOWN code files remain
- Complete reverse engineering of: combat, encounters, character/party, magic/damage, spell effects, city locations, 3D rendering, UI/display
- Binary verified byte-identical to original at every version
- 26 data/table UNKNOWN files remain (raw data blobs, not code)

## [0.9.0] - 2026-03-28

### Identified (14 routines — city/level code)
- `movement_dispatch` — entry point routing for movement and sinister encounter events
- `shift_price_buffer` — BCD right-shift with carry for price calculations
- `display_inventory_list` — shows inventory items with equip markers and prices
- `get_inventory_selection` — validates player's 1-8 item selection
- `format_item_price` — formats item price for display
- `compare_char_attrs` — compares 4-byte character attribute blocks
- `copy_char_params` — saves/restores character parameters during class change
- `adjust_stat_floor` — subtracts with zero floor, adds offset
- `add_16bit_carry` — 16-bit addition with carry propagation
- `proc_sinister_street` — Sinister Street evil magic encounter handler
- `render_3d_view` — core 3D dungeon/city rendering engine (coordinate mapping, view calculation)
- `display_walls_creatures` — renders wall and creature layers in 3D view
- `render_sprite_3d` — decodes and renders 3D sprites with RLE encoding
- `decode_sprite_mask` — converts sprite patterns to pixel transparency masks

### Milestone
- **All 75 code UNKNOWN files are now identified** (61 core + 14 city)
- Only 26 data/table UNKNOWN files remain (raw data, not code routines)

### Verified
- Binary still matches original after all renames

## [0.8.0] - 2026-03-28

### Identified (7 routines — core + display)
- `show_location_info` — prints "You face [direction]" with dungeon level/coordinates or "in Skara Brae"
- `spell_attack_bonus` — applies attack power bonus from spell to party or enemy
- `adjust_value_updown` — UI widget for adjusting values with up/down keys, wraps at 0/21
- `roll_damage_dice` — rolls B d4 dice, accumulates in HL (core damage randomizer)
- `print_large_number` — formats multi-digit number from table with line-wrap handling
- `toggle_speed_flag` — toggles VAR_2E between 0 and 0xFF for animation speed
- `print_item_name_padded` — prints item name right-padded with spaces to 11 characters

### Verified
- Binary still matches original — all 61 core UNKNOWN files now identified

## [0.7.0] - 2026-03-28

### Identified (8 routines — spell effect handlers)
- `spell_breath_attack` — area/breath spell: targets party or group, applies damage with status effects, prints "breathes at..." / "repelled the spell!"
- `spell_stat_modifiers` — buff/debuff spells: AC reduction, party defense boost, attack bonuses
- `spell_heal_and_cure` — healing: restores HP (capped at max hits), cures poison, paralysis, nuts, possession; also handles resurrection (sets HP to 1)
- `spell_summon_monster` — creates ally from summon creature table, copies monster data into party slot, prints "[creature] appears"
- `calc_monster_hp` — derives monster HP from the HP/AC spec table field with random modifier
- `spell_reveal_secret` — checks underground map data for secret passages, sets reveal flag
- `spell_flee_effect` — wraps the flee check for spell-assisted escape, "but it had no effect!" on failure
- `spell_ac_modifier` — applies AC modification to party (VAR_62) or enemy group defense

### Note
- v0.7.0 was originally planned as "dungeon/navigation" but analysis revealed these are spell effect dispatch targets, not navigation routines

### Verified
- Binary still matches original after all renames

## [0.6.0] - 2026-03-28

### Identified (8 routines — magic/damage system)
- `calc_attack_damage` — full melee damage pipeline: weapon damage dice, AC reduction, attacks per round, Monk unarmed scaling (half level, capped at 31), Hunter critical hit (random vs CHAR_HUNTER_CHANCE)
- `calc_enemy_attack` — enemy attack roll: monster spec for damage dice, hero AC comparison, attack bonus from monster type
- `apply_damage_to_group` — distributes damage across enemy group, kills individuals, shifts survivors forward, updates group roster
- `apply_damage_to_hero` — handles all damage outcomes: death (status 3), stoning (status 4), poisoning (status 1), level drain (decrements level + recalcs XP), possession (status 6, swaps stats), and game over check
- `check_spell_valid` — validates caster class can use the spell by searching allowed spell list
- `resolve_spell_effect` — full spell resolution: calculates damage, applies to target, prints "at [name] for X points of damage"
- `tick_spell_duration` — decrements active spell/song timer, fires cleanup when expired
- `start_spell_or_song` — initializes spell/song: sets duration from lookup table, stores spell ID, sets active flag

### Verified
- Binary still matches original after all renames

## [0.5.0] - 2026-03-27

### Identified (14 routines — character/party system)
- `check_spell_cost` — validates caster has enough SP for the spell
- `use_and_break_item` — uses item with random chance to break (if value < 0x30)
- `calc_armor_class` — computes AC from class, level, equipment. Monks get level-based AC bonus (capped at 21). Loops equipped items for weapon bonuses.
- `recalc_party_ac` — recalculates AC for all 6 party members
- `add_item_to_hero` — finds empty inventory slot, checks class equip eligibility
- `calc_xp_for_level` — XP thresholds differ per class (offset by 13 per class in table)
- `add_to_bcd_number` — positional add into 12-digit BCD numbers (how XP/gold math works internally)
- `check_heroes_alive` — iterates party checking alive + unflagged status
- `store_bcd_and_compare` — BCD conversion with max-value overflow protection
- `summon_creature` — converts enemy monster data into a party ally slot
- `apply_anti_magic` — blocks spells in anti-magic zones, clears active effects
- `process_dungeon_step` — increments dungeon counter, triggers map refresh
- `regenerate_hp_sp` — loops party restoring HP/SP toward max values
- `regen_equipped_effects` — per-hero regen from equipped item types 1 and 2

### Verified
- Binary still matches original after all renames

## [0.4.0] - 2026-03-27

### Identified (4 routines — encounter generation)
- `generate_encounter` — builds random enemy groups: rolls for count (up to 4 groups), picks monster types from area tables, caps group size at 99, fills stat buffers. Underground areas get more groups.
- `enemy_group_advance` — compares speed stats between adjacent enemy groups, swaps the faster one forward, prints "The [monster] advances!"
- `calc_xp_thresholds` — loops 5 times over a threshold table at addr_9815, counts how many level boundaries a value exceeds. Used to convert raw XP into level tiers for the party.
- `check_item_effect` — reads an item's effect value from a lookup table and ANDs it with a bitmask. Quick yes/no check for whether an item has a specific property (e.g. "does this weapon do fire damage?").

### Verified
- Binary still matches original after all renames

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
