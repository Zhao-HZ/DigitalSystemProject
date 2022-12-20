INCLUDE "./src/hardware.inc"
INCLUDE "./src/data.inc"
INCLUDE "./src/action.asm"

SECTION "Header", ROM0[$100]

	jp EntryPoint

    ds $150 - @, 0 ; Make room for the header

EntryPoint:
    ld a, 0
    ld [rNR52], a
    
    ld c, 5
WaitVBlank:
    ld a, [rLY] 
    cp 144
    jp c, WaitVBlank

    ld a, 0
    ld [rLCDC], a

	ld de, Tiles 
	ld hl, $9000
	ld bc, TilesEnd - Tiles

; Copy all of the tiles
CopyTiles:
	ld a, [de]
	ld [hli], a
	inc de
	dec bc
	ld a, b
	or a, c
	jp nz, CopyTiles

; Do with Object
    ld hl, _OAMRAM
    ld [hl], 144
    inc hl
    ld [hl], 10
    inc hl
    ld [hl], 0
    inc hl 
    ld [hl], 0
    inc hl 

    ld b, 38 * 4
    ld a, 0
OAM_clean_loop:
    ld [hl], a
    inc hl
    dec b
    jp nz, OAM_clean_loop
    
    ld de, Objs
    ld hl, $8000
    ld bc, ObjsEnd - Objs

CopyObjTiles:
    ld a, [de]
    ld [hli], a
    inc de
    dec bc
    ld a, b
    or a, c
    jp nz, CopyObjTiles

    call display_scene1

    ; Turn the LCD on
    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON
    res 1, a
    ; ld a, 1
    ld [rLCDC], a
    

    ; Dring the first (blank) frame, initialize display reg  isters
    ld a, %11100100
    ld [rBGP], a
    ld [rOBP1], a 
    

	call waitsometime
	call waitsometime
	call waitsometime
	call waitsometime

; Scroll down the screen 
	ld c, $73
    ld a, [rSCY]
    ld b, a
repeat_scroll:
	wait_:
	ld a, [rLY]
	cp 144
	jp nz, wait_
	ld a, [rSCY]   
	add a, 1
	ld [rSCY], a
	dec c
	jp nz, repeat_scroll

    call waitsometime
	call waitsometime
	call waitsometime
; End Scrolling	

    ld hl, $9820
    ld c, $13
    ld b, $13 
    call clear_screen

; Return to the origin
    ld a, 0
    ld [rSCY], a

	call waitsometime

    ld a, [rLCDC]
    set 1, a
    ld [rLCDC], a


    call close_LCD
    call display_scene2
    call open_LCD

    ; Move the bicycle
    ; temoporary
    ld hl, _OAMRAM 
    inc hl
    push hl
move_right:
    call waitalittle
    ld a, [hl]
    inc a
    ld [hl], a
    cp 200     
    jp nz, move_right

    pop hl

move_left:
	call waitalittle
    ld a, [hl]
    dec a
    ld [hl], a
    cp a, 20
    jp nz, move_left

    dec hl
    ld c, 1
    ld hl, _OAMRAM 
move_up:
    push hl
    call waitalittle
    ld a, [hl]
    dec a
    ld [hl], a
    inc hl
    ld a, [hl]
    inc a
    ld [hl], a
    pop hl
    dec c
    cp 0
    jp nz, move_up
    ; temoporary

    call close_LCD
    ; Turn off the Object
    ld a, [rLCDC]
    res 1, a 
    ld [rLCDC], a

    call close_LCD

    ld hl, _OAMRAM
    ; Battery
    ld [hl], 40 ; Y (not to change)
    inc hl 
    ld [hl], 45 ; X
    inc hl
    ld [hl], 1
    inc hl
    ld [hl], 0
    inc hl
    ; Bone
    ld [hl], 40 ; Y
    inc hl 
    ld [hl], 73 ; X
    inc hl
    ld [hl], 2
    inc hl
    ld [hl], 0
    inc hl
    ; Kernel
    ld [hl], 40 ; Y
    inc hl 
    ld [hl], 105 ; X
    inc hl
    ld [hl], 3
    inc hl
    ld [hl], 0


    call display_scene3
    call open_LCD
    ld a, [rLCDC]
    set 1, a
    ld [rLCDC], a

    ld hl, _OAMRAM
    ld c, 0
jump_down:
    push hl
    call waitalittle
    ld b, [hl]
    inc b
    ld [hl], b
    inc hl
    inc hl
    inc hl
    inc hl
    ld b, [hl]
    inc b
    ld [hl], b 
    inc hl
    inc hl
    inc hl
    inc hl
    ld b, [hl]
    inc b
    ld [hl], b
    ld a, b
    cp 100
    pop hl
    dec c
    cp 0
    jp nz, jump_down


    call waitsometime
    call waitsometime
    call waitsometime

    call close_LCD
    ld a, [rLCDC]
    res 1, a
    ld [rLCDC], a 
    call display_scene5    
    call open_LCD

Done:
	jp Done	