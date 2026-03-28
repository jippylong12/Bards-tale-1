; ============================================
; Free space at $FA9B — used for enhancements
; Original: 181 bytes of zeros
; ============================================

___table_81:		; keep label for addr_table references

; --- WASD movement handler (v2.0.0) ---
wasd_movement:
		; Check forward keys
		cp	'I'
		jp	z, move_forward
		cp	'W'
		jp	z, move_forward

		; Check back/kick keys
		cp	'K'
		jp	z, kick_door
		cp	'S'
		jp	z, kick_door

		; Check turn left keys
		cp	'A'
		jp	z, turn_left

		; Check turn right keys
		cp	'D'
		jp	z, turn_right

		; Check toggle key (v2.3.0)
		cp	'F'
		jr	nz, .no_toggle

		; Toggle no-monsters flag
		ld	a, (no_monsters_flag)
		xor	1
		ld	(no_monsters_flag), a

.no_toggle:
		ret

; --- City ambush gate (v2.3.0) ---
; Called from game_cycle instead of second RND check
; If flag is set, skip combat. Otherwise do original random check.
ambush_gate:
		ld	a, (no_monsters_flag)
		or	a
		jr	nz, .skip_ambush	; flag set = no monsters
		; Do original random check
		GET_RND_BY_PARAM	3Fh
		ret					; Z flag set = ambush, NZ = no ambush
.skip_ambush:
		or	a				; force NZ (A is nonzero from flag)
		ret

no_monsters_flag:
		db	0				; 0 = normal, 1 = no city monsters

; --- Pad remaining free space with zeros ---
FREE_SPACE_END:
		ds $FB50 - FREE_SPACE_END, 0
