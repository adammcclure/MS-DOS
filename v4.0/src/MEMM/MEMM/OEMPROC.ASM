

;******************************************************************************
;
;   (C) Copyright MICROSOFT Corp. 1986
;
;   Title:    MEMM - MICROSOFT Expanded Memory Manager 386
;
;   Module:   OEMPROC.ASM
;
;   Version:  0.05
;
;   Date:     June 13, 1986
;
;   Author:
;
;******************************************************************************
;
;   Change log:
;
;     DATE    REVISION			DESCRIPTION
;   --------  --------	-------------------------------------------------------
;   06/13/86  Original	Separated out OEMPROC from OEMDEP.INC
;
;******************************************************************************
;
CPU 386
; .lfcond; list false conditionals

global VerifyMachine
global MaskIntAll
global RestIntMask
global OEM_Trap_Init
global Map_Lin_OEM
global UMap_Lin_OEM
global MB_Map_Src
global MB_Map_Dest
global MB_Start
global Rest_Par_Vect
global Set_Par_Vect

global DisableNMI
global ROM_BIOS_Machine_ID
global OEM_Init_Diag_Page


%ifndef NOHIMEM

global hi_size
global hi_alloc
global hisys_alloc

global HwMemLock
global HwMemUnlock

global Hi_Mem_Size
global hbuf_chk
global HiAlloc
global HiSysAlloc
global HImod

global InitLock
global LockROM
global UnLockROM


%endif

	%include "page.inc"
	%include "vdmseg.inc"
	%include "VDMsel.inc"
	%include "desc.inc"
	%include "Instr386.inc"
	%include "romxbios.equ"


;******************************************************************************
;			E X T E R N A L    R E F E R E N C E S
;******************************************************************************
;
SECTION ._DATA
	extern gdt_mb
	extern MB_Stat
; END SECTION ._DATA


SECTION .LAST
	extern set_src_selector
	extern set_dest_selector
	extern SetPageEntry
; END SECTION .LAST

SECTION ._TEXT
	extern MB_Exit
; END SECTION ._TEXT

	; page
;******************************************************************************
;			L O C A L   C O N S T A N T S
;******************************************************************************
;

MASTER_IMR	equ	21h		; mask port for master 8259

;
;  PPI port bit definitions
;
PPI			equ	61h
PPO			equ	61h
PPO_MASK_IOCHECK	equ	04h	; disable system board parity check
PPO_MASK_PCHECK 	equ	08h	; disable IO parity check

RTC_CMD 		equ	70h	; Real Time Clock cmd port
DISABLE_NMI		equ	80h	; mask bit for NMI
ENABLE_NMI		equ	00h	; this command to RTC_CMD enables NMI

;****** REMOVE BEFORE DISTRIBUTION begin
;	Compaq specific 386 related addresses
;
X_HI_MEM_SEG	equ	0f000h		;segment for the following words
X_MT_386	equ	0fffeh		; Machine type
X_RT_386	equ	0ffe8h		; Rom type
X_HI_PTR	equ	0ffe0h		; pointer to four words (offsets below)
X_MEM_BOARD	equ	0		; 32-bit memory board status word
X_HISYS 	equ	0		; low byte = # of free 4k system pages
X_AVAIL_MEM	equ	4		; available hi memory in 16 byte chunks
X_LAST_HI	equ	6		; last used byte in hi memory (grows down)
;
;   Addresses and values used to write the "ROM"
;
OEM_MEM_HI	equ	80c0h		; Upper 16 bits of high mem physical adr
LOCK_ADR_LO	equ	0000h		; 0:15 of 32-bit location
LOCK_ADR_HI	equ	OEM_MEM_HI	; 16-31 of 32-bit location
LOCK_ROM	equ	0fcfch		; value to write to lock rom
UNLOCK_ROM	equ	0fefeh		; value to write to unlock rom



SECTION .DIAGSEG
DiagLoc: dw 0; 32 bit memory board diagnostic byte
; END SECTION .DIAGSEG


;
; data definitions
;
SECTION ._DATA

NMI_Old: times 8 db 0; save area for old NMI handler

NMI_New:; descriptor for new NMI handler
IDT_ENTRY	VDMC_GSEL,<Parity_Handler>,D_386INT0

;
%ifndef NOHIMEM; if high memory in this model
;Next two entries MUST stay together!
hbase_addr_l	dw	0000h	; 24 bit address of beginning of hi memory
hbase_addr_h	db	  00h	; pool of EMM pages.
;
hi_size 	dw	0	; size of hi memory in kbytes
hi_alloc	dw	0	; actual hi memory allocated (due to potential waste)
hisys_alloc	dw	0	; amount of hi system memory allocated in 4k bytes
;
DiagAddr	db	0	; set this when writting to diag byte location
DiagByte	db	LOW LOCK_ROM	; most recent diag byte written by user
buffer		dw	0	; buffer for 1 word move blocks
%endif


int_mask: db 0; save for restoring masked interrupts

;
ROM_BIOS_Machine_ID db	0fch	; hard coded right now to AT model byte.
				; should be changed to be initialised at
				; init time ...isp


; END SECTION ._DATA
;****** REMOVE BEFORE DISTRIBUTION end


SECTION ._TEXT
	; ASSUME	CS:_TEXT, DS:DGROUP

;******************************************************************************
;
;	MaskIntAll  Save current interrupt mask state and mask all interrupts
;
;	entry:	    DS pts to DGROUP
;
;	exit:	    All interrupts disabled
;
;	used:	    AX
;
;	stack:
;
;******************************************************************************
MaskIntAll:
	in	al,MASTER_IMR
	mov	[int_mask], al
	mov	al,0ffh 			;;; all OFF
	out	MASTER_IMR,al
	ret
; ENDP MaskIntAll

;******************************************************************************
;
;	RestIntMask Restore interrupt mask saved in MaskIntAll
;
;	entry:	    DS pts to DGROUP
;
;	exit:	    Interrupts restored to state previous to MaskIntAll
;
;	used:	    AX
;
;	stack:
;
;******************************************************************************
RestIntMask:
	mov	al,[int_mask]			; restore interrupt mask
	out	MASTER_IMR,al
	ret
; ENDP RestIntMask

;******************************************************************************
;   OEM_Trap_Init - turn on I/O bit map trapping for I/O port watching
;
;   ENTRY: DS -> DGROUP   - real,virtual, or protected mode
;	   ES -> TSS segment
;	   Trap_Tab already has address of OEM_Handler for ??? ports
;
;   Description:    This routine is used to initialize any data structures,
;	   including the IOBitMap(via PortTrap call) used for trapping I/O ports
;	   when going into virtual mode.  The routine(s) used to handle the
;	   trap(s) should already be installed in the IOTrap_tab table.
;	   See RRTrap.asm for an example.
;
;   EXIT:  IO_BitMap Updated to trap ports used for ???
;
;   USED:  AX,Flags
;   STACK:
;------------------------------------------------------------------------------
	; assume	cs:_TEXT, ds:DGROUP, es:TSS
OEM_Trap_Init:
;
;   Initialize data structures
;
;
;   Set IOBM traps to look for client's disabling of the A20 line
;
;	push	bx
;	mov	bh, 80h 		    ; set every 1k
;	mov	ax, ??? 		    ; AX = port num to trap
;	call	PortTrap		    ; set traps on ??? port
;
;	mov	ax,0FFFFh
;	mov	[???],ax		    ; Initialize trap data structure
;	pop	bx

	ret
;
; ENDP OEM_Trap_Init
;

%ifndef NOHIMEM; only for high memory

;******************************************************************************
;
;   HwMemUnlock - unlocks high system RAM - makes tables writeable
;
;	ENTRY:	None
;
;	EXIT:	If NOHIMEM, does nothing, else:
;		FS points to DIAG segment
;		high system RAM writeable
;
	; assume	cs:_TEXT, ds:NOTHING, es:NOTHING
HwMemUnlock:
	push	OEM0_GSEL
	POP_FS			; set FS to diag segment
	; ASSUME	DS:DIAGSEG
	FSOVER
	mov	word [DiagLoc],UNLOCK_ROM
	ret
; ENDP HwMemUnlock



;******************************************************************************
;
;   HwMemLock - update client's hi system RAM write locks state
;
;	ENTRY:	CS = _TEXT(Protected mode)
;		DGROUP:[DiagByte] = last byte written to diag byte by user.
;
;	EXIT:	high system RAM write protect ON or OFF depenending on
;		write protect bit in CS:[DiagByte].
;		Bit 1 = 0 => write protect ON
;		Bit 1 = 1 => write protect OFF
;
	; assume	cs:_TEXT, ds:NOTHING, es:NOTHING
HwMemLock:

	push	VDMD_GSEL
	POP_FS				; FS = DGROUP
	; assume	ds:DGROUP
	FSOVER
	test	[DiagByte],02h		;Q: client's ROM write protected?

	push	OEM0_GSEL
	POP_FS				; set FS to diag segment
	; ASSUME	DS:DIAGSEG

	jz	HTL_wp			;  Y: then write protect ON
	FSOVER				;  N: then write protect OFF
	mov	word [DiagLoc],UNLOCK_ROM
	jmp	short HTL_exit
HTL_wp:
	FSOVER
	mov	word [DiagLoc],LOCK_ROM
HTL_exit:
	ret
; ENDP HwMemLock

%endif;end of "high" memory routines(ifndef NOHIMEM)

;******************************************************************************
;
;	Map_Lin_OEM	Map OEM high memory from physical to linear address
;
;	description: This maps an attempt to access the "high" memory to the
;		area starting at 16Meg, which the page tables map to the
;		proper physical address.
;
;	entry:	EAX = physical address to map to linear address
;
;	exit:	If address has been mapped in AX, CF = 1, else CF = 0.
;
;	used:	AX
;
;	stack:
;
;******************************************************************************
;
	; assume	cs:_TEXT, ds:NOTHING, es:NOTHING
Map_Lin_OEM:
	OP32
	cmp	ax,0000h
	dw	OEM_MEM_HI	;Q: Addr in diags byte region ?
	clc
	jne	Mp_Lin_Exit	;  N: return, CF = 0(no mapping done)
	OP32			;  Y: set EAX to proper seg address for diags
	sub	ax,0000h
	dw	(OEM_MEM_HI - 0100h); move to 0100h segment
%ifndef NOHIMEM
;    set write to diag byte flag
	push	ds		; save DS
	push	VDMD_GSEL
	pop	ds		; DS = DGROUP
	; ASSUME	DS:DGROUP
	mov	[DiagAddr],1	; set flag for diag addr
	pop	ds		; reset DS
%endif
	stc
Mp_Lin_Exit:
	ret
; ENDP Map_Lin_OEM



;******************************************************************************
;
;	UMap_Lin_OEM	 Map OEM high memory from linear to physical address
;
;	description: This maps an attempt to access the "high" memory in the
;		linear address area starting at 16Meg, to the proper physical
;		address.
;
;	entry:	EAX = linear address to map to physical address
;
;	exit:	EAX = physical address
;
;	used:	EAX
;
;	stack:
;
;******************************************************************************
;
	; assume	cs:_TEXT, ds:NOTHING, es:NOTHING
UMap_Lin_OEM:
	OP32			;  Y: set EAX to physical address for diags
	add	ax,0000h
	dw	(OEM_MEM_HI - 0100h) ; move to OEM_MEM_HI segment
	ret
; ENDP UMap_Lin_OEM

;******************************************************************************
;
;	MB_Map_Src  Do special move block processing before source mapping
;
;	description:
;		This routine is called just before MoveBlock does mapping of
;		the source.  In conjunction with the Map_Lin_OEM routine, and
;		the MB_Start routine, it can perform special processing on the
;		data moved.
;
;	entry:	ES:DI pts to source work descr in GDT
;
;	exit:	any flag setting or perturbation of descriptor is done
;
;	used:	none
;
;	stack:
;
;******************************************************************************
	; assume	cs:_TEXT, ds:NOTHING, es:NOTHING
MB_Map_Src:
	ret
; ENDP MB_Map_Src

;******************************************************************************
;
;	MB_Map_Dest Do special move block processing before destination mapping
;
;	description:
;		This routine is called just before MoveBlock does mapping of
;		the destination.  In conjunction with the Map_Lin_OEM routine,
;		and the MB_Start routine, it can perform special processing on
;		the data moved.
;
;	entry:	ES:DI pts to destination work descr in GDT
;
;	exit:	any flag setting or perturbation of descriptor is done
;
;	used:	AX
;
;	stack:
;
;******************************************************************************
	; assume	cs:_TEXT, ds:NOTHING, es:NOTHING
MB_Map_Dest:
%ifndef NOHIMEM
	push	ds
	push	VDMD_GSEL
	pop	ds		; DS = DGROUP alias selector
	; ASSUME	DS:DGROUP
	mov	[DiagAddr],0	; reset diag addr flag before write
	pop	ds		; reset DS
%endif
	ret
; ENDP MB_Map_Dest

;******************************************************************************
;
;	MB_Start    Do any special move block processing
;
;	description:
;		This routine is called just before MoveBlock does the move.
;		It allows for any special processing of data moved
;
;	entry:	DS is source selector
;		ES is destination selector
;		SI is source offset
;		DI is destination offset
;
;	exit:	nothing
;
;	used:	AX
;
;	stack:
;
;******************************************************************************
	; assume	cs:_TEXT, ds:NOTHING, es:NOTHING
MB_Start:
%ifndef NOHIMEM
;
;  check for write to diag byte location
;
	push	es
	push	VDMD_GSEL
	pop	es			; ES = DGROUP alias
	; ASSUME	ES:DGROUP
	cmp	[es:DiagAddr],0 	;Q: does target -> diag byte ?
	je	MB_nodiag		;  N: then don't worry
	mov	al,[si] 		;  Y: get current diag byte
	mov	[es:DiagByte],al	;     and save it where we can access it
MB_nodiag:
	pop	es			; restore es
%endif
	ret
; ENDP MB_Start

;*************************************************************************
;	Set_Par_Vect  - Set parity handling routine to routine below
;
;	Description:
;		This routine sets up a parity handling routine in case of
;	    a parity error during a MOVEBLOCK.
;
;	ENTRY: protected mode
;
;	EXIT:	vector restored
;
;	USES:	AX, CX, ES, DS, DI, SI
;
;	note: entry is from protected mode -> DS,ES are same as during
;		move block.
;*************************************************************************
	; assume	cs:_TEXT, ds:NOTHING, es:NOTHING
Set_Par_Vect:
	mov	ax,VDMD_GSEL
	mov	es,ax		; ES pts to DGROUP
	mov	ax,IDTD_GSEL	;
	mov	ds,ax		; DS points to IDT

	mov	si,0010h	; DS:[SI] points to NMI descr address in IDT
	mov	di,NMI_Old	; ES:[DI] pts to store area
	mov	cx,2
	db	66h
	rep	movsw		; store 2 dwords - save current NMI descriptor
	push	ds
	push	es
	pop	ds		; DS = DGROUP
	pop	es		; ES = IDT
	mov	di,0010h	; ES:[DI] points to NMI descr address in IDT
	mov	si,NMI_New ; DS:[SI] pts to new NMI descr
	mov	cx,2
	db	66h
	rep	movsw		; set up new NMI descriptor in IDT
	ret
; ENDP Set_Par_Vect

;*************************************************************************
;	Rest_Par_Vect  - restore parity handling routine to original
;
;	Description:
;		This routine restores the parity handling vector to the
;	    contents before Set_Par_Vect was called.  It is called after
;	    a MOVEBLOCK has been completed.
;
;	ENTRY:	DS = DGROUP
;
;	EXIT:	vector restored
;
;	USES:	AX, CX, ES, DI, SI
;
;	note: entry is from protected mode -> DS,ES are same as during
;		move block.
;*************************************************************************
	; assume	cs:_TEXT, ds:DGROUP, es:NOTHING
Rest_Par_Vect:
%ifndef NOHIMEM
	call	HwMemUnlock		    ; in case IDT is in high mem
%endif
	mov	ax,IDTD_GSEL		    ; selector for IDT
	mov	es,ax			    ; ES points to IDT

	mov	di,0010h		    ; ES:[DI] points to NMI descr address in IDT
	mov	si,NMI_Old    ; DS:[SI] pts to store area
	mov	cx,2
	db	66h
	rep	movsw			    ; restore previous NMI descriptor
%ifndef NOHIMEM
	call	HwMemLock
%endif
	ret
; ENDP Rest_Par_Vect


;*************************************************************************
;	Parity_Handler - routine to handle parity errors which occur during
;			move_block.
;	Description:
;		This routine writes to the parity error location to
;	    clear the parity error on the memory board, then it clears
;	    the parity error on the system board.
;
;	note: entry is from protected mode -> DS,ES are same as during
;		move block.
;*************************************************************************
	; assume	cs:_TEXT, ds:NOTHING, es:NOTHING
Parity_Handler:
;
	dec	si
	dec	si		;;; DS:SI pts to address causing parity error
	mov	ax,[si] 	;;; retrieve value and write it back
	mov	[si],ax 	;;; to reset parity on memory board.
	in	al,PPI		;;; Get parity error flags, reset then set
	jmp	$+2		;;; parity checking to reset parity on
	jmp	$+2		;;; system board
	or	al,PPO_MASK_IOCHECK	;;; disable IOCHECK
	or	al,PPO_MASK_PCHECK	;;; disable PCHECK
	out	PPO,al		;;; disable them
	jmp	$+2
	jmp	$+2
	jmp	$+2

%ifndef NOHIMEM
	call	HwMemlock	;;; LOCK high sys mem
%endif

	and	al, NOT PPO_MASK_IOCHECK	;;; enable IOCHECK
	and	al, NOT PPO_MASK_PCHECK 	;;; enable PCHECK
	out	PPO,al		;;; enable them
				;;; system board parity now reset

;
	mov	ax,VDMD_GSEL	;;;
	mov	ds,ax		;;; set DS to data seg
	; assume	ds:DGROUP
	mov	[MB_Stat],1	;;; set parity error
	add	sp,12		;;; remove NMI stuff from stack
	jmp	MB_Exit 	;;; and exit move block

; ENDP Parity_Handler

;*************************************************************************
;	DisableNMI -   This is called by the NMI handler to disable the
;			    NMI interrupt(stop gracefully) as part of the
;			    graceful handling of the NMI interrupt.
;
;	Description:
;
;	note: entry is from 386 protected mode
;*************************************************************************
	; assume	cs:_TEXT, ds:NOTHING, es:NOTHING
DisableNMI:
	push	ax
	mov	al,DISABLE_NMI
	out	RTC_CMD,al
	pop	ax
	ret
; ENDP DisableNMI

; END SECTION ._TEXT

SECTION .LAST

;******************************************************************************
;
;	VerifyMachine	Check ID, etc. to make sure machine is 386 valid for
;			running the LIM/386 product.
;
;	description:
;		This routine should check ROM signature bytes and any other
;	hardware features that guarantee the appropriateness of running this
;	software on the machine.
;
;	entry:	DS pts to DGROUP
;		CF = 1 if from INIT procedure, CF = 0 if from AllocMem procedure
;		REAL or VIRTUAL MODE
;
;	exit:	If not correct machine, CF = 1, else CF = 0.
;
;	used:	AX
;
;	stack:
;
;******************************************************************************
;
	; assume	cs:LAST, ds:NOTHING, es:NOTHING
VerifyMachine:
	pushf
	push	es			; save es
	push	bx			; save bx
	mov	bx,X_HI_MEM_SEG 	; segment of hi memory control words
	mov	es,bx			; into es
	mov	ax,es:X_MT_386		; get machine type
	cmp	al,0FCh 		; q: is this an AT class machine?
	mov	ax,es:X_RT_386		;    get ROM type
	pop	bx			;    restore bx
	pop	es			;    restore es
	jne	inc_prcf		; n: invalid
	popf
	jc	Cor_Prc 		; that's all the checking for INIT
	cmp	ax,'30' 		; q: is this a 386? (really '03')
	jne	inc_prc
Cor_Prc:
	clc
	ret
inc_prcf:
	popf
inc_prc:
	stc
	ret
; ENDP VerifyMachine; End of procedure


%ifndef NOHIMEM; if high memory in this model
;******************************************************************************
;
;	Hi_Mem_Size -	returns pointer and size of high mem allocated to EMM
;
;	entry:
;
;	exit:	if ZF = 1, no high memory allocated to EMM, else
;		EAX = 24 bit pointer to EMM allocated high memory
;		CX  = kbytes of high memory allocated
;
;	used:	EAX, CX(returned values)
;
;	stack:
;
;******************************************************************************
;
	; assume	cs:LAST, ds:DGROUP, es:NOTHING
Hi_Mem_Size:
	mov	cx,[hi_size]		; CX = kbytes of high mem
	shr	cx,4			;Q: any hi memory pages ? CX = pg cnt
	jz	Hi_Mem_SXit		;  N: Exit with ZF = 1
	db	66h			;  Y: get high memory pointers
	mov	ax,[hbase_addr_l]	;   get pointer to high memory pool
	db	66h
	and	ax,0FFFFh		; AND EAX,00FFFFFFh
	dw	00FFh			;   clear highest nibble
Hi_Mem_SXit:
	ret
; ENDP Hi_Mem_Size

	; page
;******************************************************************************
;
;	hbuf_chk Hi memory pool check.
;	 Check available hi memory pool space
;
;	entry:
;
;	exit:	If hi memory pool space is available then
;			AX = size of memory available and CF = 0
;		else AX = 0 and CF = 1
;
;	used:	AX(returned value)
;
;	stack:
;
;******************************************************************************
;
	; assume	cs:LAST, ds:DGROUP, es:NOTHING
hbuf_chk:
	push	es			; save es
	push	bx
	mov	bx,X_HI_MEM_SEG 	; segment of hi memory control words
	mov	es,bx
	mov	bx,es:X_HI_PTR		; pointer to hi memory control words
	mov	ax,[es:bx+X_MEM_BOARD]	; 32-bit memory board status
	inc	ax			; q: memory board status word == -1?
	stc
	jz	hbuf_xit		; y: not installed
	mov	ax,[es:bx+X_AVAIL_MEM]	; get available memory in 16 byte pieces
	mov	bx,[es:bx+X_LAST_HI]	; get last used address
	and	bx,0ffh 		; align to 4k byte boundary (2**8)*16
	sub	ax,bx			; ax = available 16 byte pieces
	shr	ax,10			; ax = available 16k byte pieces
	shl	ax,4			; ax = available 1k byte pieces
	clc
hbuf_xit:
	pop	bx			; ax = availble memory unless CF = 1
	pop	es
	ret
; ENDP hbuf_chk
;
	; page
;******************************************************************************
;
;	HiAlloc - allocate hi memory - update hi memory control words
;
;	entry:	REAL or VIRTUAL MODE
;		DS pts to DGROUP
;		DGROUP:[hi_size] size in kbytes to allocate
;
;	exit:	update available hi memory and last used address.
;		Set [hbase_addr_l] and [hbase_addr_h] to starting address.
;		If error occurs in writing control words, CF = 1, else CF = 0.
;
;	used:	none
;
;	stack:
;
;******************************************************************************
	; assume cs:LAST, ds:DGROUP, es:NOTHING
HiAlloc:
;
	push	ax
	push	bx
	push	cx
	push	dx
	push	si
	push	es
;
	mov	ax,[hi_size]		; get amount of hi memory to allocate
	or	ax,ax			; q: allocate any?
	jz	Hi_xit			; n: quit(CF = 0)

	mov	cl,6
	shl	ax,cl			; back to 16 byte pieces
;
	mov	bx,X_HI_MEM_SEG 	; high memory segment
	mov	es,bx
	mov	bx,es:X_HI_PTR		; pointer to high memory control words
	mov	cx,0ffh 		; determine waste by aligning to 4k
	and	cx,[es:bx+X_LAST_HI]	; cx = extra needed to align
	add	ax,cx			; ax = total to allocate
	mov	[hi_alloc],ax		; save it in case we need to put it back
	xor	bx,bx			; bx = no hi system memory to alloc
	call	HImod			; go allocate it
					; ax = start of this hi memory
	jc	Hi_xit			; error occurred during move block(CF=1)
	mov	cx,16
	mul	cx			; make it 24 bits
	add	dl,0f0h 		; last 1M segment
	mov	[hbase_addr_h],dl	; save starting address of hi mem
	mov	[hbase_addr_l],ax
	clc
;
Hi_xit: 				; CF = 1 if error, else CF = 0
	pop	es
	pop	si
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	ret
; ENDP HiAlloc
;
	; page
;******************************************************************************
;
;	HiSysAlloc - allocate hi system memory - update hi memory control words
;
;	entry:	REAL or VIRTUAL MODE
;		DS pts to DGROUP
;		ax = # of 4k byte pieces to allocate
;
;	exit:	If enough hi system memory available
;		   update available hi system memory.
;		   ax = # of 4k byte pieces used before this allocation.
;		   CY cleared
;		else
;		   ax = amount of hi system memory available
;		   CY set
;		If error occurs in writing control words,
;		   CY set
;		   ax = -1
;
;	used:	see above
;
;	stack:
;
;******************************************************************************
	; assume cs:LAST, ds:DGROUP, es:NOTHING
HiSysAlloc:
	push	bx
	push	es
;
	push	ax			; save amount asked for
	mov	bx,X_HI_MEM_SEG 	; high memory segment
	mov	es,bx
	mov	bx,es:X_HI_PTR		; pointer to high memory control words
	mov	ax,[es:bx+X_HISYS]	; ax = amount of hi system mem available
	and	ax,00ffh		;    after we get rid of high byte
	pop	bx			; bx = amount requested
					; ax = amount currently available
	cmp	ax,bx			; Q: available >= requested?
	jb	Hisys_xit		; N: quit - carry set => not enough mem
	add	[hisys_alloc],bx	; Y: save it in case we must deallocate
	push	ax			; save amount available before
	xor	ax,ax			; ax = no hi user mem to alloc
	call	HImod			; go allocate high sys mem
	pop	bx			; bx = amount available before
	jc	Hisys_err		;  MOD ERROR -> set error flag
	mov	ax,10h			; 16 pages in high sys mem pool
	sub	ax,bx			; ax = amount used before this request
	jmp	Hisys_xit		; no error in move block
;
Hisys_err:
	mov	ax,-1
	stc				; to be sure
Hisys_xit:
	pop	es
	pop	bx
	ret
; ENDP HiSysAlloc
;
	; page
;******************************************************************************
;
;	Himod - allocate/deallocate hi memory - update hi memory control words
;
;	entry:	REAL or VIRTUAL MODE
;		DS pts to DGROUP
;		ax = size in 16 bytes of hi USER mem to alloc (a negative #
;							     will deallocate)
;		bx = size in 4k bytes of hi SYSTEM mem to alloc (ditto above)
;
;	exit:	update available hi memory and last used address.
;		ax = New last used address for high user memory
;		CY = set if block move error occurred
;
;	used:	none
;
;	stack:
;
;******************************************************************************
	; assume cs:LAST, ds:DGROUP, es:NOTHING
HImod:
	push	bx
	push	cx
	push	dx
	push	si
	push	es
;
	call	UnLockROM		;Q: ROM space writeable?
	jz	unlock_ok		; Y: continue
	jmp	Himod_err		; N: exit
unlock_ok:
	push	bx			; save hi system memory allocation
	mov	bx,X_HI_MEM_SEG 	; high memory segment
	mov	es,bx
	mov	bx,es:X_HI_PTR		; pointer to high memory control words
	sub	[es:bx+X_AVAIL_MEM],ax	; update hi memory available
	sub	[es:bx+X_LAST_HI],ax	; and last used address
	pop	ax			; get hi system memory amount
	sub	[es:bx+X_HISYS],ax	; update hi system memory available
	mov	ax,[es:bx+X_LAST_HI]	; start of this hi memory
;
	call	LockROM 		;Q: ROM write protected now ?
	clc				;     clear error flag
	jz	Himod_xit		; Y: exit with no error
;					; N: report error
Himod_err:
	stc				; indicate error
HImod_xit:
	pop	es
	pop	si
	pop	dx
	pop	cx
	pop	bx
;
	ret


; ENDP HImod
	; page
;******************************************************************************
;
;	LockROM - write protects high system RAM
;
;	entry:	REAL or VIRTUAL MODE
;		DS pts to DGROUP
;
;	exit:	Z = no error - high system RAM write protected
;		NZ  = ERROR.
;
;	used:	none
;
;	stack:
;
;******************************************************************************
	; assume cs:LAST, ds:DGROUP, es:NOTHING
LockROM:
	push	ax			; save ax
	push	cx
	push	dx
	push	es
;
	mov	word [buffer],LOCK_ROM	; word to write to unlock
	jmp	UL_write			; go write it...
;
; ENDP LockROM

	; page
;******************************************************************************
;
;	UnLockROM - turns off write protect on high system RAM
;
;	entry:	REAL or VIRTUAL MODE
;		DS pts to DGROUP
;
;	exit:	Z = no error - high system RAM writeable
;		NZ  = ERROR.
;
;	used:	none
;
;	stack:
;
;******************************************************************************
	; assume cs:LAST, ds:DGROUP, es:DGROUP
UnLockROM:
	push	ax			; save ax
	push	cx
	push	dx
	push	es
;
	mov	word [buffer],UNLOCK_ROM	; word to write to unlock
;
UL_write:
	mov	ax,seg DGROUP		; set source addr to buffer
	mov	es,ax			; set ES to DGROUP
	mov	cx,16
	mul	cx			; make 24 bits
	add	ax,buffer
	adc	dl,0
	mov	cx,1			; 1 word to transfer
	call	set_src_selector	; set source segment selector to buffer
	mov	ax,LOCK_ADR_LO		; DX:AX = 32-bit addr of ROM LOCK
	mov	dx,LOCK_ADR_HI
	mov	cx,1			; 1 word long
	call	set_dest_selector	; destination is unlock address

	mov	ax,seg LAST
	mov	es,ax			; es to last segmetn
	mov	si,gdt_mb ; ES:SI -> global descriptor table
	mov	ah,MOVE_BLK		; int 15 block move function code
	int	XBIOS			; unlock rom
	or	ah,ah			; Q: error?
					;   Y: return NZ
					;   N: return Z
	pop	es
	pop	dx
	pop	cx
	pop	ax
	ret
; ENDP UnLockROM; end of procedure

%endif; end of code for not NOHIMEM


;******************************************************************************
;
;	OEM_Init_Diag_Page: Initialise the 5th page table to point to the
;			    diagnostic segment.
;
;	description:
;
;	     place 32 bit memory board diagnostic byte address into page table
;		xxxx0000h - xxxxFFFFh physical
;	     -> 01000000h - 0100FFFFh linear  => 64k => 16 entries in page tables
;				=> 1st 64k in 5th page table
;
;	entry:	DS pts to DGROUP
;		ES:0 Page table seg.
;
;	exit:	nothing
;
;	used:	ax,di,dx,bx,cx,flags
;
;	stack:
;
;******************************************************************************
;
OEM_Init_Diag_Page:
	; assume	cs:LAST, ds:dgroup, es:NOTHING
;
;
	mov	di,4*P_SIZE		; ES:DI -> 1st 64k of 5th page table
	mov	dx,OEM_MEM_HI
	xor	ax,ax			; start with physical addr = xxxx0000h
	mov	bh,0
	mov	bl,P_AVAIL		; make pages available to all
	mov	cx,10h			; set 64k worth of entries
IT_set_entry:
	call	SetPageEntry
					; ES:[DI] pts to next page table entry
	add	ax,1000h		; next physical page
	adc	dx,0h			; address in DX,AX
	loop	IT_set_entry		;Q: done with page table entries ?
					;  N: loop again
					;  Y: all done
	ret
;
; ENDP OEM_Init_Diag_Page

; END SECTION .LAST; End of segment

%ifndef NOHIMEM; if high memory in this model

SECTION .R_CODE
	; assume cs:R_CODE, ds:DGROUP, es:DGROUP

;******************************************************************************
;	InitLock - Init state of Table lock
;
;	NOTE: this is a FAR routine.
;
;    ENTRY:	REAL MODE
;		DS = DGROUP
;
;    EXIT:	REAL MODE
;		DGROUP:[DiagByte] = updated to current LOCK state
;
;    USED:	AX,BX
;
;******************************************************************************
InitLOCK:

	mov	[DiagByte],LOW LOCK_ROM ; default is locked
	push	es
	mov	ax,X_HI_MEM_SEG
	mov	es,ax			; ES -> ROM
	mov	bx,X_MT_386		; ES:BX -> machine type byte
	mov	ax,[ES:bx]		; AX = ROM contents
	xor	[ES:bx],0FFFFh		; flip all bits in ROM
	xor	ax,0FFFFh		; AX = "flipped" value
	cmp	ax,[ES:bx]		;Q: flipped value in ROM ?
	jne	gv_locked		;  N: "ROM" is locked
	mov	[DiagByte],LOW UNLOCK_ROM ;Y: ROM is UNLOCKED
gv_locked:
	xor	[ES:bx],0FFFFh		; restore ROM contents (if changed)
;
	pop	es
	ret

; ENDP InitLOCK

; END SECTION .R_CODE

%endif; end of code for not NOHIMEM

	; end; of module

