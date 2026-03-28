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

		ret

; --- Pad remaining free space with zeros ---
FREE_SPACE_END:
		ds $FB50 - FREE_SPACE_END, 0
