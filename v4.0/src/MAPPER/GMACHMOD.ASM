;0
; page 80,132
;
; title CP/DOS DOSGETMACHINEMODE mapper
;
SECTION .dosxxx
	; assume	cs:dosxxx,ds:nothing,es:nothing,ss:nothing
;
;**********************************************************************
;*
;*   MODULE:   dosgetmachinemode
;*	Note that in PCDOS, this call should NOT BE ISSUED!
;*	This mapper does not return anything, it is meant
;*	only to allow the utility to link without errors.
;*
;*********************************************************************

	    global dosgetmachinemode
	    ; .sall
	    ; .xlist
	    %include "macros.inc"
	    ; .list

struc str
modeaddr: resw 1
endstruc

dosgetmachinemode:
	Enter	DosGetMachMode	      ; push registers

	sub	ax,ax		      ; set good return code

	mexit			      ; pop registers
	ret	str_size - 6	      ; return garbage (Not supported in PCDOS)

; ENDP dosgetmachinemode

; END SECTION .dosxxx

	    ; end
