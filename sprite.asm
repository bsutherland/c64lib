#importonce

#import "zeropage.asm"

.const SPRITE_POINTER_BASE = $07f8

.const SPRITE_COORD_X_BASE = $d000
.const SPRITE_COORD_Y_BASE = $d001
.const SPRITE_COORD_X_BIT8 = $d010
.const SPRITE_ENABLE = $d015
.const SPRITE_CONTROL_2 = $d016
.const SPRITE_DOUBLE_HEIGHT = $d017
.const SPRITE_DOUBLE_WIDTH = $d01d
.const SPRITE_MODE_MULTICOLOR = $d01c
.const SPRITE_INTER_COLLISION = $d01e
.const SPRITE_BACKGROUND_COLLISION = $d01f

.const SPRITE_COLOR_SHARED_1 = $d025
.const SPRITE_COLOR_SHARED_2 = $d026
.const SPRITE_COLORS_BASE = $d027

.const SPRITE_MASK_0 = $1
.const SPRITE_MASK_1 = $2
.const SPRITE_MASK_2 = $4
.const SPRITE_MASK_3 = $8

.const SPRITE_SIZE_BYTES = 64
.const SPRITE_WIDTH = 24
.const SPRITE_HEIGHT = 21
.const SPRITE_CANVAS_WIDTH = 512
.const SPRITE_CANVAS_HEIGHT = 256

.macro sprite_enable(i) {
    lda #(1 << i)
    ora SPRITE_ENABLE
    sta SPRITE_ENABLE
}

.macro sprite_multicolor_enable(i) {
    lda #(1 << i)
    ora SPRITE_MODE_MULTICOLOR
    sta SPRITE_MODE_MULTICOLOR
}

.macro sprite_multicolor_shared_1(color) {
    lda #color
    sta SPRITE_COLOR_SHARED_1
}

.macro sprite_multicolor_shared_2(color) {
    lda #color
    sta SPRITE_COLOR_SHARED_2
}

.macro sprite_color_foreground(i, color) {
    lda #color
    sta SPRITE_COLORS_BASE + i
}

.macro sprite_addr(i, addr) {
    sprite_addr_div64(i, addr/64)
}

.macro sprite_addr_div64(i, idx) {
    lda #idx
    sta SPRITE_POINTER_BASE + i
}

.macro sprite_x_const(i, x) {
    lda #<x
    sta SPRITE_COORD_X_BASE + 2*i

    lda SPRITE_COORD_X_BIT8
    ora #(>x << i)
    sta SPRITE_COORD_X_BIT8
}

.macro sprite_x(i, x) {
    lda x
    sta SPRITE_COORD_X_BASE + 2*i

    lda x+1
    beq msb_zero

    lda #(1 << i)
    ora SPRITE_COORD_X_BIT8
    jmp return

msb_zero:
    lda #~(1 << i)
    and SPRITE_COORD_X_BIT8
    // fall-through
return:
    sta SPRITE_COORD_X_BIT8
}

.macro sprite_y_const(i, y) {
    lda #y
    sta SPRITE_COORD_Y_BASE + 2*i
}

.macro sprite_y(i, y) {
    lda y
    sta SPRITE_COORD_Y_BASE + 2*i
}

.macro sprite_position(i, x, y) {
    sprite_x(i, x)
    sprite_y(i, y)
}
