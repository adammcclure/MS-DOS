;fsexec equ true
SECTION .const;AC000;bgb
Len_FS_ID_String equ 8			; length of fat_12 and fat_16 strings ;AN000;bgb
Command_Line_Length equ 128		; length of command line area  ;AN000;bgb
Len_FS_String_End equ 8 		; length of rec.exe + 0H   ;AN000;bgb
FALSE	EQU	0
;TRUE	 EQU	 -1

bdos	equ	21h
boot	equ	20h
aread	equ	25h
awrite	equ	26h


;IBMVER	EQU	false ; not for single drive system ;AC000;bgb
;KANJI	EQU	true  ; set this to true for assembling jap version ;AC000;bgb
tab	equ	09h
aread	equ	25h
awrite	equ	26h
fcb	equ	5ch
FCB1	equ	5Ch
FCB2	equ	6Ch
FCB_Filename_Length	equ	11

NO			equ	0						;AN000;
YES			equ	not NO						;AN000;


Not_Include		equ	0
Do_Include		equ	1

No_Ext_Attrib		equ	0						;AN000;
No_Entry		equ	0


FAT12_File_System	equ 01h 						;AN000;
FAT16_File_System	equ 04h 						;AN000;
New_File_System 	equ 06h 						;AN000;

Bad_Exit		equ	0FFh			;Errorlevel = 0FFh	;AN000;

Net_Check		equ   1200h						;AN000;
Assign_Check		equ 8000h						;AN000;

DBCS_Lead		equ	81h
DBCS_Blank		equ  40h
DBCS_Vector_Size	equ 2
End_Of_Vector		equ 0
Blank			equ	" "                                             ;AN000;

Found_Yes		equ   1 						;AN000;
Found_No		equ    0						;AN000;

Asciiz_End		equ  0							;AN000;

Dir_Attribute		equ	10h
Vol_Attribute		equ	08h

Dir_Entries_Per_Sector	equ	512/32


Critical_Error_Fail	equ	3
Write_Protect		equ	0
Drive_Not_Ready 	equ	2


Len_FS_String_Buffer	equ	13

;Limits
BIG_FAT_THRESHOLD	equ 4086						;AN000;

; equates from recinit
;***********************************************
Multiplex		equ   2Fh			      ; 		;AN000;
Set_Append_X		equ 0B707h			   ;			;AN000;;
Append_X		equ    0B706h			       ;		;AN000;;
Append_X_Set		equ 1				   ;			;AN000;
Append_Off		equ  0				     ;			;AN000;
Append_ON		equ   1 			      ; 		;AN000;
fcb1			equ	05ch		;				;AN000;bgb

String_Done equ 0
No_Error equ	0
rec_error   equ     1
Stderr	equ	2
Len_FS_String_Buffer equ 13



;-------------------------------------------------------------------------------
; DATA STRUCTURES
;-------------------------------------------------------------------------------

struc Exec_Block_Parms
Segment_Env	dw  0
Offset_Command	dw  0
Segment_Command dw  0
Offset_FCB1	dw  0
Segment_FCB1	dw  0
Offset_FCB2	dw  0
Segment_FCB2	dw  0

endstruc



;-------------------------------------------------------------------------------
; media id
;-------------------------------------------------------------------------------
struc Media_ID;AN000;
Media_ID_Info_Level dw 0							;AN000;
Media_ID_Serial_Number dd 0							;AN000;
Media_ID_Volume_Label: times 11 db " ";AN000;
Media_ID_File_System: times 8 db " ";AN000;
endstruc;AN000;

;-------------------------------------------------------------------------------
; device parameters
;-------------------------------------------------------------------------------
struc A_DeviceParameters

SpecialFunctions: db 0
DeviceType: db 0
DeviceAttributes: dw 0
NumberOfCylinders: dw 0
MediaType: db 0
BytePerSector: dw 0
SectorsPerCluster: db 0
ReservedSectors: dw 0
NumberOfFATs: db 0
RootEntries: dw 0
TotalSectors: dw 0
MediaDescriptor: db 0
SectorsPerFAT: dw 0
SectorsPerTrack: dw 0
Heads: dw 0
HiddenSectors: dd 0
Ext_Total_Sectors: dd 0
Reserved_Area: times 6 db 0

endstruc




;-------------------------------------------------------------------------------
; relative sector buffer
;-------------------------------------------------------------------------------
struc Relative_Sector_Buffer;				;AN000;

Start_Sector_Low: dw 0;Low word of RBA sector 	;AN000;
Start_Sector_High: dw 0;High word of RBA sector	;AN000;
Number_Sectors: dw 0;Number of sectors		;AN000;
Buffer_Offset: dw 0;Address of data buffer 	;AN000;
Buffer_Segment: dw 0;				;AN000;

endstruc;				;AN000;


;-------------------------------------------------------------------------------
; xal ????
;-------------------------------------------------------------------------------
struc XAL;AN000;

XAL_Tsize: dw 0;AN000;
XAL_TCount: dw 0;AN000;
XAL_LSize: dw 0;AN000;
XAL_LCount: dw 0;AN000;
XAL_Data	db	512-times 8 db 0						;AN000;

endstruc;AN000;

;-------------------------------------------------------------------------------
; END SECTION .const
