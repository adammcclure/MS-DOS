;	SCCSID = @(#)forproc.asm	1.2 85/07/25
;
; .xlist
; .xcref
%macro BREAK 1
	; SUBTTL	subtitle
	; PAGE
%endmacro

	%include "FORCHNG.INC"
	%include "SYSCALL.INC"
	%include "FOREQU.INC"
	%include "FORMACRO.INC"
	%include "FORSWTCH.INC"
	%include "IOCTL.INC"
; .cref
; .list
SECTION .data
; END SECTION .data

SECTION .code
	; assume	cs:code,ds:data

	global FormatAnother?,Yes?,REPORT,USER_STRING
	global fdsksiz,badsiz,syssiz,datasiz,biosiz
	global AllocSize,AllocNum

	extern std_printf,crlf,PrintString
	extern Multiply_32_Bits
	extern AddToSystemSize

SECTION .data
	extern driveLetter
	extern msgInsertDisk
	extern msgFormatAnother?
	extern msgTotalDiskSpace
	extern msgSystemSpace
	extern msgBadSpace
	extern msgDataSpace
	extern Read_Write_Relative
	extern msgAllocSize
	extern MsgAllocNum
	extern deviceParameters
	extern bios
	extern dos
	extern command
	extern Serial_Num_Low
	extern Serial_Num_High
	extern msgSerialNumber
	extern SwitchMap


	extern inbuff

fdsksiz dd	0

syssiz	dd	0
biosiz	dd	0

badsiz	dd	0

datasiz dd	0

AllocSize dd	0				;				;AN000;
AllocNum dw	0				;				;AN000;
	dw	driveLetter
; END SECTION .data

FormatAnother?:
; Wait for key. If yes return carry clear, else no. Insures
;   explicit Y or N answer.
	Message msgFormatAnother?		;				;AC000;
	CALL	Yes?
	JNC	WAIT20
	JZ	WAIT20
	CALL	CRLF
	JMP	SHORT FormatAnother?
WAIT20: 					;				;AC000;
	RET					;				;AC000;
; ENDP FormatAnother?

;*****************************************************************************
;Routine name:Yes?
;*****************************************************************************
;
;Description: Validate that input is valid Y/N for the country dependent info
;	      Wait for key. If YES return carry clear,else carry set.
;	      If carry is set, Z is set if explicit NO, else key was not Yes or No.
;
;Called Procedures: Message (macro)
;		    User_String
;
;Change History: Created	4/32/87 	MT
;
;Input: None
;
;Output: CY = 0 Yes is entered
;	 CY = 1, Z = No
;	 CY = 1, NZ = other
;
;Psuedocode
;----------
;
;	Get input (CALL USER STRING)
;	IF got character
;	   Check for country dependent Y/N (INT 21h, AX=6523h Get Ext Country)
;	   IF Yes
;	      clc
;	   ELSE (No)
;	      IF No
;		 stc
;		 Set Zero flag
;	      ELSE (Other)
;		 stc
;		 Set NZ
;	      ENDIF
;	   ENDIF
;	ELSE  (nothing entered)
;	   stc
;	   Set NZ flag
;	ENDIF
;	ret
;*****************************************************************************

Procedure YES?					;				;AN000;

	call	User_String			;Get character			;     ;
;	$IF	NZ				;Got one if returned NZ 	;AC000;
	JZ $$IF1
	   mov	   al,23h			;See if it is Y/N		;AN000;
	   mov	   dl,[InBuff+2]		;Get character			;AN000;
	   DOS_Call GetExtCntry 		;Get country info call		;AN000;
	   cmp	   ax,Found_Yes 		;Which one?			;AC000;
;	   $IF	   E				;Got a Yes			;AC000;
	   JNE $$IF2
	      clc				;Clear CY for return		;AN000;
;	   $ELSE				;Not a Yes			;AN000;
	   JMP SHORT $$EN2
$$IF2:
	      cmp     ax,Found_No		;Is it No?			;AC000;
;	      $IF     E 			;Yep				;AN000;
	      JNE $$IF4
		 stc				;Set CY for return		;AC000;
;	      $ELSE				;Something else we don't want   ;AN000;
	      JMP SHORT $$EN4
$$IF4:
		 xor	 al,al			;Set NZ flag for ret		;AC000;
		 cmp	 al,1			; " "	 " "			;AC000;
		 stc				;And CY flag for good measure	;AN000;
;	      $ENDIF				;				;AN000;
$$EN4:
;	   $ENDIF				;				;AN000;
$$EN2:
;	$ELSE					;No char found at all		;AN000;
	JMP SHORT $$EN1
$$IF1:
	   xor	   al,al			;Set NZ flag for ret		;AN000;
	   cmp	   al,1 			; " "	 " "			;AN000;
	   stc					;And CY flag for good measure	;AN000;
;	$ENDIF					;				;AN000;
$$EN1:
	ret					;				;     ;

; ENDP Yes?;				;AN000;


USER_STRING:
; Get a string from user. Z is set if user typed no chars (imm CR)
;  We need to flush a second time to get rid of incoming Kanji characters also.
	MOV	AX,(STD_CON_INPUT_FLUSH SHL 8) + 0 ; Clean out input
	INT	21H
	MOV	DX,INBUFF
	MOV	AH,STD_CON_STRING_INPUT
	INT	21H
	MOV	AX,(STD_CON_INPUT_FLUSH SHL 8) + 0 ; Clean out input
	INT	21H
	CMP	byte [INBUFF+1],0
	RET

;*********************************************
; Make a status report including the following information:
; Total disk capacity
; Total system area used
; Total bad space allocated
; Total data space available
; Number of allocation units
; Size of allocation units

REPORT:
	call	crlf

	call	Calc_System_Space		;an013; dms;calc system space
	call	Calc_Total_Addressible_Space	;an013; dms;calc total space

	Message msgTotalDiskSpace		;				;AC000;
						;call	 std_printf
	cmp	word SYSSIZ,0
	JNZ	SHOWSYS
	cmp	word SYSSIZ+2,0
	JZ	CHKBAD
SHOWSYS:
	Message msgSystemSpace			;				;AC000;
						;CALL	 std_printf		 ;Report space used by system
CHKBAD:
	cmp	word BADSIZ,0
	JNZ	SHOWBAD
	cmp	word BADSIZ+2,0
	JZ	SHOWDATA
SHOWBAD:
	Message msgBadSpace			;				;AC000;
						;call	 std_printf
SHOWDATA:


	MOV	CX,word Fdsksiz
	MOV	BX,word Fdsksiz+2
	SUB	CX,word BADSIZ
	SBB	BX,word BADSIZ+2
	SUB	CX,word SYSSIZ
	SBB	BX,word SYSSIZ+2
	MOV	word datasiz,CX
	MOV	word datasiz+2,BX
	Message msgDataSpace			;				;AC000;
						;call	 std_printf

	call	crlf				;				;AN000;
	mov	ax,deviceParameters.DP_BPB.BPB_BytesPerSector ; 		;AN000;
	mov	cl,deviceParameters.DP_BPB.BPB_SectorsPerCluster ;		;AN000;
	xor	ch,ch				;				;AN000;
	mul	cx				;Get bytes per alloc		;AN000;

	mov	word AllocSize,ax		;Save allocation size		;AN000;
	mov	word AllocSize+2,dx 	; for message			;AN000;
	Message msgAllocSize			;Print size of cluster		;AN000;
	call	Get_Free_Space			;an013; dms;get disk space

	mov	word AllocNum,bx		;Put result in msg		;AN000;
	Message msgAllocNum			; = cluster/disk		;AN000;
	call	crlf				;				;AN000;
	test	switchmap, SWITCH_8		;If 8 tracks, don't display     ;AN027;
	jnz	NOSERIALNUMBER			;serial number			;AN027;
	Message msgSerialNumber 		;Spit out serial number 	;AN000;
	call	crlf				;
NOSERIALNUMBER: 								;AN027;
	RET					;

;*****************************************************************************
;Routine name: Read_Disk
;*****************************************************************************
;
;description: Read in data using Generic IOCtl
;
;Called Procedures: None
;
;
;Change History: Created	5/13/87 	MT
;
;Input: AL = Drive number (0=A)
;	DS:BX = Transfer address
;	CX = Number of sectors
;	Read_Write_Relative.Start_Sector_High = Number of sectors high
;	DX = logical sector number low
;
;Output: CY if error
;	 AH = INT 25h error code
;
;Psuedocode
;----------
;	Save registers
;	Setup structure for function call
;	Read the disk (AX=440Dh, CL = 6Fh)
;	Restore registers
;	ret
;*****************************************************************************

Procedure Read_Disk				;				;AN000;

						;This is setup for INT 25h right;AN000;
						;Change it to Read relative sect;AN000;
	push	bx				;Save registers 		;AN000;
	push	cx				;				;AN000;
	push	dx				;				;AN000;
	push	si				;				;AN000;
	push	di				;				;AN000;
	push	bp				;				;AN000;
	push	es				;				;AN000;
	push	ds				;
	mov	si,data 			;				;AN000;
	mov	es,si				;				;AN000;

	; assume	es:data,ds:nothing;				;AN000;

	mov	es:Read_Write_Relative.Buffer_Offset,bx ;Get transfer buffer add;AN000;
	mov	bx,ds				;				;AN000;
	mov	es:Read_Write_Relative.Buffer_Segment,bx ;Get segment		;AN000;
	mov	bx,data 			;Point DS at parameter list	;AN000;
	mov	ds,bx				;				;AN000;

	; assume	ds:data,es:data

	mov	Read_Write_Relative.Number_Sectors,cx ;Number of sec to read	;AN000;
	mov	Read_Write_Relative.Start_Sector_Low,dx ;Start sector		;AN000;
	mov	bx,Read_Write_Relative	;				  ;AN000;
	mov	cx,0FFFFh			;Read relative sector		;AN000;
	INT	25h				;Do the read			;AN000;
	pop	dx				;Throw away flags on stack	;AN000;
	pop	ds				;
	pop	es				;				;AN000;
	pop	bp				;				;AN000;
	pop	di				;				;AN000;
	pop	si				;				;AN000;
	pop	dx				;Restore registers		;AN000;
	pop	cx				;				;AN000;
	pop	bx				;				;AN000;
	ret					;				;AN000;


; ENDP Read_Disk;				;AN000;

;*****************************************************************************
;Routine name: Write_Disk
;*****************************************************************************
;
;description: Write Data using Generic IOCtl
;
;Called Procedures: None
;
;
;Change History: Created	5/13/87 	MT
;
;Input: AL = Drive number (0=A)
;	DS:BX = Transfer address
;	CX = Number of sectors
;	Read_Write_Relative.Start_Sector_High = Number of sectors high
;	DX = logical sector number low
;
;Output: CY if error
;	 AH = INT 26h error code
;
;Psuedocode
;----------
;	Save registers
;	Setup structure for function call
;	Write to disk (AX=440Dh, CL = 4Fh)
;	Restore registers
;	ret
;*****************************************************************************

Procedure Write_Disk				;				;AN000;


						;This is setup for INT 26h right
						;Change it to Read relative sect

	push	bx				;Save registers 		;AN000;
	push	cx				;				;AN000;
	push	dx				;				;AN000;
	push	si				;				;AN000;
	push	di				;				;AN000;
	push	bp				;				;AN000;
	push	es				;				;AN000;
	push	ds				;
	mov	si,data 			;				;AN000;
	mov	es,si				;				;AN000;

	; assume	es:data,ds:nothing;				;AN000;

	mov	es:Read_Write_Relative.Buffer_Offset,bx ;Get transfer buffer add;AN000;
	mov	bx,ds				;				;AN000;
	mov	es:Read_Write_Relative.Buffer_Segment,bx ;Get segment		;AN000;
	mov	bx,data 			;Point DS at parameter list	;AN000;
	mov	ds,bx				;				;AN000;

	; assume	ds:data,es:data

	mov	Read_Write_Relative.Number_Sectors,cx ;Number of sec to write	;AN000;
	mov	Read_Write_Relative.Start_Sector_Low,dx ;Start sector		;AN000;
	mov	bx,Read_Write_Relative	;				;AN000;
	mov	cx,0FFFFh			;Write relative sector		;AN000;
	INT	26h				;Do the write			;AN000;
	pop	dx				;Throw away flags on stack	;AN000;
	pop	ds				;				;AN000;
	pop	es				;				;AN000;
	pop	bp				;				;AN000;
	pop	di				;				;AN000;
	pop	si				;				;AN000;
	pop	dx				;Restore registers		;AN000;
	pop	cx				;				;AN000;
	pop	bx				;				;AN000;
	ret					;				;AN000;

; ENDP Write_Disk;				;AN000;

;=========================================================================
; Calc_Total_Addressible_Space	: Calculate the total space that is
;				  addressible on the the disk by DOS.
;
;	Inputs	: none
;
;	Outputs : Fdsksiz - Size in bytes of the disk
;=========================================================================

Procedure Calc_Total_Addressible_Space		;an013; dms;

	push	ax				;an013; dms;save affected regs
	push	dx				;an013; dms;
	push	bx				;an013; dms;

	call	Get_Free_Space			;an013; dms;get free disk space

	push	bx				;an013; dms;save avail. cluster
	push	dx				;an013; dms;save total. cluster

	mov	ax,dx				;an013; dms;get total clusters

	xor	bx,bx				;an013; dms;clear bx
	xor	cx,cx				;an013; dms;clear cx
	mov	cl,DeviceParameters.DP_BPB.BPB_SectorsPerCluster  ;an013; dms;get total sectors
	call	Multiply_32_Bits		;an013; dms;multiply

	xor	cx,cx				;an013; dms;clear cx
	mov	cx,DeviceParameters.DP_BPB.BPB_BytesPerSector  ;an013; dms;get total bytes
	call	Multiply_32_Bits		;an013; dms; multiply

	mov	word Fdsksiz,ax		;an013; dms;save high word
	mov	word Fdsksiz+2,bx		;an013; dms;save low word

	pop	dx				;an000; dms;get total clusters
	pop	bx				;an000; dms;get avail clusters

	mov	ax,dx				;an013; dms;get total clusters
	sub	ax,bx				;an013; dms;get bad clusters

	xor	bx,bx				;an013; dms;clear bx
	xor	cx,cx				;an013; dms;clear cx
	mov	cl,DeviceParameters.DP_BPB.BPB_SectorsPerCluster  ;an013; dms;get total sectors
	call	Multiply_32_Bits		;an013; dms;multiply

	xor	cx,cx				;an013; dms;clear cx
	mov	cx,DeviceParameters.DP_BPB.BPB_BytesPerSector  ;an013; dms;get total bytes
	call	Multiply_32_Bits		;an013; dms; multiply

	sub	ax,word syssiz		;an013; dms;account for system
	sbb	bx,word syssiz+2		;an013; dms;size

	mov	word Badsiz,ax		;an013; dms;save high word
	mov	word Badsiz+2,bx		;an013; dms;save low word

	pop	bx				;an013; dms;
	pop	dx				;an013; dms;restore regs
	pop	ax				;an013; dms;

	ret					;an013; dms;

; ENDP Calc_Total_Addressible_Space;an013; dms;


;=========================================================================
; Get_Free_Space	: Get the free space on the disk.
;
;	Inputs	: none
;
;	Outputs : BX - Available space in clusters
;		  DX - Total space in clusters
;=========================================================================

Procedure Get_Free_Space			;an013; dms;

	xor	ax,ax				;an013; dms;clear ax
	mov	ah,36h				;an013; dms;Get disk free space
	mov	dl,driveletter			;an013; dms;get drive letter
	sub	dl,"A"				;an013; dms;get 0 based number
	inc	dl				;an013; dms;make it 1 based
	int	21h				;an013; dms;
	ret					;an013; dms;

; ENDP Get_Free_Space;an013; dms;

;=========================================================================
; Calc_System_Space	: This routine calculates the space occupied by
;			  the system on the disk.
;
;	Inputs	: DOS.FileSizeInBytes
;		  BIOS.FileSizeInBytes
;		  Command.FileSizeInBytes
;
;	Outputs : SysSiz			- Size of the system
;=========================================================================

Procedure Calc_System_Space							;an013; dms;

	push	ax								;an013; dms;save regs
	push	dx								;an013; dms;

	mov	word SysSiz+0,00h						;an013; dms;clear variable
	mov	word SysSiz+2,00h						;an013; dms;

	mov	ax,word [DOS.FileSizeInBytes+0]				;an013; dms;get low word
	mov	dx,word [DOS.FileSizeInBytes+2]				;an013; dms;get high word
	call	AddToSystemSize 						;an013; dms;add in values

	mov	ax,word [BIOS.FileSizeInBytes+0]				;an013; dms;get bios size
	mov	dx,word [BIOS.FileSizeInBytes+2]				;an013; dms;
	call	AddToSystemSize 						;an013; dms;add in values

	mov	ax,word [COMMAND.FileSizeInBytes+0] 			;an013; dms;get command size
	mov	dx,word [COMMAND.FileSizeInBytes+2] 			;an013; dms;
	call	AddToSystemSize 						;an013; dms;add in values

	pop	dx								;an013; dms;restore regs
	pop	ax								;an013; dms;

	ret									;an013; dms;

; ENDP Calc_System_Space;an013; dms;



; END SECTION .code
	; end
