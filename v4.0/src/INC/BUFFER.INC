;	SCCSID = @(#)buffer.asm 1.1 85/04/09
BREAK <Disk I/O Buffer Header>
;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;
;	     C	A  V  E  A  T	  P  R	O  G  R  A  M  M  E  R		   ;
;									   ;

; Field definition for I/O buffer information

struc BUFFINFO
buf_next: dw 0; Pointer to next buffer in list
buf_prev: dw 0; Pointer to prev buffer in list
buf_ID: db 0; Drive of buffer (bit 7 = 0)
					; SFT table index (bit 7 = 1)
					; = FFH if buffer free
buf_flags: db 0; Bit 7 = 1 if Remote file buffer
					;	= 0 if Local device buffer
					; Bit 6 = 1 if buffer dirty
					; Bit 5 = Reserved
					; Bit 4 = Search bit (bit 7 = 1)
					; Bit 3 = 1 if buffer is DATA
					; Bit 2 = 1 if buffer is DIR
					; Bit 1 = 1 if buffer is FAT
					; Bit 0 = Reserved
buf_sector: dd 0; Sector number of buffer (bit 7 = 0)
; The next two items are often refed as a word (bit 7 = 0)
buf_wrtcnt: db 0; For FAT sectors, # times sector written out
buf_wrtcntinc: dw 0; "   "     "   , # sectors between each write
buf_DPB: dd 0; Pointer to drive parameters
buf_fill: dw 0; How full buffer is (bit 7 = 1)
buf_reserved: db 0; make DWORD boundary for 386
endstruc

buf_offset	EQU	dword buf_sector
					;For bit 7 = 1, this is the byte
					;offset of the start of the buffer in
					;the file pointed to by buf_ID.  Thus
					;the buffer starts at location
					;buf_offset in the file and contains
					;buf_fill bytes.

BUFINSIZ	EQU	BUFFINFO_size
					; Size of structure in bytes

buf_Free	EQU	0FFh		; buf_id of free buffer

;Flag byte masks
buf_isnet	EQU	10000000B
buf_dirty	EQU	01000000B
;***
buf_visit	EQU	00100000B
;***
buf_snbuf	EQU	00010000B

buf_isDATA	EQU	00001000B
buf_isDIR	EQU	00000100B
buf_isFAT	EQU	00000010B
buf_type_0	EQU	11110001B	; AND sets type to "none"

buf_NetID	EQU	BUFINSIZ

;
; Buffer Hash Entry Structure

struc BUFFER_HASH_ENTRY; DOS 4.00
EMS_PAGE_NUM	DW	-1		; logical page number for EMS handle
BUFFER_BUCKET: dd 0; pointer to buffers
DIRTY_COUNT	DB	 0		; number of dirty buffers
BUFFER_RESERVED DB	 0		; reserved
endstruc

MaxBuffinBucket EQU	15		; Max number of buffers per bucket
MaxBucketinPage EQU	 2		; Max number of buckets per 16kb page


;									   ;
;	     C	A  V  E  A  T	  P  R	O  G  R  A  M  M  E  R		   ;
;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;
