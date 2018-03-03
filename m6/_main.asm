incsrc _macros.asm	;general macros, not all used
incsrc _RAM.asm		;RAM addresses, important

lorom

org $008000

RESET:	incsrc CORE/RESET.asm
NMI:	incsrc CORE/NMI.asm
BRK:	incsrc CORE/BRK.asm


nmi_game:
LDA #$81
RTS


-
REP #$20
INC.b RAM_layer3x
DEC.b RAM_layer1x
DEC.b RAM_layer1y
SEP #$20
RTS

game:
LDA.b RAM_gamemode
BNE -
LDA #$FF : STA.b RAM_bgcolor : STA.b RAM_bgcolor+1
;LDA #$FF : STA.w CGRAM : STA.w CGRAM+1
;STA.w CGRAM+4 : STA.w CGRAM+5
LDA #$02 : STA.b RAM_cgwsel
LDA #$20 : STA.b RAM_cgadsub
LDA #$06 : STA.b RAM_gfxmode
LDA #$01 : STA.b RAM_mainscr; : STA.b RAM_subscr
LDA #$10 : STA.b RAM_layer1map
LDA #$60 : STA.b RAM_layer3map
LDA #$01 : STA.b RAM_setini

LDA #$80 : STA $2115
REP #$20
STZ $2116
LDA #$1801 : STA $4310
LDA.w #GFX : STA $4312
LDY.b #GFX>>16 : STY $4314
LDA.w #MAP-GFX : STA $4315
SEP #$20
LDA #$02 : STA $420B

LDA #$80 : STA $2115
REP #$20
LDA #$1000 : STA $2116
LDA #$1801 : STA $4310
LDA.w #MAP : STA $4312
LDY.b #MAP>>16 : STY $4314
LDA.w #$0800 : STA $4315
SEP #$20
LDA #$02 : STA $420B

LDA #$80 : STA $2115
REP #$20
LDA #$6000 : STA $2116
LDA #$1801 : STA $4310
LDA.w #OFFSET : STA $4312
LDY.b #OFFSET>>16 : STY $4314
LDA.w #$0800 : STA $4315
SEP #$20
LDA #$02 : STA $420B

INC.b RAM_gamemode
LDA #$0F : STA.b RAM_brightness
LDA #$81 : STA $4200
RTS

GFX:	incbin statusbar.bin:0-9f
MAP:	incbin map.bin
OFFSET:	incbin offset.bin

incsrc CORE/_joypad.asm

warnpc $00FFC0
incsrc _header.asm

org $01FFFF
db $00