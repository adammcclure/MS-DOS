	; page	60,132
;			$SALUT (4,25,30,41)
			%include "pridefs.INC"

BREAK			<Resident Portion Messages>

;
;	DOS PRINT
;
;	Resident Portion Messages
;
;	02/15/84	MAU	Created as a separate link module
;				from the include file. should
;				always be linked first!!
;
;	05/20/87	FJG	Change format to new Message Service
;				Routines
;

SECTION .CodeR

			; ASSUME CS:CodeR,DS:nothing,ES:nothing,SS:nothing

			global R_MES_BUFF
					;--------------------------------------
					;INT 24 messages A La COMMAND
					;--------------------------------------

R_MES_BUFF:; Room is generated for:

			times 512 db 0;  ERR0
					;  ERR1
					;  ERR2
					;  ERR3
					;  ERR4
					;  ERR5
					;  ERR6
					;  ERR7
					;  ERR8
					;  ERR9
					;  ERR10
					;  ERR11
					;  ERR12
					;

; END SECTION .CodeR

			; End
