INCLUDE "./src/hardware.inc"
INCLUDE "./src/data.inc"
INCLUDE "./src/action.asm"

SECTION "Header", ROM0[$100]

	jp EntryPoint

    ds $150 - @, 0 ; Make room for the header

EntryPoint:
    ; Shut down audio circuitry
    ld a, 0
    ld [rNR52], a

      ; Do not turn the LCD off outside of VBlank
WaitVBlank:
    ld a, [rLY] ; rLY = $FF44
    cp 144
    jp c, WaitVBlank

    ; Turn the LCD off
    ld a, 0
    ld [rLCDC], a
    ; call close_LCD

	; Copy the tile data
	ld de, Tiles 
	ld hl, $9000
	ld bc, TilesEnd - Tiles
CopyTiles:
	ld a, [de]
	ld [hli], a
	inc de
	dec bc
	ld a, b
	or a, c
	jp nz, CopyTiles
	
    call display_scene1

    ; Turn the LCD on
    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON
    ; ld a, 1
    ld [rLCDC], a
    ; call open_LCD

    ; Dring the first (blank) frame, initialize display reg  isters
    ld a, %11100100
    ld [rBGP], a
	
	call waitsometime
	call waitsometime
	call waitsometime
	call waitsometime

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
    call waitsometime
    call waitsometime

    ld hl, $9820
    ld c, $13
    ld b, $13 
    call clear_screen

    ld a, 0
    ld [rSCY], a

    call display_scene3    

Done:
	jp Done	
		
	
