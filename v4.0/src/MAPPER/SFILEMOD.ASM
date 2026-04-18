;0
; page 80,132

; title CP/DOS DosSetFileMode mapper

SECTION .dosxxx
	; assume	cs:dosxxx,ds:nothing,es:nothing,ss:nothing

;**********************************************************************
;*
;*   MODULE:   dossetfilemode
;*
;*   FUNCTION:	 Set file mode
;*
;*   CALLING SEQUENCE:
;*
;*	 push@	   asciiz   file path name
;*	 push	   word     new attribute
;*	 push	   dword    reserved
;*	 call	   dossetfilemode
;*
;*   MODULES CALLED:  PC-DOS Int 21h, ah=43h, change file mode
;*
;*********************************************************************

	    global dossetfilemode
	    ; .sall
	    ; .xlist
	    %include "macros.inc"
	    ; .list


struc str
old_bp: resw 1
return: resd 1
Rsrvd: resd 1; reserved
Attrib: resw 1; file attribute
Path: resd 1; path name pointer  pointer
endstruc

dossetfilemode:
	    Enter    dossetfilemode	   ; push registers

	    lds      dx,[bp].path	   ; set pointer to path
	    mov      cx,[bp].attrib

	    mov      ax,4301h
	    int      21h		   ; change file mode
	    jc	     exit		   ; jump if error, return DOS error in ax

	    xor      ax,ax		   ; set good return code
	    jmp      short exit 	   ; return

exit:	    mexit			   ; pop registers
	    ret      str_size - 6	   ; return

; ENDP dossetfilemode

; END SECTION .dosxxx

	    ; end
