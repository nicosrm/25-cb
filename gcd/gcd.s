	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 15, 0	sdk_version 15, 5
	.globl	_gcd_imp                        ; -- Begin function gcd_imp
	.p2align	2
_gcd_imp:                               ; @gcd_imp
	.cfi_startproc
; %bb.0:
	cmp	w1, #1
	b.lt	LBB0_3
LBB0_1:                                 ; =>This Inner Loop Header: Depth=1
	mov	x8, x1
	sdiv	w9, w0, w1
	msub	w1, w9, w1, w0
	mov	x0, x8
	cmp	w1, #0
	b.gt	LBB0_1
; %bb.2:
	mov	x0, x8
LBB0_3:
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_gcd_func                       ; -- Begin function gcd_func
	.p2align	2
_gcd_func:                              ; @gcd_func
	.cfi_startproc
; %bb.0:
	cmp	w1, #1
	b.lt	LBB1_3
LBB1_1:                                 ; =>This Inner Loop Header: Depth=1
	mov	x8, x1
	sdiv	w9, w0, w1
	msub	w1, w9, w1, w0
	mov	x0, x8
	cmp	w1, #0
	b.gt	LBB1_1
; %bb.2:
	mov	x0, x8
LBB1_3:
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_main                           ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	mov	w8, #21                         ; =0x15
	mov	w9, #36                         ; =0x24
LBB2_1:                                 ; =>This Inner Loop Header: Depth=1
	mov	x10, x8
	mov	x8, x9
	udiv	w9, w10, w9
	msub	w9, w9, w8, w10
	cbnz	w9, LBB2_1
; %bb.2:
	sub	sp, sp, #32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x8, [sp]
Lloh0:
	adrp	x0, l_.str@PAGE
Lloh1:
	add	x0, x0, l_.str@PAGEOFF
	bl	_printf
	mov	w9, #36                         ; =0x24
	mov	w10, #21                        ; =0x15
LBB2_3:                                 ; =>This Inner Loop Header: Depth=1
	mov	x8, x9
	udiv	w9, w10, w9
	msub	w9, w9, w8, w10
	mov	x10, x8
	cbnz	w9, LBB2_3
; %bb.4:
	str	x8, [sp]
Lloh2:
	adrp	x0, l_.str@PAGE
Lloh3:
	add	x0, x0, l_.str@PAGEOFF
	bl	_printf
	mov	w0, #0                          ; =0x0
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32
	ret
	.loh AdrpAdd	Lloh0, Lloh1
	.loh AdrpAdd	Lloh2, Lloh3
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"%d\n"

.subsections_via_symbols
