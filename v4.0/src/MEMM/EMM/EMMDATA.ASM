; page	58,132
;******************************************************************************
	; title	EMMDATA - EMM data structures definitions
;******************************************************************************
;
;   (C) Copyright MICROSOFT Corp. 1986
;
;   Title:	CEMM.EXE - COMPAQ Expanded Memory Manager 386 Driver
;		EMMLIB.LIB - Expanded Memory Manager Functions Library
;
;   Module:	EMMDAT
;
;   Version:	0.04
;
;   Date:	June 14,1986
;
;******************************************************************************
;
;   Change log:
;
;     DATE    REVISION                  DESCRIPTION
;   --------  --------  -------------------------------------------------------
;   06/14/86		Added MapSize  (SBP)
;   06/27/86  0.02	Reordered tables to place size dependent ones at end.
;   06/28/86  0.02	Name change from CEMM386 to CEMM (SBP).
;   07/06/86  0.04	Made _emm_page,_emm_free, and _pft386 pointers instead
;			of labels to allow sizing of these arrays based on the
;			number of pages in the system. Also added _emm_brk.
;   ?	      0.05	Modified for WIN386
;   05/06/88  0.06	Modified back for MEMM.
;
;******************************************************************************
;
;   Functional Description:
;	data definitions for emm/lim
;
;
;******************************************************************************
; .lfcond; list false conditionals
CPU 386
;	include	protseg.inc
	%include "vdmseg.inc"
	%include "vdmsel.inc"
	%include "page.inc"
	%include "emmdef.inc"

SECTION ._DATA

	global EMM_PAGE_CNT
	global HANDLE_CNT

	global _total_pages
	global _EMMstatus
	global _emm40_info
	global _page_frame_base
	global _mappable_pages
	global _mappable_page_count
	global _physical_page_count
	global _page_frame_pages
	global EMM_MPindex
	global _EMM_MPindex
	global _save_map
	global _handle_table
	global _Handle_Name_Table
	global _handle_table_size
	global _handle_count
	global _emmpt_start
	global _free_top
	global _free_count
	global _emm_page
	global _emm_free
	global _pft386
	global _emm_brk
	global EMM_dynamic_data_area
	global EMM_data_end
	global _regp
	global EMM_savES
	global EMM_savDI
	global CurRegSet
	global _CurRegSet
	global CurRegSetn
	global FRS_array
	global FRS_free
	global PF_Base
	global _PF_Base
	global _OSEnabled
	global _OSKey
	global _VM1_EMM_Pages
	global _cntxt_pages
	global _cntxt_bytes



;******************************************************************************
; DATA STRUCTURES FOR MEMM
;
; The data structures are documented below.  Only a description of how
; emm interfaces with the page table memory mananger is appropriate here
;
; During initialisation the pages in the physical address space to be devoted
; to emm are indicated in the _pft386 array.  This array translates the emm
; page number to a pte in the system page table.
;
; The emm pages currently free are copied to the emm_free stack and the
; free_stack pointer points to the top of this stack.
;
; When pages are allocated to a handle the pages are allocated from the stack
; and copied to the emm_page array.  The place where a handles pages are
; copied to in this array is recorded in the handle table.  The emm_page array
; should be kept compacted all the time.  Thus if a handle is deallocated, the
; pages allocated to the handle are copied to the emm_free stack and the hole
; left behind in the emm_page array is compacted by shifting all the entries
; below upwards updating the indexes stored in the handle table if needed.
;
; given map_handle_page(phys_page, log_page, handle)
;
;   a. determine pte offset in system page table corresponding to phys_page
;      from the _page_frame_base table.
;
;   b. access handle table for the handle and determine the start of the
;      emm pages allocated to the handle in the emm_page array.
;
;   c. add log_page to this start offset in the emm_page array and access
;      the entry in this array.  This entry is an offset into the _pft386
;      array for the emm page under consideration.
;
;   d. use this index into _pft386 to access the pte for the log page under
;      consideration.
;
;   e. store this pte in the pte offset corresponding to the phys_page as
;      determined in a.
;******************************************************************************






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;00. EMM Status
; Current status of `HW'. The way this is handled is that
; when returning status to caller, normal status is reported 
; via EMMstatus being moved into AX. Persistant errors
; (such as internal datastructure inconsistancies, etc) are
; placed in `EMMstatus' as HW failures. All other errors are 
; transient in nature (out of memory, handles, ...) and are 
; thus reported by directly setting AX. The EMMstatus variable
; is provided for expansion and is not currently being
; set to any other value.
;
; set to OK for now. when integrated, the value should be
; set to EMM_HW_MALFUNCTION (81H) initially, then set to
; OK (00H) when the `EMM ON' function is invoke
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_EMMstatus:
	DW	00H


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;01. Register Block Pointer
;	points to the the vm86 regs on the
;	stack
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_regp:
	DW	0
	DW	0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;02. TOTAL_PAGES
;	total # of EMM pages in system
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_total_pages:
	DW	0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;03. LIM 3.2 PAGE FRAME
; A suitable lim 3.2 page frame found
; by scanning for free area
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PF_Base:
_PF_Base:
	dw	0FFFFh			; Undefined initially


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;04. PAGE FRAME BASE
;	this is the map of linear addr.
;	of the n 16kb physical pages used to
;	access the EMM pages.  The contents
;	far pointers into the system page
;	table.	If a lim 3.2 page frame is
;	available it gets the entries at the
;	beginning
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_page_frame_base:
	DW	MAX_PHYS_PAGES dup (0, PAGET_GSEL)	    ; PTE offsets of physical pages

;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;05. MAPPABLE PAGE ARRAY
;	this is the segment, physical page
;	correspondence array
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
_mappable_pages:
	%rep MAX_PHYS_PAGES
		Mappable_Page	<0, 0>
	%endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;06. MAPPABLE PAGE INDEX ARRAY
;	the pages in system memory are numbered
;	4000h onwards whereas the physical page
;	numbers are arbitrarily numbered. this
;	array indexes into the mappable page
;	array.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EMM_MPindex:; table of indexes into above
_EMM_MPindex:
	times 48 db -1; 4000h to 10000h

_mappable_page_count	dw	MAX_PHYS_PAGES	; number of entries in above
_physical_page_count	dw	0		; number of physical pages


_page_frame_pages	dw	4		; pages in the page frame
%ifdef CGA
_VM1_EMM_Pages		dw	30		; 4000h to B800h for now
%else
_VM1_EMM_Pages		dw	24		; 4000h to A000h for now
%endif

; don't need it (used only in _set_40windows)
;
;_VM1_EMM_Offset	dw	0		; Offset of these in context
;
; combined into _cntxt_pages and _cntxt_bytes
;
;_VM1_cntxt_pages	db	0		; Pages in context
;_VM1_cntxt_bytes	db	0		; Bytes in context
;_VMn_cntxt_pages	db	0
;_VMn_cntxt_bytes	db	0

_cntxt_pages		db	0		; Pages in context
_cntxt_bytes		db	0		; Bytes in context

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;07. HARDWARE INFORMATION
; Hardware information returned by Get
; Information call
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_emm40_info:
	dw	0400h			; raw page size in paragraphs (16k)
	dw	FRS_COUNT-1		; number of fast register sets
	dw	FRS_window_size+2	; max. number of bytes to save a context
					; ( FRS_window size + 2 )
	dw	0			; settable DMA channels
	dw	0			; DMA_channel_operation

;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;08. FRS MAPPING STATE ARRAY
; Used to emulate FRS. FRS 0..FRS_COUNT-1. FRS 0
; is the normal mapping set.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FRS_array:; Array of Fast Register Set structures
	%rep FRS_COUNT
FRS_struc	<>
	%endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;09. Variables to support FRS Implementation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FRS_free	db	0		; How many of the above are free
CurRegSetn	db	0		; Number of Current Register Set
_CurRegSet:
CurRegSet	dw	0		; Pointer to Current Register Set Area
					; in FRS_array

; initialized to 0:0 for initial buffer inquiry
;
EMM_savES	dw	0		; store for buffer address provided
EMM_savDI	dw	0		; by user on frs function

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;10. Variable to support OS access functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_OSEnabled	dd	0		; Security feature
_OSKey: dd 0; Key for security functions


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;11. Mysterious variable right now
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
VEMMD_SSbase	dd	0		; Linear base of Stack Segment

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;12. save_map
;	This is an array of structures that save
;	the current mapping state.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_save_map:
	%rep HANDLE_CNT; one save area per handle
SaveMap_struc	<>			; save area
	%endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;13. handle_table
;	This is an array of handle pointers.
;	In addition to the handle number a ptr
;	to the start of the ems pages allocated
;	to the handle in emm_page array is given
;	emm_page index of NULL_PAGE means free
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_handle_table:
	%rep HANDLE_CNT; one table per handle
HandleTable_struc	<>		; initialized handle table
	%endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;14. handle name table
;	Under LIM 4.0 each allocated handle can
;	be given a 8 byte name. this array keeps
;	track of the handle names
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_Handle_Name_Table:
	DQ	HANDLE_CNT dup (0)	; 8 0 bytes for every handle name

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;15. book-keeping variables for handle table
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_handle_table_size:
	DW	HANDLE_CNT

_handle_count:
	DW	0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;16. EMMPT_START
;	emmpt_start is the index of the next
;	free entry in emm_page
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_emmpt_start:
	DW	0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;17. FREE pointers
;	free_top is the index for the top free
;	page in the emm_free stack.
;	free_count is the number of free
;	pages in the emm_free stack
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_free_top:
	DW	EMM_PAGE_CNT		; none free initially

_free_count:
	DW	0		; none free initially

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;18. POINTERS to the variable sized data structures
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_emm_page   dw	    EMM_dynamic_data_area
_emm_free   dw	    0
_pft386     dw	    0
_emm_brk    dw	    EMM_data_end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Espensive data structures are going to be
; to be assigned storage dynamically so that we
; don't end up wasting space. These data areas
; are referred to by pointers above.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EMM_dynamic_data_area:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%ifndef NOHIMEM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;19. EMM Page table
;	this array contains lists of indexes into the pseudo 
;	Page Table.  Each list is pointed to
;	by a handle table entry and is sequential/contiguous.
;	This is so that maphandlepage doesn't have to scan
;	a list for the specified entry.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_def_emm_page:
	DW	EMM_PAGE_CNT DUP(0)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;20. EMM free table
;	this array is a stack of available page table entries. 
;	each entry is an index into pft386[].
;	it is initialized to FFFF entries. this is 
;	a null page entry/
;	it is initialized to FFFF entries. this is 
;	a null page entry.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_def_emm_free:
	DW	EMM_PAGE_CNT DUP(NULL_PAGE)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;21. PAGE FRAME TABLE
;	This array contains addresses of physical
;	page frames for 386 pages. A page is
;	referred to by an index into this array.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_def_pft386:
	DD	EMM_PAGE_CNT DUP(NULL_HANDLE AND 0fffh)

%endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EMM_data_end:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; END SECTION ._DATA

%ifndef NOHIMEM

%else

SECTION .VDATA
	    global vdata_begin
vdata_begin:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;19. EMM Page table
;	this array contains lists of indexes into the pseudo 
;	Page Table.  Each list is pointed to
;	by a handle table entry and is sequential/contiguous.
;	This is so that maphandlepage doesn't have to scan
;	a list for the specified entry.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_def_emm_pagev:
	DW	EMM_PAGE_CNT DUP(0)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;20. EMM free table
;	this array is a stack of available page table entries. 
;	each entry is an index into pft386[].
;	it is initialized to FFFF entries. this is 
;	a null page entry/
;	it is initialized to FFFF entries. this is 
;	a null page entry.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_def_emm_freev:
	DW	EMM_PAGE_CNT DUP(NULL_PAGE)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;21. PAGE FRAME TABLE
;	This array contains addresses of physical
;	page frames for 386 pages. A page is
;	referred to by an index into this array.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_def_pft386v:
	DD	EMM_PAGE_CNT DUP(NULL_HANDLE AND 0fffh)

; END SECTION .VDATA



%endif


	; END


