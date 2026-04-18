;******************************************************************************
;
;   (C) Copyright MICROSOFT Corp. 1986
;
;   Title:    CEMM.EXE - COMPAQ Expanded Memory Manager 386 Driver
;		EMMLIB.LIB - Expanded Memory Manager Library
;
;   Module:   EMMDEF.INC - defines for EMM code.
;
;   Version:  0.04
;
;   Date:     June 21, 1986
;
;******************************************************************************
;
;   Change log:
;
;     DATE    REVISION			DESCRIPTION
;   --------  --------	-------------------------------------------------------
;   06/21/86  Original
;   06/25/86  0.02	Changed HANDLE_CNT to 255 to match LIM spec (SBP).
;   06/28/86  0.02	Name change from CEMM386 to CEMM (SBP).
;   07/06/86  0.04	Changed save area struct (SBP).
;   05/25/88            Changed to meet LIM 4.0 Spec (PC)
;******************************************************************************
%ifndef INC_LIST
; .xlist
%endif

;******************************************************************************
;	G E N E R A L	D E F I N E S
;******************************************************************************
EMM_PAGE_CNT equ 2048; maximum of 2048 EMM pages (32MB)
HANDLE_CNT equ 255; maximum of 255 EMM handles
FRS_COUNT equ 16; number of 'Fast Register Sets'

EMM32_PHYS_PAGES equ 4; page frame contains 4 pages
;
; The 0 to 1M contains 64 physical pages.  Of these we are not mapping anything
; between E000 and FFFF, 0000 and 4000.  So the Maximum physcial pages we can
; get for mapping is 40.

TOT_PHYS_PAGES	equ	64
MAX_PHYS_PAGES	equ	40			; Life, the Universe
						; and Everything
PAGE_SIZE equ 1000h
;
; Of the above mappable pages the regions C000h to Dfffh have to be searched
; for the mappable pages.
;
ABOVE_CONV_STRT_SEG equ 0C000h
ABOVE_CONV_STRT_PG  equ ABOVE_CONV_STRT_SEG SHR 10
;
ABOVE_CONV_END_SEG  equ 0DC00h
ABOVE_CONV_END_PG   equ ABOVE_CONV_END_SEG SHR	10
;
MAX_ABOVE_CONV_PAGES	EQU 8
;
; Also the system memory mappable region starts at 4000h
;
CONV_STRT_SEG	    equ 4000h
CONV_STRT_PG	    equ CONV_STRT_SEG SHR 10
;
NUM_CONV_PGS	    equ (0A000h -4000h) SHR 10
;
; During init we keep track of mappable pages with an array of mappable_segs
;

PAGE_MAPPABLE	    equ     0FFh		    ;
PAGE_NOT_MAPPABLE   equ       0h		    ;


NULL_PAGE equ 0FFFFh
NULL_HANDLE equ 00FFFh


;
; Flags for memory move/xchg
;
Source_GT_Dest_Flag equ 80h; Source > Destination for copy / xchg
Overlap_Flag equ 40h; Copy overlapping memory
Backward_Copy_Flag equ 20h; copy is going to be backward
;
; Flags for PFlag use in Alter Map and Jump
;
PFLAG_VM equ 0002h; VM bit in High word of EFLAG
PFLAG_VIRTUAL equ 0020h; wheather it's call from virtual or proected mode
PFLAG_PATCH_CS_IP equ 0008h; Tell Protected mode dispatch to
					; patch new CS:IP onto it's return address
;******************************************************************************
;	S T A T U S   D E F I N E S
;******************************************************************************
OK equ 0
EMM_SW_MALFUNCTION equ 80h
EMM_HW_MALFUNCTION equ 81h
INVALID_HANDLE equ 83h
INVALID_FUNCTION equ 84h
NO_MORE_HANDLES equ 85h
SAVED_PAGE_DEALLOC equ 86h
NOT_ENOUGH_EXT_MEM equ 87h
NOT_ENOUGH_FREE_MEM equ 88h
ZERO_PAGES equ 89h
LOG_PAGE_RANGE equ 8Ah
PHYS_PAGE_RANGE equ 8Bh
SAVE_AREA_FULL equ 8Ch
MAP_PREV_SAVED equ 8Dh
NO_MAP_SAVED equ 8Eh
INVALID_SUBFUNCTION equ 8Fh

; LIM 4.0 extras

VALID_OVERLAP equ 92h
INSUFFICIENT_EMM_PAGES equ 93h
CONVENTIONAL_EMM_OVERLAP=	94h
INVALID_OFFSET equ 95h
INVALID_REGION_LENGTH equ 96h
OVERLAPPING_EXCHANGE equ 97h
INVALID_MEMORY_TYPE equ 98h
FRSETS_UNSUPPORTED equ 99h
INVALID_FRSET equ 9Ah
NO_MORE_FRSETS equ 9Bh
FRSET_NON_ZERO equ 9Ch
FRSET_UNDEFINED equ 9Dh
FRSET_NO_DMA equ 9Eh
FRSET_INVALID_DMA equ 9Fh
HANDLE_NAME_NOT_FOUND equ 0A0h
DUPLICATE_HANDLE_NAME equ 0A1h
INVALID_WRAPAROUND equ 0A2h
SOURCE_CORRUPTED equ 0A3h
ACCESS_DENIED equ 0A4h


;******************************************************************************
;	GET/SET PAGE MAP SUBFUNCTION CODES
;******************************************************************************
GSPM_GET	equ	0
GSPM_SET	equ	1
GSPM_GETSET	equ	2
GSPM_SIZE	equ	3

;
; OSEnabled Values
;
OS_IDLE 	equ	0
OS_ENABLED	equ	1
OS_DISABLED	equ	2

;******************************************************************************
;	 S T R U C T U R E S
;******************************************************************************

;
;  stack frame after pushad on real/virtual mode entry
;
struc r67_Frame
rDI: resd 1
rSI: resd 1
rBP: resd 1
rSP: resd 1
rBX: resd 1
rDX: resd 1
rCX: resd 1
rAX: resd 1
retaddr: resw 1
rCS: resw 1
PFlag: resw 1
rDS: resw 1
rES: resw 1
rGS: resw 1
rFS: resw 1
endstruc


;
; for _handle_table
;
struc HandleTable_struc
ht_index	dw	NULL_PAGE	; index into emm_page for handle's pgs
ht_count	dw	0		; number of emm_pages for this handle
endstruc

;
; for _save_area
;
struc SaveMap_struc
s_handle	dw	NULL_HANDLE				; owning handle
s_map		dw	EMM32_PHYS_PAGES dup (NULL_PAGE)	; EMM page #s
endstruc

;
; structure linking segment with physical page number
;
struc Mappable_Page
mappable_seg: resw 1
mappable_pg: resw 1
endstruc

;
; Get Partial Page Map
;
struc gppm_struc
gppm_count: resw 1
gppm_segs: resw 1
endstruc

;
; Structures used as arguments to Map Handle Array function
;

; For subfunction 0:
struc mha_array0
mha0_log_pg: resw 1
mha0_phys_pg: resw 1
endstruc

; For subfunction 1:
struc mha_array1
mha1_log_pg: resw 1
mha1_seg: resw 1
endstruc

; Used by Map and Jump and Map and Call -- Identical to mha_array0 and 1
struc log_phys_map_struct
log_page_number: resw 1
phys_page_number_seg: resw 1
endstruc

; Map and Jump structure
struc maj_struct
maj_target_address: resd 1
maj_log_phys_map_len: resb 1
maj_map_address: resd 1
endstruc

; Map and Call structure
struc mac_struct
mac_target_address: resd 1
mac_new_page_map_len: resb 1
mac_new_map_address: resd 1
mac_old_page_map_len: resb 1
mac_old_map_address: resd 1
mac_reserved: resb 8
endstruc

; Move / Exchange memory structure
struc mem_memory_descriptor_struct
mem_memory_type: resb 1
mem_handle: resw 1
mem_initial_offset: resw 1
mem_initial_seg_page: resw 1
endstruc


struc mem_struct
mem_region_length: resd 1
mem_source	    db	(mem_memory_descriptor_struct_size) dup (?)
mem_dest	    db	(mem_memory_descriptor_struct_size) dup (?)
endstruc

;
; Fast Register Set Description
;
struc FRS_struc
FRS_Window	dw	MAX_PHYS_PAGES dup (NULL_PAGE)	; emm page numbers
FRS_alloc	dw	0				; Is this set allocated
endstruc

	; page
;****************************************************************************
;
;   Dword_Align -- Aligns code to dword boundry by inserting nops
;
;****************************************************************************

%macro Dword_Align 1
%if (($ - 0) MOD 4)
	db	90h		     ;; Nop in code / else byte of 90h in data
	Dword_Align Seg_Name
%endif
	    %endmacro

	; page
;***********************************************
;
; Validate_Handle - check the handle in DX
;
;	ENTRY:	Handle as per LIM4.0 spec. in DX
;
;	EXIT:	If the handle is invalid jump To Death_Label, otherwise,
;		EDX points to the _handle_table entry for the handle
;
;	USES:	EDX
;
;***********************************************
%macro Validate_Handle 1

	cmp	dx, [_handle_table_size]	;Q: handle in range ?
	jae	Death_Label			;  N: go to error label
	shl	dx, 2				;  Y: convert handle to
	add	dx, _handle_table	;     pointer
	xchg	bx, dx
	cmp	[bx+ht_index], NULL_PAGE	;Q: is this handle active ?
	xchg	bx, dx
	je	Death_Label			;  N: return error

	%endmacro

;***********************************************
;
; Handle2HandlePtr - convert the handle in DX to
;		points into handle_table
;
;	ENTRY:	Handle as per LIM4.0 spec. in DX
;
;	EXIT:	EDX points to the _handle_table entry for the handle
;
;	USES:	EDX
;
;***********************************************
%macro Handle2HandlePtr 0

	shl	dx, 2				;  Y: convert handle to
	add	dx, _handle_table	;     pointer

	%endmacro

; .list; end of EMMDEF.INC



