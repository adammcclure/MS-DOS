	%warning BOOTFORM.INC...
;****************************************************************************
;AN000; - Structure of the Extended IBMBOOT record for DOS -. J.K.
;AN001; - D304 Include PHYDRV, CURHD to the header structure	 11/09/87 J.K.
;****************************************************************************

BOOT_SIZE		 EQU	 512
EXT_BOOT_SIGNATURE	 EQU	 41		;Extended boot signature
;
struc EXT_BPB_INFO
EBPB_BYTESPERSECTOR: resw 1
EBPB_SECTORSPERCLUSTER: resb 1
EBPB_RESERVEDSECTORS: resw 1
EBPB_NUMBEROFFATS: resb 1
EBPB_ROOTENTRIES: resw 1
EBPB_TOTALSECTORS: resw 1
EBPB_MEDIADESCRIPTOR: resb 1
EBPB_SECTORSPERFAT: resw 1
EBPB_SECTORSPERTRACK: resw 1
EBPB_HEADS: resw 1
EBPB_HIDDENSECTOR: resd 1
EBPB_BIGTOTALSECTORS: resd 1
endstruc
;
;AN001; EXT_PHYDRV, EXT_CURHD included in the header for OS2.
struc EXT_IBMBOOT_HEADER
EXT_BOOT_JUMP: resb 3
EXT_BOOT_OEM: resb 8
EXT_BOOT_BPB		DB	type EXT_BPB_INFO dup (?)
EXT_PHYDRV		DB	80h
EXT_CURHD		DB	0
EXT_BOOT_SIG		DB	EXT_BOOT_SIGNATURE
EXT_BOOT_SERIAL: resd 1
EXT_BOOT_VOL_LABEL: resb 11
EXT_SYSTEM_ID: resb 8
endstruc
;
BOOT_SIGNATURE equ word (BOOT_SIZE-2)

;
;J.K. This is the number of sectors (of size 512 bytes) that will cover
;the size of IBMLOAD program.  IBMBOOT program has to at least read this
;many sectors, and these sectors should be the first cluster and consecutive.
;Make sure IBMBOOT program uses the same value as this.
IBMLOADSIZE	equ	3	;Number of sectors IBMBOOT program should read in.


