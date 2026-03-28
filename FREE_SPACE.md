# Free Space Investigation

Exhaustive search of the original game binary ($5B00-$FFFF, 42KB) for usable
free space. Last updated after v3.0.0.

## Current Budget

| Region | Bytes | Status |
|--------|-------|--------|
| $FA9B-$FB4F | 181 total | 177 used, **4 remaining** |

### Per-Feature Breakdown

| Feature | Bytes | Running Total | Remaining |
|---------|-------|---------------|-----------|
| v2.0.0 WASD movement | 31 | 31 | 150 |
| v2.3.0 Monster toggle | 26 | 57 | 124 |
| v2.4.0 Coordinate display | 40 | 97 | 84 |
| v3.0.0 Spell code hints | 81 | 178 | 4 |

Note: v2.1.0 (encounter rate) and v2.2.0 (combat speed) modify existing bytes
in-place and don't consume free space.

---

## Areas Investigated

### Zero Runs in Original Binary (75 runs of 4+ bytes)

| Address | Size | Contents | Reclaimable? |
|---------|------|----------|--------------|
| $FA9B-$FB4F | 181 | Original free space (all zeros) | **YES** — our enhancement area |
| $5C7F-$5CE8 | 106 | Empty hero character slots | **NO** — filled at runtime when creating characters |
| $9A68-$9AA6 | 63 | Blank icon sprite #9 (all-zero pixels) | **MAYBE** — see "Best Candidate" below |
| $5D1C-$5D4C | 49 | Hero struct alignment padding | **NO** — part of character data structure |
| $5FF8-$6022 | 43 | Game variables area (zeroed at start) | **NO** — used by game engine at runtime |
| $5FD9-$5FF6 | 30 | Game variables area | **NO** — runtime state |
| $994C-$9966 | 27 | Icon sprite padding (partial zero rows) | **NO** — structural sprite data |
| $5CFF-$5D18 | 26 | Hero struct data | **NO** — runtime character data |
| All others | 4-25 | Scattered in hero data, icons, variables | **NO** — all structural |

### "Gaps" Between Assembly Files

24 apparent gaps found totaling 569 bytes by comparing filename address ranges.
**ALL contain actual code/data.** File names show entry-point addresses, not the
routine's actual extent. Verified by checking original binary — every "gap" has
non-zero bytes.

### Area After Free Space ($FB50-$FC37)

This 232-byte region contains critical game state:
- `TEXT_BUFFER` ($FB62) — where player types spell codes
- `DISPLAY_PALETTE` ($FB75) — screen color attributes
- `ACTIVE_GUARDIAN` ($FB90) — NPC state
- `COMBAT_ACTIVE_FLAG` ($FB98) — combat engine state
- `SPELL_*_STATE` trackers — 7 spell state variables
- `GAME_PARAM_COPY` ($FBE0) — game parameter buffer

**NOT reclaimable** — all actively used at runtime.

### NOP Instructions

| Address | Size | Source | Reclaimable? |
|---------|------|--------|--------------|
| $EEE8-$EEE9 | 2 | WASD hook padding (movement.asm) | Only 2 bytes |
| $7549-$754A | 2 | Spell hints hook padding (who_cast_spell.asm) | Only 2 bytes |
| Various | 2 | Self-modifying code patch points | **NO** — needed for SMC |

---

## Best Candidate: Icon #9 (48 bytes at $9A68)

The last icon sprite in `gfx/98DF-9AA6_icons.asm` is completely blank — 48 bytes
of zeros representing an invisible 2x3 character cell icon.

**How icons work:** `show_icon_A` (code/8D4D-8DA8) looks up icons by index:
```
ld hl, ICONS-30h
ld bc, 30h          ; 48 bytes per icon
; loop: add hl,bc × A times
```

**To reclaim:** Must verify that no code path ever calls `show_icon_A` with
A = the index that maps to icon #9. If confirmed unused, 48 bytes of code
could be placed at $9A68-$9A97.

**Risk:** If the game ever tries to render icon #9, it would execute our code
as pixel data, producing garbage graphics instead of a blank space.

---

## Future Approaches (If More Space Needed)

### Feasible

1. **Reclaim icon #9** — 48 bytes, medium effort. Trace all `show_icon_A` calls
   to confirm index 9 is never used.

2. **Code golf existing enhancements** — Review v2.0-v3.0 for byte savings.
   Even 5-10 bytes recovered could enable a small feature.

3. **Trampoline to icon #9** — Use 4 remaining bytes for a `jp $9A68` (3 bytes)
   to jump to code stored in the reclaimed icon space. Gives 48 bytes at a
   non-contiguous address.

### Difficult

4. **Refactor repeated game code** — Common Z80 patterns (`exx/ld(hl),a/exx`,
   null checks, table traversal) appear 4-7 times each. Factoring into shared
   subroutines could free 20-50 bytes, but requires modifying original game code.

5. **Overwrite unused game features** — If any original features are identified
   as expendable (e.g., a debug routine, an unused special event), their code
   could be reclaimed.

### Very Difficult

6. **Text compression** — The game has ~15KB of text data in tables. Even 5%
   compression would yield 750 bytes. But needs a decompressor routine and
   significant rework of the message printing system.

7. **Bank switching** — Use the ZX Spectrum 128K's memory banking to swap in
   extra code pages. Only works on 128K models, not the original 48K target.
