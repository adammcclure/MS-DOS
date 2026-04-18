	; page	60,132
;			$SALUT (4,25,30,41)

			%include "pridefs.inc"

BREAK			<Transient Messages>

;
;	DOS PRINT
;
;	Transient Service code
;
;	02/13/84	MAU	Fixed bug with BadCanMes
;
;	05/20/87	FJG	Change format to new Message Service
;				Routines/Parse code
;


%macro addr 2
			global name
			%ifidn <name>,<>

			    dw	 sym
			%else

; name			    dw	 offset dg:sym
			%endif
			%endmacro


			SECTION .Code

			global SYSGETMSG, SYSLOADMSG, SYSDISPMSG

			; ASSUME CS:DG,DS:nothing,ES:nothing,SS:Stack

; include msgserv.asm

			; .xlist
			; .xcref
			MSG_SERVICES <MSGDATA>
			MSG_SERVICES <NEARmsg,LOADmsg,GETmsg,DISPLAYmsg,INPUTmsg,CHARmsg>
			; .cref
			; .list

; include message class 1, 2, A, B, C, and D

			; .xlist
			; .xcref
			MSG_SERVICES <NEARmsg,PRINT.CL1,PRINT.CL2>
			MSG_SERVICES <NEARmsg,PRINT.CLA,PRINT.CLB,PRINT.CLC,PRINT.CLD>
			; .cref
			; .list
;  $SALUT (4,4,9,41)


;			$SALUT (4,25,30,41)
false equ 0

DateSW			equ  false
TimeSW			equ  false
CmpxSW			equ  false
KeySW			equ  false
QusSW			equ  false
Val2SW			equ  false
Val3SW			equ  false

;  $SALUT (4,4,9,41)

   global SYSPARSE

					; include parse.asm

					;xlist
					;xcref
   %include "parse.asm"
					;cref
					;list

   ; END SECTION .CODE

   ; end
