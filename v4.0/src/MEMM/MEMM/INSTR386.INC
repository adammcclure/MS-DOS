

;******************************************************************************
;
;   (C) Copyright MICROSOFT Corp. 1986
;
;   Title:    MEMM - MICROSOFT Expanded Memory Manager 386
;
;   Module:   INSTR386 - 386 Instruction Macro Declaration file
;
;   Version:  0.03
;
;   Date:     May 11, 1986
;
;   Author:
;
;******************************************************************************
;
;   Change log:
;
;     DATE    REVISION			DESCRIPTION
;   --------  --------	-------------------------------------------------------
;   05/11/86  Original
;   06/01/86		Added operand/address size overide defines
;   06/28/86  0.02	Name change from MEMM386 to MEMM
;   07/01/86  0.03	Added 32 arithmetic defines
;
;******************************************************************************
%ifndef INC_LIST
; .xlist
%endif

;***	OP32_IRET - 32 bit mode iret
%macro OP32_IRET 0
	db	66h
	iret
	%endmacro

;***	OP32 - instruction prefix to invert sense of operand size attribute

%macro OP32 0
	db	66h
	%endmacro


;***	EA32 - instruction prefix to invert sense of effective addr attribute

%macro EA32 0
	db	67h
	%endmacro


;*** FS and GS overides
%macro FSOVER 0
	db	64h
	%endmacro
%macro GSOVER 0
	db	65h
	%endmacro

;   *** General Register 32 bit moves ***

%macro MOV_EBX_EAX 0
	db  66h
	mov bx, ax
	%endmacro

%macro MOV_EAX_EBX 0
	db  66h
	mov ax, bx
	%endmacro

%macro MOV_ECX_EAX 0
	db  66h
	mov cx, ax
	%endmacro

%macro MOV_EAX_ECX 0
	db  66h
	mov ax, cx
	%endmacro

%macro MOV_EDX_EAX 0
	db  66h
	mov dx, ax
	%endmacro

%macro MOV_EAX_EDX 0
	db  66h
	mov ax, dx
	%endmacro

%macro MOV_EDI_EAX 0
	db  66h
	mov di, ax
	%endmacro

%macro MOV_EAX_EDI 0
	db  66h
	mov ax, di
	%endmacro

%macro MOV_ESI_EAX 0
	db  66h
	mov si, ax
	%endmacro

%macro MOV_EAX_ESI 0
	db  66h
	mov ax, si
	%endmacro

%macro MOV_EBP_EAX 0
	db  66h
	mov bp, ax
	%endmacro

%macro MOV_EAX_EBP 0
	db  66h
	mov ax, bp
	%endmacro

%macro MOV_ESP_EAX 0
	db  66h
	mov sp, ax
	%endmacro

%macro MOV_EAX_ESP 0
	db  66h
	mov ax, sp
	%endmacro

;   *** Special Register/EAX 32 bit moves ***

%macro MOV_CR0_EAX 0
	db	0Fh,22h,0C0h
	%endmacro

%macro MOV_CR0_EBX 0
	db	0Fh,22h,0C3h
	%endmacro

%macro MOV_CR0_ECX 0
	db	0Fh,22h,0C1h
	%endmacro

%macro MOV_CR0_EDX 0
	db	0Fh,22h,0C2h
	%endmacro

%macro MOV_CR0_ESP 0
	db	0Fh,22h,0C4h
	%endmacro

%macro MOV_CR0_EBP 0
	db	0Fh,22h,0C5h
	%endmacro

%macro MOV_CR0_ESI 0
	db	0Fh,22h,0C6h
	%endmacro

%macro MOV_CR0_EDI 0
	db	0Fh,22h,0C7h
	%endmacro

%macro MOV_EAX_CR0 0
	db	0Fh,20h,0C0h
	%endmacro

%macro MOV_EBX_CR0 0
	db	0Fh,20h,0C3h
	%endmacro

%macro MOV_ECX_CR0 0
	db	0Fh,20h,0C1h
	%endmacro

%macro MOV_EDX_CR0 0
	db	0Fh,20h,0C2h
	%endmacro

%macro MOV_ESP_CR0 0
	db	0Fh,20h,0C4h
	%endmacro

%macro MOV_EBP_CR0 0
	db	0Fh,20h,0C5h
	%endmacro

%macro MOV_ESI_CR0 0
	db	0Fh,20h,0C6h
	%endmacro

%macro MOV_EDI_CR0 0
	db	0Fh,20h,0C7h
	%endmacro

%macro MOV_CR2_EAX 0
	db	0Fh,22h,0D0h
	%endmacro

%macro MOV_EAX_CR2 0
	db	0Fh,20h,0D0h
	%endmacro

%macro MOV_CR3_EAX 0
	db	0Fh,22h,0D8h
	%endmacro

%macro MOV_EAX_CR3 0
	db	0Fh,20h,0D8h
	%endmacro

%macro MOV_DR0_EAX 0
	db	0Fh,23h,0C0h
	%endmacro

%macro MOV_DR0_EBX 0
	db	0Fh,23h,0C3h
	%endmacro

%macro MOV_DR1_EAX 0
	db	0Fh,23h,0C8h
	%endmacro

%macro MOV_DR2_EAX 0
	db	0Fh,23h,0D0h
	%endmacro

%macro MOV_DR3_EAX 0
	db	0Fh,23h,0D8h
	%endmacro

%macro MOV_DR6_EAX 0
	db	0Fh,23h,0F0h
	%endmacro

%macro MOV_DR7_EAX 0
	db	0Fh,23h,0F8h
	%endmacro

%macro MOV_EAX_DR0 0
	db	0Fh,21h,0C0h
	%endmacro

%macro MOV_ECX_DR0 0
	db	0Fh,21h,0C1h
	%endmacro

%macro MOV_EDX_DR0 0
	db	0Fh,21h,0C2h
	%endmacro

%macro MOV_EAX_DR1 0
	db	0Fh,21h,0C8h
	%endmacro

%macro MOV_EAX_DR2 0
	db	0Fh,21h,0D0h
	%endmacro

%macro MOV_EAX_DR3 0
	db	0Fh,21h,0D8h
	%endmacro

%macro MOV_EAX_DR6 0
	db	0Fh,21h,0F0h
	%endmacro

%macro MOV_EAX_DR7 0
	db	0Fh,21h,0F8h
	%endmacro

%macro MOV_TR6_EAX 0
	db	0Fh,26h,0F0h
	%endmacro

%macro MOV_EAX_TR6 0
	db	0Fh,24h,0F0h
	%endmacro

%macro MOV_TR7_EAX 0
	db	0Fh,26h,0F8h
	%endmacro

%macro MOV_EAX_TR7 0
	db	0Fh,24h,0F8h
	%endmacro

;   *** 32 bit Register/Immediate moves ***

%macro MOV_EAX_ 1
	db	66h, 0B8h
	dd	imm
	%endmacro

%macro MOV_EBX_ 1
	db	66h, 0BBh
	dd	imm
	%endmacro

%macro MOV_ECX_ 1
	db	66h, 0B9h
	dd	imm
	%endmacro

%macro MOV_EDX_ 1
	db	66h, 0BAh
	dd	imm
	%endmacro

%macro MOV_EDI_ 1
	db	66h, 0BFh
	dd	imm
	%endmacro

%macro MOV_ESI_ 1
	db	66h, 0BEh
	dd	imm
	%endmacro

%macro MOV_EBP_ 1
	db	66h, 0BDh
	dd	imm
	%endmacro

%macro MOV_ESP_ 1
	db	66h, 0BCh
	dd	imm
	%endmacro

;   *** 32-bit immediate arithmetic instructions

%macro ADD_EAX_ 1
	db	66h,05h
	dd	imm
	%endmacro

%macro ADD_EBX_ 1
	db	66h,81h,0C3h
	dd	imm
	%endmacro

%macro ADD_ECX_ 1
	db	66h,81h,0C1h
	dd	imm
	%endmacro

%macro ADD_EDX_ 1
	db	66h,81h,0C2h
	dd	imm
	%endmacro

%macro SUB_EAX_ 1
	db	66h,2Dh
	dd	imm
	%endmacro

%macro SUB_EBX_ 1
	db	66h,81h,0EBh
	dd	imm
	%endmacro

%macro SUB_ECX_ 1
	db	66h,81h,0E9h
	dd	imm
	%endmacro

%macro SUB_EDX_ 1
	db	66h,81h,0EAh
	dd	imm
	%endmacro

%macro CMP_EAX_ 1
	db	66h,3Dh
	dd	imm
	%endmacro

%macro CMP_EBX_ 1
	db	66h,81h,0FBh
	dd	imm
	%endmacro

%macro CMP_ECX_ 1
	db	66h,81h,0F9h
	dd	imm
	%endmacro

%macro CMP_EDX_ 1
	db	66h,81h,0FAh
	dd	imm
	%endmacro

;   *** New Segment Register/AX moves ***

%macro MOV_FS_AX 0
	db	8Eh,0E0h
	%endmacro

%macro MOV_AX_FS 0
	db	8Ch,0E0h
	%endmacro

%macro MOV_GS_AX 0
	db	8Eh,0E8h
	%endmacro

%macro MOV_AX_GS 0
	db	8Ch,0E8h
	%endmacro

;   *** New Segment Register pushes & pops ***

%macro PUSH_FS 0
	db	0Fh,0A0h
	%endmacro

%macro PUSH_GS 0
	db	0Fh,0A8h
	%endmacro

%macro POP_FS 0
	db	0Fh,0A1h
	%endmacro

%macro POP_GS 0
	db	0Fh,0A9h
	%endmacro

;   *** New Segment Register offset 16 memory moves ***

%macro MOV_off16_FS 1
	db	8Ch,26h
	dw	off16
	%endmacro

%macro MOV_FS_off16 1
	db	8Eh,26h
	dw	off16
	%endmacro

%macro MOV_off16_GS 1
	db	8Ch,2Eh
	dw	off16
	%endmacro

%macro MOV_GS_off16 1
	db	8Eh,2Eh
	dw	off16
	%endmacro

;   *** General Register 32 bit pushes & pops ***

%macro PUSH_EAX 0
	db  66h
	push	ax
	%endmacro

%macro POP_EAX 0
	db  66h
	pop	ax
	%endmacro

%macro PUSH_EBX 0
	db  66h
	push	bx
	%endmacro

%macro POP_EBX 0
	db  66h
	pop	bx
	%endmacro

%macro PUSH_ECX 0
	db  66h
	push	cx
	%endmacro

%macro POP_ECX 0
	db  66h
	pop	cx
	%endmacro

%macro PUSH_EDX 0
	db  66h
	push	dx
	%endmacro

%macro POP_EDX 0
	db  66h
	pop	dx
	%endmacro

%macro PUSH_EDI 0
	db  66h
	push	di
	%endmacro

%macro POP_EDI 0
	db  66h
	pop	di
	%endmacro

%macro PUSH_ESI 0
	db  66h
	push	si
	%endmacro

%macro POP_ESI 0
	db  66h
	pop	si
	%endmacro

%macro PUSH_EBP 0
	db  66h
	push	bp
	%endmacro

%macro POP_EBP 0
	db  66h
	pop	bp
	%endmacro

%macro PUSH_ESP 0
	db  66h
	push	sp
	%endmacro

%macro POP_ESP 0
	db  66h
	pop	sp
	%endmacro


;   *** General Register 32 bit xors ***

%macro XOR_EAX_EAX 0
	db	66h
	xor	ax, ax
	%endmacro

%macro XOR_EBX_EBX 0
	db	66h
	xor	bx, bx
	%endmacro

%macro XOR_ECX_ECX 0
	db	66h
	xor	cx, cx
	%endmacro

%macro XOR_EDX_EDX 0
	db	66h
	xor	dx, dx
	%endmacro

%macro XOR_EBP_EBP 0
	db	66h
	xor	bp, bp
	%endmacro

; .list; end of INSTR386.INC
