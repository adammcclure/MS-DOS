;0
; page 80,132

;**********************************************************************
;*
;*   MODULE:   set_int24_vector
;*
;*   Critical error handler for C programs BACKUP and RESTORE
;*
;*********************************************************************
;------------------------------------------------------------;;;;AN000;
SECTION .databuff;;;;AN000;
; END SECTION .databuff;;;;AN000;
;------------------------------------------------------------;;;;AN000;


SECTION .dosxxx;AN000;
	; assume	cs:dosxxx,ds:nothing,es:nothing,ss:nothing;AN000;


	    global set_int24_vector;AN000;
	    ; .sall;AN000;
	    ; .xlist;AN000;
	    %include "macros.inc";AN000;
	    ; .list;AN000;

struc str;AN000;
old_bp: resw 1;AN000;
Return: resd 1;AN000;
Flag: resw 1;AN000;
endstruc;AN000;


set_int24_vector:;AN000;
	Enter	set_int24_vector				;AN000;

	mov	ax,seg databuff 				;AN000;
	mov	ds,ax						;AN000;
	; assume	ds:databuff;AN000;

	mov	ax,03524h		;Get Int24 Vector	;AN000;
	int	21h						;AN000;
					;Save it
	mov	word cs:OldInt24,bx 			;AN000;
	mov	word cs:OldInt24+2,es			;AN000;

					;Get address of my Int24 Handler
	mov	dx,cs						;AN000;
	mov	ds,dx						;AN000;
	mov	dx,AppErrorHandler			;AN000;

	mov	ax,02524H	       ;Set new INT24 vector	;AN000;
	int	21h						;AN000;

	xor	ax,ax		       ;Set good error return	;AN000;

exit:	mexit			       ; pop all registers	;AN000;
	ret	str_size - 6	       ; return 		;AN000;

; ENDP set_int24_vector;AN000;





;-------------------------------------------------------
;
;	    ****   Error Handler  ******
;
;-------------------------------------------------------
Ignore		equ	0		;AN000;
Retry		equ	1		;AN000;
Abort		equ	2		;AN000;
Fail		equ	3		;AN000;

OldInt24: dd 0;AN000; ;save old interrupt handler address  ;;;

AppErrorHandler:;AN000;
	pushf				;AN000;
	call	dword cs:OldInt24	;AN000; Get user to respond
	cmp	al,Abort		;AN000; For any resonse other than Abort
	jne	rett			;AN000;  retry the operation

	int	023h			;AN000;

rett:					;AN000;
	iret				;AN000; return to caller
; ENDP AppErrorHandler;AN000;
;-------------------------------------------------------
;-------------------------------------------------------

; END SECTION .dosxxx;AN000;
	   ; end;AN000;
