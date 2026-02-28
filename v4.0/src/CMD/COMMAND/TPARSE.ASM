 ; page 80,132
;	SCCSID = @(#)tparse.asm 4.1 87/04/28
;	SCCSID = @(#)tparse.asm 4.1 87/04/28
; TITLE	COMMAND interface to SYSPARSE

; .xlist
; .xcref
	%include "comseg.asm";AN000;
; .list
; .cref

SECTION .TRANSPACE;AN000;

	CmpxSW	equ	0		;AN000; do not check complex list
	KeySW	equ	0		;AN000; do not support keywords
	Val2SW	equ	0		;AN000; do not Support value definition 2
	IncSW	equ	0		;AN000; do not include psdata.inc
	QusSW	equ	0		;AN025; do not include quoted string
	LFEOLSW equ	0		;AN044; do not use 0ah as line terminator

; .xlist
; .xcref

%include "psdata.inc";AN000;

; .list
; .cref

; END SECTION .TRANSPACE;AN000;

SECTION .TRANCODE;AN000;

; ASSUME	CS:TRANGROUP,DS:NOTHING,ES:NOTHING,SS:NOTHING;AN054;

; ****************************************************************
; *
; * ROUTINE:	 CMD_PARSE
; *
; * FUNCTION:	 Interface for transient COMMAND to invoke
; *		 SYSPARSE.
; *
; * INPUT:	 inputs to SYSPARSE
; *
; * OUTPUT:	 outputs from SYSPARSE
; *
; ****************************************************************

	global Cmd_parse;AN000;

; .xlist
; .xcref
	%include "parse.asm";AN000;
; .list
; .cref

Cmd_parse:;AN000;

	call	sysparse		;AN000;

	ret				;AN000;

; ENDP Cmd_parse;AN000;

	global Append_parse;AN010;

Append_parse:;AN010;

	call	sysparse		;AN010;

	ret				;AN010;

; ENDP Append_parse;AN010;

; END SECTION .trancode;AN000;
	    ; end;AN000;
