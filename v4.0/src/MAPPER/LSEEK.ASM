;
; page 80,132
;0
; title CP/DOS DosChgFilePtr mapper	    * * *
;
SECTION .dosxxx
	; assume	cs:dosxxx,ds:nothing,es:nothing,ss:nothing

;**********************************************************************
;*
;*   MODULE:   doschgfileptr
;*
;*   FILE NAME: dos007.asm
;*
;*   CALLING SEQUENCE:
;*
;*	 push	   word    file handle
;*	 push	   dword   distance
;*	 push	   word    move type
;*	 push@	   dword   new pointer
;*	 call	   doschgfileptr
;*
;*   MODULES CALLED:  PC-DOS Int 21h, ah=42h, move file pointer
;*
;*********************************************************************

	    global doschgfileptr
	    ; .sall
	    ; .xlist
	    %include "macros.inc"
	    ; .list

struc str
old_bp: dw 0
return: dd 0
newptr: dd 0; new file pointer
movtyp: dw 0; move type
dstnce: dd 0; distance to be moved
handle: dw 0; file handle
endstruc

doschgfileptr:
	    Enter    doschgfileptr	 ; push registers

	    push     es
	    les      dx,[bp].dstnce
	    mov      cx,es		 ; set distance
	    pop      es
	    mov      ax,[bp].movtyp	 ; get move type
	    mov      bx,[bp].handle	 ; get handle

	    mov      ah,42h
	    int      21h		 ; move file pointer
	    jc	     exit		 ; return if error

	    lds      si,[bp].newptr	   ; set pointer
	    mov      word [si],ax	   ; save the new pointer
	    mov      word [si]+2,dx    ;
	    sub      ax,ax		   ; set godd return code

exit:	    mexit		       ;pop registers
	    ret      str_size - 6      ;return

; ENDP doschgfileptr

; END SECTION .dosxxx

	    ; end
