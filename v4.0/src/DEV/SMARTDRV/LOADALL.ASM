BREAK	<LOADALL descriptor caches>

DEF_ACCESS	EQU	92H
DEF_LIMIT	EQU	0FFFFH

struc SEGREG_DESCRIPTOR
SEG_BASE: dw 0
		db 0
SEG_ACCESS	DB	DEF_ACCESS
SEG_LIMIT	DW	DEF_LIMIT
endstruc

struc DTR_DESCRIPTOR
DTR_BASE: dw 0
		db 0
		DB	0
DTR_LIMIT: dw 0
endstruc
;
; 386 Descriptor template
;
struc desc
lim_0_15	dw	0		; limit bits (0..15)
bas_0_15	dw	0		; base bits (0..15)
bas_16_23	db	0		; base bits (16..23)
access		db	0		; access byte
gran		db	0		; granularity byte
bas_24_31	db	0		; base bits (24..31)
endstruc

struc gdt_descriptor
gdt_limit: dw 0
gdt_base_0: dw 0
gdt_base_2: dw 0
endstruc
