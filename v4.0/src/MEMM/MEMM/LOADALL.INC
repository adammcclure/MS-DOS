

;******************************************************************************
;
;   (C) Copyright MICROSOFT Corp. 1986
;		**** INTEL PROPRIETARY ****
;
;   Title:    MEMM - MICROSOFT Expanded Memory Manager 386
;
;   Module:   LOADALL - contains structures for 286 and 386 loadall
;
;   Version:  0.02
;
;   Date:     April 11,1986
;
;   Author:
;
;******************************************************************************
;
;   Change log:
;
;     DATE    REVISION			DESCRIPTION
;   --------  --------	-------------------------------------------------------
;   04/11/86  Original
;   06/28/86  0.02	Name change from MEMM386 to MEMM
;
;******************************************************************************
;
%ifndef INC_LIST
; .xlist
%endif

LODAL286	equ	050Fh		; instruction as a WORD
LODAL386	equ	070Fh		; instruction as a WORD

;******************************************************************************
;
;   Note that entries are statically initialized to 0000, so limits and
;   access rights must be set up at run time.
;
;   Structure of a 286 system table/segment descriptor cache:
;
struc DescCache286
dc2_BASElo	dw	0000		; low word of base (0..15)
dc2_BASEhi	db	00		; high byte of base (16..24)
dc2_AR		db	00		; access rights byte
dc2_LIMIT	dw	0000		; segment limit
endstruc
;
;   Structure of the 286 LOADALL buffer
;
struc LoadAllBuf286

ll2_None1: times 6 db 0; temp
ll2_MSW 	dw	0000		; MSW
ll2_None2: times 14 db 0; temp
ll2_TR		dw	0000		; TR
ll2_FLAGS	dw	0000		; FLAGS
ll2_IP		dw	0000		; IP
ll2_LDT 	dw	0000		; LDT
ll2_DS		dw	0000		; DS
ll2_SS		dw	0000		; SS
ll2_CS		dw	0000		; CS
ll2_ES		dw	0000		; ES
ll2_DI		dw	0000		; DI
ll2_SI		dw	0000		; SI
ll2_BP		dw	0000		; BP
ll2_SP		dw	0000		; SP
ll2_BX		dw	0000		; BX
ll2_DX		dw	0000		; DX
ll2_CX		dw	0000		; CX
ll2_AX		dw	0000		; AX

;
;  System table and segment descriptor caches
;
ll2_EScache	db	DescCachetimes_size 286 db 00
ll2_CScache	db	DescCachetimes_size 286 db 00
ll2_SScache	db	DescCachetimes_size 286 db 00
ll2_DScache	db	DescCachetimes_size 286 db 00
ll2_GDTcache	db	DescCachetimes_size 286 db 00
ll2_LDTcache	db	DescCachetimes_size 286 db 00
ll2_IDTcache	db	DescCachetimes_size 286 db 00
ll2_TSScache	db	DescCachetimes_size 286 db 00

endstruc
;

;
;******************************************************************************
;   Define the 386 LOADALL buffer structure - 'nested' structures must be
;   used because the complete definition is too complex for the linker.
;   Note that entries are statically initialized to 0000, so limits and
;   access rights must be set up at run time.
;
;   Structure of a 386 system table/segment descriptor cache:
;
struc DescCache386
dc3_AR1 	db	00		; base 16..23	(ignored)
dc3_AR2 	db	00		; access rights byte
dc3_AR3 	db	00		; limit 16..19	(ignored), B/D, G
dc3_AR4 	db	00		; base 24..31	(ignored)
dc3_BASElo	dw	0000		; low word of base
dc3_BASEhi	dw	0000		; high word of base
dc3_LIMITlo	dw	0000		; low word of limit
dc3_LIMIThi	dw	0000		; high word of limit
endstruc
;
;   Structure of the 386 LOADALL buffer
;
struc LoadAllBuf386

ll3_CR0 	dw	0000		; low word of CR0
ll3_CR0hi	dw	0000		; high word of CR0
ll3_EFLAGS	dw	0000		; low word of EFLAGS
ll3_EFLAGShi	dw	0000		; high word of EFLAGS
ll3_EIP 	dw	0000		; low word of EIP
ll3_EIPhi	dw	0000		; high word of EIP
ll3_EDI 	dw	0000		; low word of EDI
ll3_EDIhi	dw	0000		; high word of EDI
ll3_ESI 	dw	0000		; low word of ESI
ll3_ESIhi	dw	0000		; high word of ESI
ll3_EBP 	dw	0000		; low word of EBP
ll3_EBPhi	dw	0000		; high word of EBP
ll3_ESP 	dw	0000		; low word of ESP
ll3_ESPhi	dw	0000		; high word of ESP
ll3_EBX 	dw	0000		; low word of EBX
ll3_EBXhi	dw	0000		; high word of EBX
ll3_EDX 	dw	0000		; low word of EDX
ll3_EDXhi	dw	0000		; high word of EDX
ll3_ECX 	dw	0000		; low word of ECX
ll3_ECXhi	dw	0000		; high word of ECX
ll3_EAX 	dw	0000		; low word of EAX
ll3_EAXhi	dw	0000		; high word of EAX
ll3_DR6 	dw	0000		; low word of DR6
ll3_DR6hi	dw	0000		; high word of DR6
ll3_DR7 	dw	0000		; low word of DR7
ll3_DR7hi	dw	0000		; high word of DR7
ll3_TSSR	dw	0000		; TSSR (TSS selector)
		dw	0000		;    (padding)
ll3_LDTR	dw	0000		; LDTR (LDT selector)
		dw	0000		;    (padding)
ll3_GS		dw	0000		; GS
		dw	0000		;    (padding)
ll3_FS		dw	0000		; FS
		dw	0000		;    (padding)
ll3_DS		dw	0000		; DS
		dw	0000		;    (padding)
ll3_SS		dw	0000		; SS
		dw	0000		;    (padding)
ll3_CS		dw	0000		; CS
		dw	0000		;    (padding)
ll3_ES		dw	0000		; ES
		dw	0000		;    (padding)
;
;  System table and segment descriptor caches
;
ll3_TSScache	db	DescCachetimes_size 386 db 00
ll3_IDTcache	db	DescCachetimes_size 386 db 00
ll3_GDTcache	db	DescCachetimes_size 386 db 00
ll3_LDTcache	db	DescCachetimes_size 386 db 00
ll3_GScache	db	DescCachetimes_size 386 db 00
ll3_FScache	db	DescCachetimes_size 386 db 00
ll3_DScache	db	DescCachetimes_size 386 db 00
ll3_SScache	db	DescCachetimes_size 386 db 00
ll3_CScache	db	DescCachetimes_size 386 db 00
ll3_EScache	db	DescCachetimes_size 386 db 00

ll3_temps	db	134h dup (00)	; padding for internal temps

endstruc

; .list; end of LOADALL.INC
