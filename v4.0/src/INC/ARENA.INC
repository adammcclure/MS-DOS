;	SCCSID = @(#)arena.asm	1.1 85/04/09
BREAK <Memory arena structure>

;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;
;	     C	A  V  E  A  T	  P  R	O  G  R  A  M  M  E  R		   ;
;									   ;
;
; arena item
;
struc arena
arena_signature: db 0; 4D for valid item, 5A for last item
arena_owner: dw 0; owner of arena item
arena_size: dw 0; size in paragraphs of item
arena_reserved: times 3 db 0; reserved
arena_name: times 8 db 0; owner file name
endstruc

;
; CAUTION: The routines in ALLOC.ASM rely on the fact that arena_signature
; and arena_owner_system are all equal to zero and are contained in DI.  Change
; them and change ALLOC.ASM.

arena_owner_system  EQU 0		; free block indication

arena_signature_normal	EQU 4Dh 	; valid signature, not end of arena
arena_signature_end	EQU 5Ah 	; valid signature, last block in arena
;									   ;
;	     C	A  V  E  A  T	  P  R	O  G  R  A  M  M  E  R		   ;
;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;
