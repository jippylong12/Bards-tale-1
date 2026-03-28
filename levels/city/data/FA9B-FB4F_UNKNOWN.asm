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

; --- Show coordinates after movement (v2.4.0) ---
; Prints N/S,E/W at top-right, then chains to compass display.
; No register saves needed: show_icon_A does its own PUSH_REGS,
; and move_execute's next instruction (jp dyn_proc_81) is stateless.
show_coords:
		; Guard: skip if game is paused/in menu
		ld	a, (iy+VAR_PAUSE)
		or	a
		jp	nz, show_compass

		; Save cursor position
		ld	hl, (GAME_VARIABLES + VAR_CURSOR_ROW)
		push	hl

		; Set cursor to row 2, col 29 (L=row, H=col)
		ld	hl, 1D02h
		ld	(GAME_VARIABLES + VAR_CURSOR_ROW), hl

		; Print N/S coordinate
		ld	e, (iy+VAR_COORD_SO_NO)
		PRINT_NUM_FROM_E

		ld	a, ','
		PRINT_WITH_CODES

		; Print E/W coordinate
		ld	e, (iy+VAR_COORD_WE_EA)
		PRINT_NUM_FROM_E

		PRINT_SPACE

		; Restore cursor position
		pop	hl
		ld	(GAME_VARIABLES + VAR_CURSOR_ROW), hl

		jp	show_compass

; --- Spell code hints on cast screen (v3.0.0) ---
; Hooked from loc_7545: replaces PUSH_REGS; ld e,a
; Called from both who_cast_spell and combat option_is_found.
; Prints known spell codes for the hero's casting class.
show_spell_hints:
		push	af			; save caller's A
		push	bc			; save caller's C

		; Find hero's first casting class (offset 40h-43h)
		ld	b, 0			; class index (0-3)
		ld	c, 40h			; char struct offset

.find_class:
		ld	a, c
		GET_ATTR_BY_A			; A = hero's spell level for this class
		or	a
		jr	nz, .found_class
		inc	c
		inc	b
		ld	a, b
		cp	4
		jr	c, .find_class
		jr	.done			; no casting class

.found_class:
		ld	c, a			; C = hero's max spell level
		; Look up class start address in spell table
		ld	hl, .class_starts
		ld	a, b
		add	a, a			; x2 for word entries
		add	a, l
		ld	l, a
		ld	a, (hl)
		inc	hl
		ld	h, (hl)
		ld	l, a			; HL = start of class in SPELL_NAMES

		ld	b, 0			; char counter (0-3)
		PRINT_NEWLINE

.print_loop:
		ld	a, (hl)
		bit	7, a			; level marker byte?
		jr	nz, .marker
		PRINT_WITH_CODES		; print spell letter
		inc	hl
		inc	b
		ld	a, b
		and	3			; every 4 chars = one spell code
		jr	nz, .print_loop
		PRINT_SPACE			; space between codes
		jr	.print_loop

.marker:
		and	0Fh			; extract level number
		jr	z, .done		; F0 = end of class
		cp	c			; compare with hero's level
		jr	nc, .done		; marker >= hero level, stop
		inc	hl			; skip marker byte
		jr	.print_loop

.done:
		pop	bc			; restore caller's C
		pop	af			; restore caller's A
		; Relocated from hook site (was after PUSH_REGS)
		ld	e, a
		ld	a, c
		ld	(spell_result+2), a
		ret

.class_starts:
		dw	sorcerer_L1		; offset 40h = Sorcerer
		dw	conjurer_L1		; offset 41h = Conjurer
		dw	magician_L1		; offset 42h = Magician
		dw	wizard_L1		; offset 43h = Wizard

; --- Pad remaining free space with zeros ---
FREE_SPACE_END:
		ds $FB50 - FREE_SPACE_END, 0
