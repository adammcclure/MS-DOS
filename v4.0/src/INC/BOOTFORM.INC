	%warning BOOTFORM.INC...
;****************************************************************************
;AN000; - Structure of the Extended IBMBOOT record for DOS -. J.K.
;AN001; - D304 Include PHYDRV, CURHD to the header structure	 11/09/87 J.K.
;****************************************************************************

BOOT_SIZE		 EQU	 512
EXT_BOOT_SIGNATURE	 EQU	 41		;Extended boot signature
;
struc EXT_BPB_INFO
EBPB_BYTESPERSECTOR: dw 0
EBPB_SECTORSPERCLUSTER: db 0
EBPB_RESERVEDSECTORS: dw 0
EBPB_NUMBEROFFATS: db 0
EBPB_ROOTENTRIES: dw 0
EBPB_TOTALSECTORS: dw 0
EBPB_MEDIADESCRIPTOR: db 0
EBPB_SECTORSPERFAT: dw 0
EBPB_SECTORSPERTRACK: dw 0
EBPB_HEADS: dw 0
EBPB_HIDDENSECTOR: dd 0
EBPB_BIGTOTALSECTORS: dd 0
endstruc
;
;AN001; EXT_PHYDRV, EXT_CURHD included in the header for OS2.
struc EXT_IBMBOOT_HEADER
EXT_BOOT_JUMP: times 3 db 0
EXT_BOOT_OEM: times 8 db 0
EXT_BOOT_BPB		DB	type EXT_BPB_INFO dup (?)
EXT_PHYDRV		DB	80h
EXT_CURHD		DB	0
EXT_BOOT_SIG		DB	EXT_BOOT_SIGNATURE
EXT_BOOT_SERIAL: dd 0
EXT_BOOT_VOL_LABEL: times 11 db 0
EXT_SYSTEM_ID: times 8 db 0
endstruc
;
BOOT_SIGNATURE	=     word (BOOT_SIZE-2)

;
;J.K. This is the number of sectors (of size 512 bytes) that will cover
;the size of IBMLOAD program.  IBMBOOT program has to at least read this
;many sectors, and these sectors should be the first cluster and consecutive.
;Make sure IBMBOOT program uses the same value as this.
IBMLOADSIZE	equ	3	;Number of sectors IBMBOOT program should read in.


