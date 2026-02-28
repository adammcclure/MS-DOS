extern PrintString
extern PrintHex

%macro display 1
	; LOCAL dbs,disp_exit
	pushf
	push	ds
	push	es

	push	cs
	pop	ds
	push	cs
	pop	es

	push	si
	mov	si,dbs
	call	PrintString
	pop	si
	pop	es
	pop	ds
	popf
	jmp	disp_exit

dbs	db	&string,0

disp_exit:
	%endmacro

%macro content 1
	pushf
	push	ds
	push	es
	push	ax

	mov	ax,reg

	push	cs
	pop	ds
	push	cs
	pop	es

	call	PrintHex

	pop	ax
	pop	es
	pop	ds
	popf
	%endmacro

