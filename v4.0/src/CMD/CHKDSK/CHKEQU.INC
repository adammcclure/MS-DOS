;fsexec  equ	 true			     ;				     ;	 ;an038;bgb  ;
FCB	EQU	5CH

String_Done equ 0
No_Error equ	0
chk_Error   equ     1
Stderr	equ	2

FALSE	EQU	0
TRUE	EQU	~FALSE

; NOTE WARNING DANGER.
; THIS EQU DEFINES AN OFFSET INTO THE SEARCH FCB OF THE LASTENT VALUE.
; ITS LOCATION MAY CHANGE FROM DOS VERSION TO DOS VERSION.
;2.0/2.1 value
;THISENT EQU	 17H			 ;Relative entry number of current entry
;3.0 value
THISENT EQU	14H				;Relative entry number of current entry


;Attribute bits

RDONLY	EQU	1
HIDDN	EQU	2
SYSTM	EQU	4
VOLIDA	EQU	8
ISDIR	EQU	10H
DRVCHAR EQU	":"
;
;*****************************************************************************
; Equates
;*****************************************************************************
;

Multiplex equ	2Fh				;				;AN000;
Set_Append_X equ 0B707h 			;				;AN000;;
Append_X equ	0B706h				;				;AN000;;
Append_X_Set equ 1				;				;AN000;
Append_Off equ	0				;				;AN000;
Append_ON equ	1				;				;AN000;


Disk_Error	equ	80h			;INT 24h bit clear if disk error;AN000;

NO	equ	0								;AN000;
YES	equ	not NO								;AN000;

Year_Mask	equ	0FE00h
Month_Mask	equ	01E0h
Day_Mask	equ	001Fh
Hour_Mask	equ	0F800h
Minute_Mask	equ	07E0h

Not_Include	equ	0
Do_Include	equ	1


YES_Found equ	1
NO_Found equ	0

ON	equ	1
OFF	equ	0

No_Ext_Attrib	equ	0							;AN000;
No_Entry	equ	0
XA_Chain	equ	84h			;Mark head of XA chain		;AN000;

%ifdef fsexec;an038;bgb
Len_FS_String_Buffer	equ	13						;an038;bgb
FAT12_File_System equ 01h							;an038;bgb;AN000;
FAT16_File_System equ 04h							;an038;bgb;AN000;
New_File_System equ 06h 							;an038;bgb;AN000;
%endif

Bad_Exit	equ	0FFh			;Errorlevel = 0FFh		;AN000;

Net_Check equ	1200h								;AN000;
Assign_Check equ 8000h								;AN000;

Found_Yes equ	1								;AN000;
Found_No equ	0								;AN000;

Asciiz_End equ	0								;AN000;

Dir_Attribute	equ	10h
Vol_Attribute	equ	08h

Dir_Entries_Per_Sector	equ	512/32


Critical_Error_Fail	equ	3
Write_Protect	equ	0
Drive_Not_Ready equ	2

Blank	equ	" "                                                             ;AN000;

Head_Mask	equ	7Fh			;Mask to turn off head bit	;AN000;


;Limits
BIG_FAT_THRESHOLD equ 4086							;AN000;



;-------------------------------------------------------------------------------
; These are the data structures which we will need
;****************************************************************************
; Structures
;****************************************************************************
%ifdef fsexec;an038;bgb
struc Exec_Block_Parms;an038;bgb
Segment_Env dw	0								;an038;bgb
Offset_Command dw 0								;an038;bgb
Segment_Command dw 0								;an038;bgb
Offset_FCB1 dw	0								;an038;bgb
Segment_FCB1 dw 0								;an038;bgb
Offset_FCB2 dw	0								;an038;bgb
Segment_FCB2 dw 0								;an038;bgb
endstruc;an038;bgb

struc Media_ID;AN000;
Media_ID_Info_Level dw 0							;AN000;
Media_ID_Serial_Number dd 0							;AN000;
Media_ID_Volume_Label: resb 11;AN000;
Media_ID_File_System: resb 8;AN000;
endstruc;AN000;
%endif;an038;bgb

struc Sublist_Struc
Sublist_Size: resb 1;				;AN000;
Sublist_Rsv: resb 1;				;AN000;
Sublist_Offset: resw 1;				;AN000;
Sublist_Segment: resw 1;				;AN000;
Sublist_Number: resb 1;				;AN000;
Sublist_Type: resb 1;				;AN000;
Sublist_Max: resb 1;				;AN000;
Sublist_Min: resb 1;				;AN000;
Sublist_Char: resb 1;				;AN000;
endstruc

struc A_DeviceParameters

SpecialFunctions: resb 1;1  0
DeviceType: resb 1;1  1
DeviceAttributes: resw 1;2  2
NumberOfCylinders: resw 1;2  4
MediaType: resb 1;1  6
BytePerSector: resw 1;2  7
SectorsPerCluster: resb 1;
ReservedSectors: resw 1
NumberOfFATs: resb 1
RootEntries: resw 1
TotalSectors: resw 1
MediaDescriptor: resb 1
SectorsPerFAT: resw 1
SectorsPerTrack: resw 1
Heads: resw 1
HiddenSectors: resd 1
Ext_Total_Sectors: resd 1
ReservedArea: resb 6

endstruc




struc Relative_Sector_Buffer;				;AN000;

Start_Sector_Low: resw 1;Low word of RBA sector 	;AN000;
Start_Sector_High: resw 1;High word of RBA sector	;AN000;
Number_Sectors: resw 1;Number of sectors		;AN000;
Buffer_Offset: resw 1;Address of data buffer 	;AN000;
Buffer_Segment: resw 1;				;AN000;

endstruc;				;AN000;


struc XAL;AN000;

XAL_Tsize: resw 1;AN000;
XAL_TCount: resw 1;AN000;
XAL_LSize: resw 1;AN000;
XAL_LCount: resw 1;AN000;
XAL_Data	db	512-times 8 db 0						;AN000;

endstruc;AN000;

struc DIRENT
	resb 7;Ext FCB junk
	resb 1;Drive
DIRNAM: resb 11;
DIRATT: resb 1;
DIRCP: resw 1;				;AN000;
DIR_XA: resw 1;				;AN000;
DIRATT2: resb 1;				;AN000;
DIRRES: resb 5;				;AC000;
DIRTIM: resw 1;
DIRDAT: resw 1;
DIRCLUS: resw 1;
DIRESIZ: resd 1;
endstruc;
ENTSIZ	EQU	DIRENT_size

;-------------------------------------------------------------------------------

