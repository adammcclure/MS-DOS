; page	60,132;
; name	_replace
; title	Critical error or control break exit
;-------------------------------------------------------------------
;
;	MODULE: 	_replace
;
;	PURPOSE:	Supplies assembler exit routines for
;			critical error or control break situations
;
;	CALLING FORMAT:
;			crit_err_handler;
;			ctl_brk_handler;
;
;	DATE:		10/87
;
;-------------------------------------------------------------------


	global _crit_err_handler;AN000;
	global _ctl_brk_handler;AN000;

;-------------------------------------------------------------------
RET_EXIT equ	4ch			; terminate				;AN000;
CTLBRK	equ	3			; errorlevel return in al		;AN000;
ABORT	equ	2			; if >=, retry				;AN000;
XABORT	equ	1			; errorlevel return in al		;AN000;
;-------------------------------------------------------------------


SECTION .NULL;AN000;
; END SECTION .NULL;AN000;
SECTION ._DATA;AN000;
	extern _oldint24;AN000;
; END SECTION ._DATA;AN000;
SECTION .CONST;AN000;
; END SECTION .CONST;AN000;
SECTION ._BSS;AN000;
; END SECTION ._BSS;AN000;
SECTION .STACK;AN000;
; END SECTION .STACK;AN000;

; PGROUP	GROUP	_TEXT;AN000;
; DGROUP	GROUP	NULL, _DATA, CONST, _BSS, STACK;AN000;



SECTION ._TEXT;AN000;
	; ASSUME	CS:PGROUP;AN000;

	extern _restore;AN000;

;-------------------------------------------------------------------
; CRITICAL ERROR HANDLER
;-------------------------------------------------------------------
vector	dd	0			;receives a copy of _oldint24		;AN000;

_crit_err_handler:;AN000;

	pushf				; req by int24 handler			;AN000;
	push	ax			; will use ax				;AN000;
	push	ds			; will use ds				;AN000;

	mov	ax,dgroup		; setup 				;AN000;
	mov	ds,ax			;					;AN000;
	; ASSUME	DS:DGROUP;AN000;

	mov	ax,word _oldint24	; load vector so we can use it		;AN000;
	mov	word vector,ax	;					;AN000;
	mov	ax,word _oldint24+2 ;					;AN000;
	mov	word vector+2,ax	;					;AN000;

	pop	ds			; finished with ds			;AN000;
	; ASSUME	DS:NOTHING

	pop	ax			; finished with ax			;AN000;

	call	dword vector	; invoke DOS err hndlr			;AN000;

	cmp	al,ABORT		; what was the user's response          ;AN000;
	jnge	retry			;					;AN000;

	mov	ax,(RET_EXIT shl 8)+XABORT ; return to DOS w/criterr error	;AN000;
	call	call_restore		; restore user's orig append/x          ;AN000;
; =================== this call does not return ===============

retry:					;AN000;
	; ASSUME	DS:NOTHING
	; ASSUME	ES:NOTHING

	iret				; user response was "retry"		;AN000;

; ENDP _crit_err_handler;AN000;


;-------------------------------------------------------------------
; CONTROL BREAK HANDLER
;-------------------------------------------------------------------
_ctl_brk_handler:;AN000;

	; ASSUME	DS:NOTHING
	; ASSUME	ES:NOTHING

	mov	ax,(RET_EXIT shl 8)+CTLBRK ; return to DOS w/ctlbrk error	;AN000;
;-------------------------------------------------------------------
	call	call_restore		; restore user's orig append/x          ;AN000;
;-------------------------------------------------------------------
; =================== this call does not return ===============

; ENDP _ctl_brk_handler;AN000;

call_restore:
;input: ah has the RETURN TO DOS WITH RET CODE function request
;	al has the ERRORLEVEL return code to be passed back to DOS
;output: this routine does NOT RETURN, but exits to DOS with ret code.

	push	ax			;save errorlevel return code
	push	ds
	push	es

	mov	ax,dgroup		; setup "c" code regs			;AN000;
	mov	ds,ax			;					;AN000;
	; ASSUME	DS:DGROUP;AN000;

	mov	es,ax			;					;AN000;
	; ASSUME	ES:DGROUP;AN000;

;-------------------------------------------------------------------
	call	_restore		; restore user's orig append/x          ;AN000;
;-------------------------------------------------------------------

	pop	es
	pop	ds
	pop	ax			;restore return code
	int	21h			;					;AN000;
	int	20h			; in case int21 fails			;AN000;

; ENDP call_restore

; END SECTION ._TEXT; end code segment			;AN000;
	; end;AN000;
