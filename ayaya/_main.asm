incsrc _macros.asm	;general macros, not all used
incsrc _RAM.asm		;RAM addresses, important

hirom

org $008000

RESET:	incsrc CORE/RESET.asm
NMI:	incsrc CORE/NMI.asm
BRK:	incsrc CORE/BRK.asm
IRQ:	incsrc CORE/IRQ.asm

nmi_game:
-
LDA #$81
RTS

;nmi_game:
LDA $FF
BEQ -
LDA $4211
LDA #$B0
STA $4209
STZ $420A
LDA #$00
STA $4207
STZ $4208
LDA #$B1
RTS


-
BIT.b RAM_joy1pressH
BPL +
LDA.b RAM_mainscr
EOR #$01
STA.b RAM_mainscr
+
BIT.b RAM_joy1pressH
BVC +
LDA.b RAM_mosaic
EOR #%11110001
STA.b RAM_mosaic
+
LDA.b RAM_joy1pressL
BIT #$30
BEQ +
BIT #$10
BNE .right
.left
DEC $FD
BRA +
.right
INC $FD
+
LDA.b RAM_joy1pressH
BIT #$20
BEQ +
STZ $FD
+
LDA $FD
BMI +
CMP #$12
BCC ++
LDA #$00
BRA ++
+
LDA #$11
++
STA $FD
REP #$30
AND #$00FF
ASL #5
ADC #$0002
TAX
LDY #$0002
SEP #$20
--
LDA PAL,x
STA.w CGRAM,y
INX
INY
CPY #$0020
BCC --
SEP #$10
RTS

game:
LDA.b RAM_gamemode
BNE -
LDA #$80 : STA $2115
REP #$20
STZ $2116
LDA #$1801 : STA $4300
LDA.w #GFX : STA $4302
LDY.b #GFX>>16 : STY $4304
STZ $4305
SEP #$20
LDA #$01 : STA $420B

LDX #$3F
-
LDA PAL,x
STA.w CGRAM,x
DEX : BPL -

REP #$20
LDA #$0B00 : STA $4310
LDA.w #HDMA_MAP : STA $4312
LDY.b #HDMA_MAP>>16 : STY $4314
LDA #$FFFE : STA.b RAM_layer1y : STA.b RAM_layer2y
SEP #$20
LDA #$02 : STA.b RAM_hdmareg

LDA #$03 : STA.b RAM_mainscr : STA.b RAM_subscr
LDA #$78 : STA.b RAM_layer1map
LDA #$7C : STA.b RAM_layer2map
LDA #$35 : STA.b RAM_gfxmode
LDA #$01 : STA.b RAM_setini
LDA #$0F : STA.b RAM_brightness
INC.b RAM_gamemode
LDA #$80 : STA $4200
RTS

HDMA_MAP:
db $70,$60
db $70,$64
db $00

PAL:	incbin ayaya_in_a_pink_shirt_small_green.clr
	incbin smw.mw3

incsrc CORE/_joypad.asm

warnpc $00FFC0
incsrc _header.asm

org $410000
GFX:	incbin ayaya_in_a_pink_shirt_small_green_optimized.pic

org $41F000
incbin ayaya_tilemap.bin
incbin ayaya_tilemap2.bin