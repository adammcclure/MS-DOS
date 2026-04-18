SECTION .CODE;
	; ASSUME	CS:CODE,DS:CODE;
					;
CR	EQU	13			;
LF	EQU	10			;
					;
	global ERROR_1B;
	global ERROR_1A;
	global ERROR_2;
	global ERROR_3;
;;	PUBLIC	MSG_4			;
					;
%include "DISPMES.INC"
					;
; END SECTION .CODE;
	; END;
