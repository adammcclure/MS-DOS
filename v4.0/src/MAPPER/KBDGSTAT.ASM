;0
; page 80,132
;
; title CP/DOS KbdGetStatus
;
	; .sall
	; .xlist
	%include "kbd.inc"
	; .list

SECTION .kbddata

		global KbdBitMask
KbdBitMask	dw	CookedModeOn or EchoOn

		global KbdTurnAroundCharacter
KbdTurnAroundCharacter	dw	0dh

		global KbdInterimCharFlags
KbdInterimCharFlags	dw	0

; END SECTION .kbddata

SECTION .kbdxxx
	; assume	cs:kbdxxx,ds:nothing,es:nothing,ss:nothing
;
; ************************************************************************* *
; *
; *	 MODULE:  kbdGetStatus
; *
; *	 CALLING SEQUENCE:
; *
; *
; *************************************************************************

	global kbdgetstatus

struc str
old_bp: dw 0
return: dd 0
handle: dw 0; kbd handle
data: dd 0; data area pointer
endstruc

kbdgetstatus:

	Enter	KbdGetStatus		; push registers

	les	di,[bp].data		; setup area where status is
					; returned
	mov	ax,seg kbddata
	mov	ds,ax
	; assume	ds:kbddata

	mov	ax,KbdBitMask			 ; save kbd bit mask in
	mov	es:[di].Bit_Mask,ax		 ; return data area

	mov	ax,KbdTurnAroundCharacter	 ; save turn around character
	mov	es:[di].Turn_Around_Char,ax

	mov	ax,KbdInterimCharFlags		 ; save interim character flag
	mov	es:[di].Interim_Char_Flags,ax

	mov	ah,2
	int	16h				 ; get kbd shift status

	xor	ah,ah
	mov	es:[di].Status_Shift_State,ax	 ; save it in return data
						 ; area
	Mexit					 ; restore registers

	ret	str_size - 6			 ; return

; ENDP kbdgetstatus
; END SECTION .kbdxxx
	; end
