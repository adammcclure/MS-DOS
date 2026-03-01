SECTION .data; AN000;bgb
;
;*****************************************************************************
; Macro's
;*****************************************************************************
%macro Define_Msg 1;				;AN000;
						;
Create_Msg Message_Name,Message_Number,Handle,Sublist,Count,Class,Function,Input;AN000;
						;
	%endmacro;				;AN000;

;-----------------------------------------------------------------------------

%macro Create_Msg 8;		;AN000;

global Parm1
Parm1:;				;AN000;
	dw	Parm2				;				;AN000;
	dw	Parm3				;				;AN000;
	dw	Parm4				;				;AN000;
	dw	Parm5				;				;AN000;
	db	Parm6				;				;AN000;
	db	Parm7				;				;AN000;
	dw	Parm8				;				;AN000;
	%endmacro;				;AN000;

;
;*****************************************************************************
; Message Retriever equates
;*****************************************************************************

Format_Msg		equ	'C'

N_A			equ	0
Sublist_Length		equ	11
None			equ	0

Blank			equ	" "
No_Function		equ	0
No_Replace		equ	0

Msg_Ser_Class		equ	0
Ext_Err_Class		equ	1
Parse_Err_Class 	equ	2
Utility_Msg_Class	equ	0FFh

Reserved		equ	0

;
;*****************************************************************************
; Message Sublist Tables
;*****************************************************************************
;
;The  following  control  blocks  are	used   for   messages  with
;replaceable  paramters.  These  control  blocks  are  used by	the
;SysDispMsg routine.
;

;---------------------------			;
Sublist_opnerr:; AN000;SM
						;
	db		Sublist_Length		; AN000;SM
	db		Reserved		; AN000;SM
	dw		fname_buffer 	   ; AN000;bgb
	dw		Dg			; AN000;SM
	db		0			; AN000;SM
	db		Left_Align+Char_Field_ASCIIZ ; AN000;SM
	db		14			; AN000;SM
	db		1			; AN000;SM
	db		Blank			; AN000;SM
;---------------------------			;
Sublist_Baddrv:; AN000;SM
						;
	db		Sublist_Length		; AN000;SM
	db		Reserved		; AN000;SM
	dw		Drive_Letter_Msg	   ; AN000;bgb
	dw		Dg			; AN000;SM
	db		0			; AN000;SM
	db		Left_Align+Char_Field_ASCIIZ ; AN000;SM
	db		4			; AN000;SM
	db		4			; AN000;SM
	db		Blank			; AN000;SM
;---------------------------			;
%ifdef fsexec;an022;bgb
Sublist_msg_EXECFailure:; AN000;SM			;an022;bgb
	db		Sublist_Length		; AN000;SM			;an022;bgb
	db		Reserved		; AN000;SM			;an022;bgb
	dw		Drive_Letter_Msg	   ; AN000;bgb			;an022;bgb
	dw		Dg		      ; AN000;SM			;an022;bgb
	db		1			; AN000;SM			;an022;bgb
	db		Left_Align+Char_Field_ASCIIZ ; AN000;SM 		;an022;bgb
	db		2			; AN000;SM			;an022;bgb
	db		2			; AN000;SM			;an022;bgb
	db		Blank			; AN000;SM			;an022;bgb
%endif;an022;bgb
;---------------------------			;
Sublist_msg_recmsg:; AN000;SM
						;
	db		Sublist_Length		; AN000;SM
	db		Reserved		; AN000;SM
	dw		rec_num		   ; AN000;bgb
	dw		Dg		      ; AN000;SM
	db		1			; AN000;SM
	db		Left_Align+Unsgn_Bin_Word ; AN000;SM
	db		5			; AN000;SM
	db		1			; AN000;SM
	db		Blank			; AN000;SM
;---------------------------			;
Sublist_msg_ofmsg:; AN000;SM
						;
	db		Sublist_Length		; AN000;SM
	db		Reserved		; AN000;SM
	dw		x_value_lo		   ; AN000;bgb
	dw		Dg		      ; AN000;SM
	db		1			; AN000;SM
	db		Left_Align+Unsgn_Bin_DWord ; AN000;SM
	db		10			; AN000;SM
	db		1			; AN000;SM
	db		Blank			; AN000;SM
	db		Sublist_Length		; AN000;bgb
	db		Reserved		; AN000;SM
	dw		y_value_lo		; AN000;SM
	dw		Dg		      ; AN000;SM
	db		2			; AN000;SM
	db		Left_Align+Unsgn_Bin_DWord ; AN000;SM
	db		10			; AN000;SM
	db		1			; AN000;SM
	db		Blank			; AN000;SM
;-----------------------------------------------------------------------
Drive_sublist:;AN000;bgb

    db	11		   ; sublist size      ;AN000;bgb
    db	0		   ;reserved	       ;AN000;bgb
    dw	driveletter ;offset of data	  ;AN000;bgb
    dw	dg		   ;seg of data  ;AN000;bgb
    db	1		   ; 1st replaceable parm  ;AN000;bgb
    db	char_field_asciiz  ; type = char       ;AN000;bgb
    db	2		   ; max field width   ;AN000;bgb
    db	2		   ; min field width   ;AN000;bgb
    db	' '                ; pad char (unused) ;AN000;bgb
;---------------------------			;				;an031;bgb
Sublist_msg_parserr:;				;an031;bgb
										;an031;bgb
	db		Sublist_Length		;11				;an031;bgb
	db		Reserved		;0				;an031;bgb
global movsi
movsi	dw		command_line_buffer	;off				;an031;bgb
	dw		dg			;seg				;an031;bgb
	db		0			;USE PERCENT ZERO		;an031;bgb
	db		Left_Align+Char_Field_ASCIIZ ;type of data		;an031;bgb
	db		128			;max width			;an031;bgb
	db		1			;min width			;an031;bgb
	db		Blank			;pad char			;an031;bgb
;---------------------------			;				;an031;bgb
;										;an000;bgb



;
;*****************************************************************************
; Message Description Tables
;*****************************************************************************
;

;---------------------- 			;
Message_Number equ 2; AN000;SM
Handle equ STDERR; AN000;SM
Sublist equ Sublist_Opnerr; AN000;SM
Count equ N_A; AN000;SM
Class equ EXT_ERR_CLASS; AN000;SM
Function equ NO_INPUT; AN000;SM
Input equ N_A; AN000;SM
	Define_Msg   opnerr			; AN000;SM File not found - xxxxxx
;---------------------- 			;
Message_Number equ 3; AN000;SM
Handle equ STDERR; AN000;SM
Sublist equ None; AN000;SM
Count equ N_A; AN000;SM
Class equ Utility_Msg_Class; AN000;SM
Function equ NO_INPUT; AN000;SM
Input equ N_A; AN000;SM
	Define_Msg   Substerr			; AN000;SM Can not recover SUBST or ASSIGNED drive
;---------------------- 			;
Message_Number equ 4; AN000;SM
Handle equ STDERR; AN000;SM
Sublist equ sublist_baddrv; AN000;SM
Count equ N_A; AN000;SM
Class equ UTILITY_MSG_CLASS; AN000;SM
Function equ NO_INPUT; AN000;SM
Input equ N_A; AN000;SM
	Define_Msg   baddrv			; AN000;SM Invalid drive or file name	  ;AN000;
;---------------------- 			;
Message_Number equ 5; AN000;SM
Handle equ STDERR; AN000;SM
Sublist equ None; AN000;SM
Count equ N_A; AN000;SM
Class equ UTILITY_MSG_CLASS; AN000;SM
Function equ NO_INPUT; AN000;SM
Input equ N_A; AN000;SM
	Define_Msg   dirmsg			; AN000;SM Warning - directory full	  ;AN000;
;---------------------- 			;
Message_Number equ 6; AN000;SM
Handle equ STDERR; AN000;SM
Sublist equ None; AN000;SM
Count equ N_A; AN000;SM
Class equ UTILITY_MSG_CLASS; AN000;SM
Function equ NO_INPUT; AN000;SM
Input equ N_A; AN000;SM
	Define_Msg   NotNetM			; AN000;SM Cannot recover a Network drive      ;AN000;
;---------------------- 			;
%ifdef fsexec;an022;bgb
 Message_Number equ 7;			;an022;bgb
 Handle equ STDERR;			;an022;bgb
 Sublist equ Sublist_msg_EXECFailure;			;an022;bgb
 Count equ 1;			;an022;bgb
 Class equ UTILITY_MSG_CLASS;			;an022;bgb
 Function equ NO_INPUT;			;an022;bgb
 Input equ N_A;			;an022;bgb
	 Define_Msg   MsgEXECFailure		 ;RECOVER not avail. on drive %1 ;AN022;bgb
%endif;an022;bgb
;---------------------- 			;
Message_Number equ 8; AN000;SM
Handle equ STDout; AN007;bgb
Sublist equ Sublist_msg_recmsg; AN000;SM
Count equ 1; AN000;SM
Class equ UTILITY_MSG_CLASS; AN000;SM
Function equ NO_INPUT; AN000;SM
Input equ N_A; AN000;SM
	Define_Msg   recmsg			; AN000;SM %1 file(s) recovered 	  ;AN000;
;---------------------- 			;
Message_Number equ 9; AN000;SM
Handle equ STDout; AN007;bgb
Sublist equ Sublist_msg_ofmsg; AN000;SM
Count equ 2; AN000;SM
Class equ UTILITY_MSG_CLASS; AN000;SM
Function equ NO_INPUT; AN000;SM
Input equ N_A; AN000;SM
	Define_Msg   ofmsg_ptr			; AN000;SM %1 of %2 bytes recovered	  ;AN000;
;---------------------- 			;
Message_Number equ 10; AN000;bgb
Handle equ STDout; AN007;bgb
Sublist equ drive_sublist; AN000;bgb
Count equ 1; AN000;SM
Class equ UTILITY_MSG_CLASS; AN000;SM
Function equ NO_INPUT; AN000;SM
Input equ N_A; AN000;SM
	Define_Msg   askmsg			; AN000;SM Press any key...		  ;AN000;
;---------------------- 			;
Message_Number equ 11; AN000;SM
Handle equ STDERR; AN000;SM
Sublist equ None; AN000;SM
Count equ N_A; AN000;SM
Class equ Utility_Msg_Class; AN000;SM
Function equ NO_INPUT; AN000;SM
Input equ N_A; AN000;SM
	Define_Msg   FATerrRead 		; AN000;SM Can not read File allocation table(s)
;---------------------- 			;
Message_Number equ 12; AN000;SM
Handle equ STDERR; AN000;SM
Sublist equ None; AN000;SM
Count equ N_A; AN000;SM
Class equ Utility_Msg_Class; AN000;SM
Function equ NO_INPUT; AN000;SM
Input equ N_A; AN000;SM
	Define_Msg   FATerrWrite		; AN000;SM Can not write file allocation table(s)
;---------------------- 			;
Message_Number equ 13; AN000;MT
Handle equ STDout; AN000;MT
Sublist equ None; AN000;MT
Count equ N_A; AN000;MT
Class equ Utility_Msg_Class; AN000;MT
Function equ NO_INPUT; AN000;MT
Input equ N_A; AN000;MT
	Define_Msg   CRLF_Ptr			; AN000;MT CR,LF
;---------------------------			;
Message_Number equ 0;				;AN000;
Handle equ STDERR;				;AN000;
Sublist equ None;				;AN000;
Count equ N_A;				;AN000;
Class equ Ext_Err_Class;				;AN000;
Function equ No_Input;				;AN000;
Input		=N_A				;				;AN000;
	Define_Msg  Extended_Error_Msg		;				;AN000;
;---------------------------			;
;-----------------------							;an000;bgb
Message_Number equ 0;				;an000;bgb
Handle equ STDERR;				;an000;bgb;AN000;
Sublist equ sublist_msg_parserr;				;an031;bgbbgb000;
Count equ 1;				;an031;bgb;AN000;
Class equ Parse_Err_Class;				;an000;bgb;AN000;
Function equ No_Function;				;an000;bgb;AN000;
Input equ N_A;				;an000;bgb;AN000;
	Define_Msg	Parse_Error_Msg 	;				;an000;bgb;AN000;
;---------------------- 			;
Message_Number equ 14; AN013;bgb
Handle equ STDERR; AN013;bgb
Sublist equ None; AN013;bgb
Count equ None; AN013;bgb
Class equ utility_msg_class; AN013;bgb
Function equ NO_INPUT; AN013;bgb
Input equ N_A; AN013;bgb
	Define_Msg   no_mem_arg 		; AN013;bgb insufficient memory


; END SECTION .Data
;	extrn	Drive_Letter_Msg:Byte
;	extrn	FName_Buffer:Byte
