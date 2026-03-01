;	SCCSID = @(#)sysvar.asm 1.1 85/04/10
%include "version.inc"

struc SysInitVars
SYSI_DPB: resd 1; DPB chain
SYSI_SFT: resd 1; SFT chain
SYSI_CLOCK: resd 1; CLOCK device
SYSI_CON: resd 1; CON device
SYSI_MAXSEC: resw 1; maximum sector size
SYSI_BUF: resd 1; points to Hashinitvar
SYSI_CDS: resd 1; CDS list
SYSI_FCB: resd 1; FCB chain
SYSI_Keep: resw 1; keep count
SYSI_NUMIO: resb 1; Number of block devices
SYSI_NCDS: resb 1; number of CDS's
SYSI_DEV: resd 1; device list
SYSI_ATTR: resw 1; null device attribute word
SYSI_STRAT: resw 1; null device strategy entry point
SYSI_INTER: resw 1; null device interrupt entry point
SYSI_NAME: resb 8; null device name
SYSI_SPLICE	    DB	    0		; TRUE -> splicees being done
SYSI_IBMDOS_SIZE: resw 1; DOS size in paragraphs
SYSI_IFS_DOSCALL@: resd 1; IFS DOS service rountine entry
SYSI_IFS: resd 1; IFS header chain
SYSI_BUFFERS	    DW	    ?,0 	; BUFFERS= values (m,n)
SYSI_BOOT_DRIVE: resb 1; boot drive A=1 B=2,..
SYSI_DWMOVE	    DB	    0		; 1 if 386 machine
SYSI_EXT_MEM	    DW	    0		; Extended memory size in KB.
endstruc

;This is added for more information exchage between DOS, BIOS.
;DOS will give the pointer to SysInitTable in ES:DI. - J.K. 5/29/86
struc SysInitVars_Ext
SYSI_InitVars		DD	0	; Points to the above structure.
SYSI_Country_Tab	DD	0	; DOS_Country_cdpg_info
endstruc

;The SYSI_BUF of SysInitVars points to the follwong structure
EMS_MAP_BUFF_SIZE      EQU	12	; EMS map buffer size

struc Buffinfo
Hash_ptr: resd 1; pointer to Hash table
Hash_count: resw 1; number of Hash entries
Cache_ptr: resd 1; pointer to secondary cache
Cache_count	 DW	 0		     ; number of secondary cache entries

%if BUFFERFLAG

EMS_SAFE_FLAG	DB	1
EMS_LAST_PAGE	DW	0, 0
EMS_FIRST_PAGE	DW	0, 0
EMS_NPA640	DW	0

%endif

EMS_mode	 DB	 -1		     ; no EMS = -1
EMS_handle: resw 1; EMS handle for buffers
EMS_PageFrame_Number	DW   -1 	     ; EMS page frame number
EMS_Seg_Cnt	 DW	 1		     ; EMS segment count
EMS_Page_Frame	 DW	 -1		     ; EMS page frame segment address
EMS_reserved	 DW	 0		     ; EMS segment count

%if BUFFERFLAG
EMS_Map_Buff	 DB	 0  ; map buffer
%else
EMS_Map_Buff: resb 12
%endif

endstruc







