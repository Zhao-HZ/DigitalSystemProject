INCLUDE "./src/hardware.inc"
INCLUDE "./src/data.inc"

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
    ld a, 1
    ld [rLCDC], a

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
	
	ld de, Scene3
	ld hl, $9800
	ld bc, Scene3End - Scene3
CopyTilemap:
	ld a, [de]
    ld [hli], a
    inc de
    dec bc
    ld a, b
    or a, c
    jp nz, CopyTilemap

    ; Turn the LCD on
    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON
    ; ld a, 1
    ld [rLCDC], a

    ; During the first (blank) frame, initialize display reg  isters
    ld a, %11100100
    ld [rBGP], a
    ld [rOBP1], a

Done:
	jp Done	
		
	
