; page 80,132

; title CP/DOS DosQFileMode mapper

SECTION .dosxxx
	; assume	cs:dosxxx,ds:nothing,es:nothing,ss:nothing
;
;**********************************************************************
;*
;*   MODULE:   dosqfilemode	Read file attribute
;*
;*   FUNCTION:	Query file mode
;*
;*   CALLING SEQUENCE:
;*
;*	 push@	   asciiz   file path name
;*	 push@	   word     attribute return area
;*	 push	   dword    reserved
;*	 call	   dosqfilemode
;*
;*   MODULES CALLED:  PC-DOS Int 21h, ah=43h, change file mode
;*
;*********************************************************************

	    global dosqfilemode
	    ; .sall
	    ; .xlist
	    %include "macros.inc"
	    ; .list

error_code  equ      0002h

struc str
old_bp: resw 1
return: resd 1
rsrvd: resd 1
Attrib: resd 1; current attribute pointer
Path: resd 1; file path name pointer
endstruc

dosqfilemode:
	    Enter    dosqfilemode	 ; push registers

	    lds      dx,[bp].path	 ; set path name

	    mov      ax,4300h		 ; set op code
	    int      21h		 ; get file mode
	    jc	     error		 ; jump if error

	    lds      si,[bp].attrib	 ; setup return data area
	    mov      word [si],cx	 ; save attribute there
	    sub      ax,ax		 ; set good return code
	    jmp      short exit 	 ; return

error:	    mov      ax,error_code	 ; set error code

exit:	    mexit			 ; pop registers
	    ret      str_size - 6	 ; return

; ENDP dosqfilemode

; END SECTION .dosxxx

	    ; end
