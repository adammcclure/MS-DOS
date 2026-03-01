	%warning BPB.INC...
;	SCCSID = @(#)BPB.ASM	1.1 85/04/29
;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;
;	     C	A  V  E  A  T	  P  R	O  G  R  A  M  M  E  R		   ;
;									   ;

; BIOS PARAMETER BLOCK DEFINITION
; THIS STRUCTURE IS USED TO BUILD A FULL DPB

struc BPBLOCK
BPSECSZ: resw 1; SIZE IN BYTES OF PHYSICAL SECTOR
BPCLUS: resb 1; SECTORS/ALLOC UNIT
BPRES: resw 1; NUMBER OF RESERVED SECTORS
BPFTCNT: resb 1; NUMBER OF FATS
BPDRCNT: resw 1; NUMBER OF DIRECTORY ENTRIES
BPSCCNT: resw 1; TOTAL NUMBER OF SECTORS
BPMEDIA: resb 1; MEDIA DESCRIPTOR BYTE
BPFTSEC: resw 1; NUMBER OF SECTORS TAKEN UP BY ONE FAT
endstruc

struc A_BPB
BPB_BYTESPERSECTOR: resw 1
BPB_SECTORSPERCLUSTER: resb 1
BPB_RESERVEDSECTORS: resw 1
BPB_NUMBEROFFATS: resb 1
BPB_ROOTENTRIES: resw 1
BPB_TOTALSECTORS: resw 1
BPB_MEDIADESCRIPTOR: resb 1
BPB_SECTORSPERFAT: resw 1
BPB_SECTORSPERTRACK: resw 1
BPB_HEADS: resw 1
BPB_HIDDENSECTORS: resw 1
			resw 1
BPB_BIGTOTALSECTORS: resw 1
			resw 1
			resb 6
endstruc
;									   ;
;	     C	A  V  E  A  T	  P  R	O  G  R  A  M  M  E  R		   ;
;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;
