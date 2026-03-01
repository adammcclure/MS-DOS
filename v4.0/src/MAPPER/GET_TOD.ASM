;
; page 80,132
;
; title CP/DOS DosGetDateTime mapper
;
SECTION .dosxxx
	; assume	cs:dosxxx,ds:nothing,es:nothing,ss:nothing
;
;**********************************************************************
;*
;*   MODULE:   dosgetdatetime
;*
;*   FUNCTION:	get date and time information
;*
;*   CALLING SEQUENCE:
;*
;*	 push@	   struc  date/time
;*	 call	   dosgetdatetime
;*
;*   MODULES CALLED:  PC-DOS Int 21h, ah=2ah, get date
;*				      ah=2ch, get time
;*
;*********************************************************************

	    global dosgetdatetime
	    ; .sall
	    %include "macros.inc"

struc str
old_bp: resw 1
return: resd 1
data: resd 1; date and time info return pointer
endstruc

dosgetdatetime:

	    Enter    dosgetdatetime	   ; push registers

	    lds      si,[bp].data	   ; set return data area

	    mov      ah,2ch		   ; get time information
	    int      21h
					   ; save info in return data are
	    mov      byte [si],ch	   ; save hour
	    mov      byte [si]+1,cl    ;	 minutes
	    mov      byte [si]+2,dh    ;	 seconds
	    mov      byte [si]+3,dl    ;	 hundredths

	    mov      ah,2ah		   ; get date  and save it
	    int      21h		   ;	in return data area

	    mov      byte [si]+4,dl    ; save day
	    mov      byte [si]+5,dh    ;	 month
	    mov      word [si]+6,cx    ;	 year
	    mov      word [si]+8,360   ;	 min. from GMT
	    mov      byte [si]+10,al   ;	 day of week

exit:	    sub      ax,ax		   ; set good return code

	    Mexit			   ; pop registers
	    ret      str_size - 6	   ; return

; ENDP dosgetdatetime

; END SECTION .dosxxx

	    ; end
