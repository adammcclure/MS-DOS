
%macro BREAK 1
	; SUBTTL	subtitle
	; PAGE
%endmacro


;
;******************************************************************************
; Message Macro Definitions
;******************************************************************************
;

      extern Display_Interface


;-----------------------------------------------------------------------------

%macro Message 1;				;AN000;
						;
	mov	dx,Message_Name	;				;AN000;
	call	Display_Interface		;				;AN000;
						;
	%endmacro;				;AN000;

;-----------------------------------------------------------------------------

%macro Parse_Message 0;				;AN000;

						;
	push	ds
	mov	dx,dg
	mov	ds,dx
	mov	word Parse_Error_Msg,ax	;				;AN000;
	mov	dx,Parse_Error_Msg	;				;AN000;
	call	Display_Interface		;				;AN000;
	pop	ds				;
	%endmacro;				;AN000;

;-----------------------------------------------------------------------------

%macro Extended_Message 0;				;AN000;
						;

	push	ds
	mov	dx,dg
	mov	ds,dx
	mov	word Extended_Error_Msg,ax	  ;				  ;AN000;
	mov	dx,Extended_Error_Msg    ;				   ;AN000;
	call	Display_Interface		;				;AN000;
	pop	ds
	%endmacro;				;AN000;
;
;*****************************************************************************
; General Macro's
;*****************************************************************************
;

%macro Procedure 2;				;AN000;
						;
global Proc_Name;				;AN000;
Proc_Name:;				;AN000;

	%endmacro;				;AN000;
;-----------------------------------------------------------------------------

%macro DOS_Call 1;				;AN000;
						;
	mov	ah,Function			;				;AN000;
	int	21h				;				;AN000;
						;
	%endmacro;				;AN000;

;-----------------------------------------------------------------------------

%macro Popff 0

; Assume	cs:DG

	jmp	$+3
	iret
	push	cs
	call	$-2

; Assume	cs:code

	%endmacro

;-----------------------------------------------------------------------------

%macro Set_Data_Segment 0

	push	ax
	mov	ax,dg				;Point to data segment
	mov	ds,ax				;
	push	ds
	pop	es
	pop	ax

	; .LALL
	; assume	ds:dg,es:dg
	.XALL
	%endmacro

