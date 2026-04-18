;       SCCSID = @(#)cpmfcb.asm 1.1 85/04/10
;       SCCSID = @(#)cpmfcb.asm 1.1 85/04/10
;BREAK <File Control Block definition>

;
; Field definition for FCBs
; The FCB has the following structure:
;
;       +---------------------------+
;       |   Drive indicator(byte)   |
;       +---------------------------+
;       |    Filename (8 chars)     |
;       +---------------------------+
;       |    Extension (3 chars)    |
;       +---------------------------+
;       |   Current Extent(word)    |
;       +---------------------------+
;       |    Record size (word)     |
;       +---------------------------+
;       |    File Size (2 words)    |
;       +---------------------------+
;       |       Date of write       |
;       +---------------------------+
;       |       Time of write       |
;       +---------------------------+
;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;
;            C  A  V  E  A  T     P  R  O  G  R  A  M  M  E  R             ;
;                                                                          ;
;       +---------------------------+
;       |   8 bytes reserved        |
;       +---------------------------+
;                                                                          ;
;            C  A  V  E  A  T     P  R  O  G  R  A  M  M  E  R             ;
;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;
;       |    next record number     |
;       +---------------------------+
;       |   random record number    |
;       +---------------------------+
;

struc sys_fcb
fcb_drive: resb 1
fcb_name: resb 8
fcb_ext: resb 3
fcb_EXTENT: resw 1
fcb_RECSIZ: resw 1; Size of record (user settable)
fcb_FILSIZ: resw 1; Size of file in bytes; used with the
                                        ; following word
fcb_DRVBP: resw 1; BP for SEARCH FIRST and SEARCH NEXT
fcb_FDATE: resw 1; Date of last writing
fcb_FTIME: resw 1; Time of last writing
;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;
;            C  A  V  E  A  T     P  R  O  G  R  A  M  M  E  R             ;
;                                                                          ;
fcb_reserved: resb 8; RESERVED
;                                                                          ;
;            C  A  V  E  A  T     P  R  O  G  R  A  M  M  E  R             ;
;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;
fcb_NR: resb 1; Next record
fcb_RR: resb 4; Random record
endstruc

FILDIRENT equ fcb_FILSIZ; Used only by SEARCH FIRST and SEARCH
                                        ; NEXT

fcb_sfn         EQU     byte fcb_reserved

; Note that fcb_net_handle, fcb_nsl_drive, fcb_nsld_drive and fcb_l_drive
; all must point to the same byte.  Otherwise, the FCBRegen will fail.
; NOTE about this byte (fcb_nsl_drive)
;   The high two bits of this byte are used as follows to indicate the FCB type
;       00 means a local file or device with sharing loaded
;       10 means a remote (network) file
;       01 means a local file with no sharing loaded
;       11 means a local device with no sharing loaded

;
; Network FCB
;
fcb_net_drive   EQU     byte fcb_reserved+1
fcb_net_handle  EQU     word fcb_reserved+2
fcb_netID       EQU     dword fcb_reserved+4

;
; No sharing local file FCB
;
fcb_nsl_drive   EQU     byte fcb_reserved+1
fcb_nsl_bits    EQU     byte fcb_reserved+2
fcb_nsl_firclus EQU     word fcb_reserved+3
fcb_nsl_dirsec  EQU     word fcb_reserved+5
fcb_nsl_dirpos  EQU     byte fcb_reserved+7

;
; No sharing local device FCB
;
fcb_nsld_drive  EQU     byte fcb_reserved+1
fcb_nsld_drvptr EQU     dword fcb_reserved+2

;
; Sharing local FCB
;
fcb_l_drive     EQU     byte fcb_reserved+1
fcb_l_firclus   EQU     word fcb_reserved+2
fcb_l_mfs       EQU     word fcb_reserved+4
fcb_l_attr      EQU     byte fcb_reserved+6

;
; Bogusness:  the four cases are:
;
;   local file      00
;   local device    40
;   local sharing   C0
;   network         80
;
; Since sharing and network collide, we cannot use a test instruction for
; deciding whether a network or a share check in involved
;
FCBDEVICE   EQU 040h
FCBNETWORK  EQU 080h
FCBSHARE    EQU 0C0h

; FCBSPECIAL must be able to mask off both net and share
FCBSPECIAL  EQU 080h
FCBMASK     EQU 0C0h
