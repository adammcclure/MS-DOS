;

;
;*****************************************************************************
; Macro's
;*****************************************************************************
;


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
; External data declarations
;*****************************************************************************
;

	extern DriveLetter
	extern SystemDriveLetter
	extern CurrentHead
	extern CurrentCylinder
	extern FdskSiz
	extern SysSiz
	extern BadSiz
	extern DataSiz
	extern Drive_Letter_Msg
	extern PercentComplete
	extern AllocSize
	extern AllocNum
	extern Serial_Num_Low
	extern Serial_Num_High
	extern Command_Old_Ptr
	extern Msg_Allocation_Unit_Val

;
;*****************************************************************************
; Publics
;*****************************************************************************
;



;
;*****************************************************************************
; Message Retriever equates
;*****************************************************************************
;

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




SECTION .data
	; assume	ds:data


;
;*****************************************************************************
; Message Sublist Tables
;*****************************************************************************
;
;The  following  control  blocks  are	used   for   messages  with
;replaceable  paramaters.  These  control  blocks  are	used by  the
;SysDispMsg routine.
;

;---------------------------			;
Sublist_msgCurrentTrack:;				;AN000;
						;
	db		Sublist_Length		;				;AN000;
	db		Reserved		;				;AN000;
	dw		PercentComplete	;				;AN000;
	dw		data			;				;AN000;
	db		1			;				;AN000;
	db		Right_Align+Unsgn_Bin_Word ;				 ;AN000;
	db		3			;Max % is 100			;AN000;
	db		3			;Min % is 0			;AN000;
	db		Blank			;				;AN000;
;---------------------------			;
Sublist_msgInsertDisk:;				;AN000;
Sublist_msgReInsertDisk:;				;AN000;
Sublist_MsgHardDiskWarning:;
Sublist_msgFormatNotSupported:;				;AN000;

	db		Sublist_Length		;				;AN000;
	db		Reserved		;				;AN000;
	dw		DriveLetter	;				;AN000;
	dw		data			;				;AN000;
	db		1			;				;AN000;
	db		Left_Align+Char_Field_Char ;			   ;AN000;
	db		1			;				;AN000;
	db		1			;				;AN000;
	db		Blank			;				;AN000;
;---------------------------			;
Sublist_msgInsertDOSDisk:;				;AN000;
						;
	db		Sublist_Length		;				;AN000;
	db		Reserved		;				;AN000;
	dw		SystemDriveLetter;				;AN000;
	dw		data			;				;AN000;
	db		1			;				;AN000;
	db		Left_Align+Char_Field_Char ;				;AN000;
	db		1			;				;AN000;
	db		1			;				;AN000;
	db		Blank			;				;AN000;
;---------------------------			;
Sublist_msgTotalDiskSpace:;				;AN000;
						;
	db		Sublist_Length		;				;AN000;
	db		Reserved		;				;AN000;
	dw		FdskSiz		;				;AN000;
	dw		data			;				;AN000;
	db		1			;				;AN000;
	db		Right_Align+Unsgn_Bin_Dword ;				 ;AN000;
	db		10			;				;AN000;
	db		10			;4,000,000,000 limit		;AN000;
	db		Blank			;				;AN000;
;---------------------------			;
Sublist_msgSystemSpace:;				;AN000;
						;
	db		Sublist_Length		;				;AN000;
	db		Reserved		;				;AN000;
	dw		SysSiz		;				;AN000;
	dw		data			;				;AN000;
	db		1			;				;AN000;
	db		Right_Align+Unsgn_Bin_DWord ;			   ;AN000;
	db		10			;				;AN000;
	db		10			;64k*3 max			;AN000;
	db		Blank			;				;AN000;
;---------------------------			;
Sublist_msgBadSpace:;				;AN000;
						;
	db		Sublist_Length		;				;AN000;
	db		Reserved		;				;AN000;
	dw		BadSiz		;				;AN000;
	dw		data			;				;AN000;
	db		1			;				;AN000;
	db		Right_Align+Unsgn_Bin_DWord ;			   ;AN000;
	db		10			;				;AN000;
	db		10			;4,000,000,000 max		;AN000;
	db		Blank			;				;AN000;
;---------------------------			;
Sublist_msgDataSpace:;				;AN000;
						;
	db		Sublist_Length		;				;AN000;
	db		Reserved		;				;AN000;
	dw		DataSiz		;				;AN000;
	dw		data			;				;AN000;
	db		1			;				;AN000;
	db		Right_Align+Unsgn_Bin_DWord ;			   ;AN000;
	db		10			;				;AN000;
	db		10			;4,000,000,000 max		;AN000;
	db		Blank			;				;AN000;
;---------------------------			;
Sublist_msgWhatIsVolumeId?:;				;AN000;
						;
	db		Sublist_Length		;				;AN000;
	db		Reserved		;				;AN000;
	dw		DriveLetter	;				;AN000;
	dw		data			;				;AN000;
	db		1			;				;AN000;
	db		Left_Align+Char_Field_Char ;				;AN000;
	db		1			;				;AN000;
	db		1			;				;AN000;
	db		Blank			;				;AN000;
;---------------------------			;
Sublist_msgEXECFailure:;				;AN000;
						;
	db		Sublist_Length		;				;AN000;
	db		Reserved		;				;AN000;
	dw		Drive_Letter_Msg	;						;AN000;
	dw		data			;				;AN000;
	db		1			;				;AN000;
	db		Left_Align+Char_Field_ASCIIZ ;				;AN000;
	db		2			;				;AN000;
	db		2			;				;AN000;
	db		Blank			;				;AN000;
;---------------------------			;
Sublist_msgAllocNum:;				;AN000;
						;
	db		Sublist_Length		;				;AN000;
	db		Reserved		;				;AN000;
	dw		AllocNum 	;				;AN000;
	dw		data			;				;AN000;
	db		1			;				;AN000;
	db		Right_Align+Unsgn_Bin_Word ;				;AN000;
	db		10			;				;AN000;
	db		10			;				;AN000;
	db		Blank			;				;AN000;
;---------------------------			;
Sublist_msgAllocSize:;				;AN000;
						;
	db		Sublist_Length		;				;AN000;
	db		Reserved		;				;AN000;
	dw		AllocSize	;				;AN000;
	dw		data			;				;AN000;
	db		1			;				;AN000;
	db		Right_Align+Unsgn_Bin_DWord ;				  ;AN000;
	db		10			;				;AN000;
	db		10			;				;AN000;
	db		Blank			;				;AN000;
;---------------------------			;
Sublist_msgSerialNumber:;				;AN000;
						;
	db		Sublist_Length		;				;AN000;
	db		Reserved		;				;AN000;
	dw		Serial_Num_Low	;				;AN000;
	dw		data			;				;AN000;
	db		1			;				;AN000;
	db		Right_Align+Bin_Hex_Word ;				;AN000;
	db		4			;				;AN000;
	db		4			;				;AN000;
	db		'0'                     ;Display leading 0's            ;AN000;
	db		Sublist_Length		;				;AN000;
	db		Reserved		;				;AN000;
	dw		Serial_Num_High	;				;AN000;
	dw		data			;				;AN000;
	db		2			;				;AN000;
	db		Right_Align+Bin_hex_Word ;				;AN000;
	db		4			;				;AN000;
	db		4			;				;AN000;
	db		'0'                     ;                               ;AN000;

global Sublist_MsgParse_Error
Sublist_msgParse_Error:;				;AN000;

	db		Sublist_Length		;				;AN000;
	db		Reserved		;				;AN000;
	dw		0			;				;AN000;
	dw		Data			;				;AN000;
	db		0			;				;AN000;
	db		Left_Align+Char_Field_ASCIIZ ;			   ;AN000;
	db		20			;				;AN000;
	db		01			;				;AN000;
	db		Blank			;				;AN000;
;---------------------------			;
Sublist_MsgVerify:;				;AN000;
						;
	db		Sublist_Length		;				;AN000;
	db		Reserved		;				;AN000;
	dw		Msg_Allocation_Unit_Val; 			;AN000;
	dw		data			;				;AN000;
	db		1			;				;AN000;
	db		Right_Align+Unsgn_Bin_DWord;				;AN000;
	db		8			;				;AN000;
	db		8			;				;AN000;
	db		Blank
;
;*****************************************************************************
; Message Description Tables
;*****************************************************************************
;

;---------------------- 			;
Message_Number equ 1;				;AN000;
Handle equ No_Handle;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Input;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgBadDOSVersion	;				;AN000;
;---------------------- 			;
Message_Number equ 2;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ Sublist_msgCurrentTrack;				;AN000;
Count equ 1;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Input;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgCurrentTrack 	;				;AN000;
;---------------------- 			;
Message_Number equ 3;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ Sublist_msgDataSpace;				;AN000;
Count equ 1;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgDataSpace		;				;AN000;
;---------------------- 			;
Message_Number equ 4;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Input;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgFormatComplete	;				;AN000;
;---------------------- 			;
Message_Number equ 5;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ Sublist_msgBadSpace;				;AN000;
Count equ 1;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgBadSpace		;				;AN000;
;---------------------- 			;
Message_Number equ 6;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ Sublist_msgTotalDiskSpace;				;AN000;
Count equ 1;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgTotalDiskSpace	;				;AN000;
;---------------------- 			;
Message_Number equ 7;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ Sublist_msgInsertDisk;				;AN000;
Count equ 1;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgInsertDisk		;				;AN000;
;---------------------- 			;
Message_Number equ 8;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ Sublist_msgSystemSpace;				;AN000;
Count equ 1;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgSystemSpace		;				;AN000;
;---------------------- 			;
Message_Number equ 9;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ Sublist_msgReInsertDisk;				;AN000;
Count equ 1;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg   msgReInsertDisk		;				;AN000;
;---------------------- 			;
Message_Number equ 10;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgLabelPrompt		;				;AN000;
;---------------------- 			;
Message_Number equ 11;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ Sublist_msgFormatNotSupported;				;AN000;
Count equ 1;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgFormatNotSupported	;				;AN000;
;---------------------- 			;
Message_Number equ 12;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgInvalidDeviceParameters;				;AN000;
;---------------------- 			;
Message_Number equ 13;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgErrorInIOCTL 	;				;AN000;
;---------------------- 			;
Message_Number equ 14;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgNotBlockDevice	;				;AN000;
;---------------------- 			;
Message_Number equ 15;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgFATwriteError	;				;AN000;
;---------------------- 			;
Message_Number equ 16;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgDirectoryWriteError	;				;AN000;
;---------------------- 			;
Message_Number equ 17;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgAssignedDrive	;				;AN000;
;---------------------- 			;
Message_Number equ 18;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgNoSystemFiles	;				;AN000;
;---------------------- 			;
Message_Number equ 19;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgNetDrive		;				;AN000;
;---------------------- 			;
Message_Number equ 20;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgBadCharacters	;				;AN000;
;---------------------- 			;
Message_Number equ 21;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgParametersNotSupported ;				;AN000;
;---------------------- 			;
Message_Number equ 22;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgFormatFailure	;				;AN000;
;---------------------- 			;
Message_Number equ 23;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgNotSystemDisk	;				;AN000;
;---------------------- 			;
Message_Number equ 24;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgDiskUnusable 	;				;AN000;
;---------------------- 			;
Message_Number equ 25;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgBootWriteError	;				;AN000;
;---------------------- 			;
Message_Number equ 26;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgDirectoryReadError	;				;AN000;
;---------------------- 			;
Message_Number equ 27;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgNeedDrive		;				;AN000;
;---------------------- 			;
Message_Number equ 28;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	ContinueMsg		;				;AN000;
;---------------------- 			;
Message_Number equ 29;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgBadVolumeId		;				;AN000;
;---------------------- 			;
Message_Number equ 30;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Input;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgSystemTransfered	;				;AN000;
;---------------------- 			;
Message_Number equ 31;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ Sublist_msgWhatIsVolumeId?;				;AN000;
Count equ 1;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgWhatIsVolumeId?	;				;AN000;
;---------------------- 			;
Message_Number equ 32;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgIncompatibleParametersForHardDisk ;			;AN000;
;---------------------- 			;

Message_Number equ 33;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgWriteProtected	;				;AN000;
;---------------------- 			;
Message_Number equ 34;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgNotReady		;				;AN000;
;---------------------- 			;

Message_Number equ 35;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgPartitionTableReadErr ;				;AN000;
;---------------------- 			;
Message_Number equ 36;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ Sublist_msgSerialNumber;				;AN000;
Count equ 2;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgSerialNumber 	;			      ;AN000;
;---------------------- 			;
Message_Number equ 37;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgFormatBroken 	;				;AN000;
;---------------------- 			;
Message_Number equ 38;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ Sublist_msgEXECFailure;				;AN000;
Count equ 1;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgEXECFailure		;				;AN000;
;---------------------- 			;
Message_Number equ 39;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	NO_SYS_MESS		;				;AN000;
;---------------------- 			;
Message_Number equ 40;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgbadpartitiontable	;				;AN000;
;---------------------- 			;
Message_Number equ 41;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgParametersNotSupportedByDrive ;			;AN000;
;---------------------- 			;
Message_Number equ 42;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgCRLF 		;				;AN000;
;---------------------- 			;
Message_Number equ 43;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgInterrupt		;				;AN000;
;---------------------- 			;
Message_Number equ 44;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ Sublist_MsgInsertDOSDisk;				;AN000;
Count equ 1;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgInsertDOSDisk	;				;AN000;
;---------------------- 			;
Message_Number equ 45;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ Sublist_MsgHardDiskWarning;				;AN000;
Count equ 1;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgHardDiskWarning	;				;AN000;
;---------------------- 			;
Message_Number equ 46;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgFormatAnother?	;				;AN000;
;---------------------- 			;
Message_Number equ 47;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgPartitionTableReadError ;				;AN000;
;---------------------- 			;
Message_Number equ 48;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgPartitionTableWriteError ;				;AN000;
;---------------------- 			;
Message_Number equ 49;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgIncompatibleParameters ;				;AN000;
;---------------------- 			;
Message_Number equ 50;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ Sublist_MsgAllocNum;				;AN000;
Count equ 1;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgAllocNum		;				;AN000;
;---------------------- 			;
Message_Number equ 51;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ Sublist_MsgAllocSize;				;AN000;
Count equ 1;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgAllocSize		;				;AN000;
;---------------------- 			;
Message_Number equ 52;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgPartitionTableWriteErr ;				;AN000;
;---------------------- 			;
Message_Number equ 53;				;AN002;
Handle equ STDOUT;				;AN002;
Sublist equ No_Replace;				;AN002;
Count equ N_A;				;AN002;
Class equ Utility_Msg_Class;				;AN002;
Function equ No_Function;				;AN002;
Input equ N_A;				;AN002;
	Define_Msg	msgSameSwitch		;				;AN002;
;---------------------- 			;
Message_Number equ 54;				;AN009;
Handle equ STDOUT;				;AN009;
Sublist equ No_Replace;				;AN009;
Count equ N_A;				;AN009;
Class equ Utility_Msg_Class;				;AN009;
Function equ No_Function;				;AN009;
Input equ N_A;				;AN009;
	Define_Msg	msgBad_T_N		;				;AN009;
;---------------------- 			;
Message_Number equ 55;				;an019; dms;
Handle equ STDOUT;				;an019; dms;
Sublist equ Sublist_MsgVerify;				;an019; dms;
Count equ 1;				;an019; dms;
Class equ Utility_Msg_Class;				;an019; dms;
Function equ No_Function;				;an019; dms;
Input equ N_A;				;an019; dms;
	Define_Msg	MsgVerify		;				;an019; dms;
;---------------------- 			;
Message_Number equ 0;				;AN000;
Handle equ STDERR;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Ext_Err_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	Extended_Error_Msg	;				;AN000;
;----------------------
Message_Number equ 0;				;AN000;
Handle equ STDERR;				;AN000;
Sublist equ Sublist_MsgParse_Error;				;AN000;
Count equ 1;				;AN000;
Class equ Parse_Err_Class;				;AN000;
Function equ No_Function;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	Parse_Error_Msg 	;				;AN000;
;-----------------------



;
;These need to be coded as extended an parse errors, but left here to link.
;



Message_Number equ 70;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Input;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgOutOfMemory		;				;AN000;
;---------------------- 			;
Message_Number equ 71;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Input;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgBadDrive		;				;AN000;
;---------------------- 			;
Message_Number equ 10;				;AN000;
Handle equ StdErr;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Parse_Err_Class;				;AN000;
Function equ No_Input;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgInvalidParameter	;				;AN000;
;---------------------- 			;
Message_Number equ 73;				;AN000;
Handle equ STDOUT;				;AN000;
Sublist equ No_Replace;				;AN000;
Count equ N_A;				;AN000;
Class equ Utility_Msg_Class;				;AN000;
Function equ No_Input;				;AN000;
Input equ N_A;				;AN000;
	Define_Msg	msgLoadFailure		;				;AN000;









; END SECTION .data


