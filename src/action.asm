SECTION "action", ROM0

waitsometime:
    ld c, 224
    ld b, 100
    ld d, 224
repeat1:
repeat2:
repeat3:
    WaitVBlank__:
    ld a, [rLY]
    cp 144
    jp nz, WaitVBlank__
    dec c
    jp nz, repeat3
    jp nz, repeat2
    jp nz, repeat1
    ret

waitalittle:
    ld c, 10
    ld b, 7
repeat11:
repeat22:
    WaitVBlank___:
    ld a, [rLY]
    cp 144
    jp nz, WaitVBlank___
    dec c
    jp nz, repeat22
    jp nz, repeat11
    ret


; arguments
; hl --- memory addr that start to clear
;        the first element of one line
; c  --- row 
; b  --- column
clear_screen:
clear_all:
	push hl
clear:
	ld a, 0
	ld [hli], a
	dec c
	jp nz, clear

	pop hl
	ld de, $0020
	add hl, de
	dec b
	jp nz, clear_all
	ret	

close_LCD:
    ld a, [rLCDC]
    res 7, a
    ld [rLCDC], a
    ret

open_LCD:
    ld a, [rLCDC]
    set 7, a
    ld [rLCDC], a
    ret

display_scene1:
    ld de, Scene1
	ld hl, $9800
	ld bc, Scene1End - Scene1
CopyTilemap1:
	ld a, [de]
    ld [hli], a
    inc de
    dec bc
    ld a, b
    or a, c
    jp nz, CopyTilemap1
    ret

display_scene2:
    ; call close_LCD
    ld de, Scene2
	ld hl, $9800
	ld bc, Scene2End - Scene2
CopyTilemap2:
	ld a, [de]
    ld [hli], a
    inc de
    dec bc
    ld a, b
    or a, c
    jp nz, CopyTilemap2
    ; call open_LCD
    ret

display_scene3:
    ; call close_LCD 
    ld de, Scene3
	ld hl, $9800
	ld bc, Scene3End - Scene3

    CopyTilemap3:
	ld a, [de]
    ld [hli], a
    inc de
    dec bc
    ld a, b
    or a, c
    jp nz, CopyTilemap3
    ; call open_LCD
    ret