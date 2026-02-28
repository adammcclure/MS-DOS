
	; title	Reboot Support for FDISK

%if 1  ; IF1 - pass-specific
	%warning ASSEMBLING: Reboot
	%warning 
%endif

SECTION .ROMDATA
	org	072h
BootType: dw 0
; END SECTION .ROMDATA

SECTION .ROMBIOS
	org	0
POR:
; END SECTION .ROMBIOS

SECTION ._text
	; assume	cs:_TEXT
	; assume	ds:nothing
	; assume	es:nothing
	; assume	ss:nothing

	global _reboot
_reboot:

	mov	ax,ROMDATA
	mov	ds,ax
	; assume	ds:ROMDATA

	mov	BootType,1234h

	cli
	cld
	jmp	POR

; ENDP _reboot

; END SECTION ._text

	; end
