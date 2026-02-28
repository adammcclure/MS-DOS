;
;Equates for COUNTRY INFORMATION.
SetCountryInfo		EQU	1	;country info
SetUcase		EQU	2	;uppercase table
SetLcase		EQU	3	;lowercase table (Reserved)
SetUcaseFile		EQU	4	;uppercase file spec table
SetFileList		EQU	5	;valid file character list
SetCollate		EQU	6	;collating sequence
SetDBCS 		EQU	7	;double byte character set
SetALL			EQU	-1	;all the entries


;DOS country and code page information table structure.
;Internally, DOS gives a pointer to this table.
;IBMBIO, MODE and NLSFUNC modules communicate with DOS through
;this structure.
struc DOS_country_cdpg_info
ccInfo_reserved: times 8 db 0;reserved for internal use
ccPath_CountrySys: times 64 db 0;path and filename for country info
ccSysCodePage		dw	0	;system code page id
ccNumber_of_entries	dw	6	; 6 entries
ccSetUcase		db	SetUcase
ccUcase_ptr: dd 0;pointer to Ucase table

ccSetUcaseFile		db	SetUcaseFile
ccFileUcase_ptr: dd 0;pointer to File Ucase table

ccSetFileList		db	SetFileList
ccFileChar_ptr: dd 0;pointer to File char list table

ccSetCollate		db	SetCollate
ccCollate_ptr: dd 0;pointer to collate table

ccSetDBCS		db	SetDBCS
ccDBCS_ptr: dd 0;pointer to DBCS  table

ccSetCountryInfo	db	SetCountryInfo
ccCountryInfoLen: dw 0;length of country info
ccDosCountry: dw 0;active country code id
ccDosCodePage: dw 0;active code page id
ccDFormat: dw 0;date format
ccCurSymbol		db	"    ",0;5 byte of (currency symbol+0)
cc1000Sep		db	" ",0   ;2 byte of (1000 sep. + 0)
ccDecSep		db	" ",0   ;2 byte of (Decimal sep. + 0)
ccDateSep		db	" ",0   ;2 byte of (date sep. + 0)
ccTimeSep		db	" ",0   ;2 byte of (time sep. + 0)
ccCFormat: db 0;currency format flags
ccCSigDigits: db 0;# of digits in currency
ccTFormat: db 0;time format
ccMono_Ptr: dd 0;monocase routine entry point
ccListSep		db	" ",0   ;data list separator
ccReserved_area: times 5 dw 0;reserved

endstruc

;Ucase table
struc CC_UCASE_TAB
ccUcase_leng	       dw	128
ccUcase_data: times 128 db 0
endstruc

;File Ucase table
struc CC_FILE_UCASE_TAB
ccFileucase_leng	dw	128
ccFileucase_data: times 128 db 0
endstruc

;File char list
struc CC_FILE_CHAR_TAB
ccFilechar_leng: dw 0
ccFilechar_data: times 46 db 0
endstruc

;collate table
struc CC_COLLATE_TAB
ccCollate_leng		dw	256
ccCollate_data: times 256 db 0
endstruc

;DBCS table -  for DOS 4.00
struc CC_DBCS_TAB
ccDBCS_leng	       dw      6
ccDBCS_data: times 6 db 0
endstruc

;						2/12/KK
; Define subfunctions of ECS_call ( 63H )	2/12/KK
;						2/12/KK
GetLeadBTBL	EQU	0	;		2/12/KK
SetInterimMode	EQU	1	;		2/12/KK
GetInterimMode	EQU	2	;		2/12/KK
				;		2/12/KK
NonInterimMode	EQU	0	;		2/12/KK
InterimMode	EQU	1	;		2/12/KK

OLD_COUNTRY_SIZE    equ     (type DOS_country_cdpg_info - ccDFormat - 10)
NEW_COUNTRY_SIZE    equ     (type DOS_country_cdpg_info - ccDosCountry)

;CAPITALIZATION equates
CAP_ONE_CHAR	    equ      20H
CAP_STRING	    equ      21H
CAP_ASCIIZ	    equ      22H
CHECK_YES_NO	    equ      23H
UPPER_TABLE	    equ      80H

;NLS_YES	     equ      59H
;NLS_yes2	     equ      79H
;NLS_NO 	     equ      4EH
;NLS_no2	     equ      6EH





