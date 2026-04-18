;
; page 80,132
;
; title CP/DOS DosSetDateTime mapper
;
SECTION .dosxxx
	; assume	cs:dosxxx,ds:nothing,es:nothing,ss:nothing
;
;**********************************************************************
;*
;*   MODULE:   dossetdatetime
;*
;*   FILE NAME: dos050.asm
;*
;*   CALLING SEQUENCE:
;*
;*	 push@	   struc  date/time
;*	 call	   dossetdatetime
;*
;*   MODULES CALLED:  PC-DOS Int 21h, ah=2bh, set date
;*				      ah=2dh, set time
;*
;*********************************************************************

	    global dossetdatetime
	    ; .sall
	    %include "macros.inc"

error_ts_datetime equ 0002h

struc str
old_bp: resw 1
return: resd 1
Data: resd 1; TOD data pointer
endstruc

dossetdatetime:
	    Enter    dossetdatetime	   ; push registers

	    lds      si,[bp].data	   ; set TOD data pointer and load
					   ;   info into registers
	    mov      ch,byte [si]	   ; load hour
	    mov      cl,byte [si]+1    ;	 minutes
	    mov      dh,byte [si]+2    ;	 seconds
	    mov      dl,byte [si]+3    ;	 hundredths

	    mov      ah,2dh		   ; set time opcode
	    int      21h		   ; set new time
	    push     ax 		   ; check for error later

	    mov      dl,byte [si]+4    ; load day
	    mov      dh,byte [si]+5    ;	 month
	    mov      cx,word [si]+6    ;	 year

	    mov      ah,2bh		   ; new date opcode
	    int      21h		   ; set new date

	    pop      bx
	    mov      cl,0
	    cmp      bl,cl		   ; return code from time set
	    jnz      error
	    cmp      al,0		   ; return code from date set
	    jz	     exit

error:	    mov      ax,error_ts_datetime  ; set error code
	    jmp      short exit1

exit:	    sub      ax,ax		   ; set good return code
exit1:	    Mexit			   ; pop registers
	    ret      str_size - 6	   ; return

; ENDP dossetdatetime

; END SECTION .dosxxx

	    ; end
