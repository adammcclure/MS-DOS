 ; page 80,132
;	SCCSID = @(#)tcmd2a.asm 4.1 85/06/25
;	SCCSID = @(#)tcmd2a.asm 4.1 85/06/25
; TITLE	PART5 COMMAND Transient routines.

	%include "comsw.asm"

; .xlist
; .xcref
	%include "DOSSYM.INC"
	%include "comequ.asm"
	%include "comseg.asm"
	%include "ioctl.inc"
; .list
; .cref


SECTION .CODERES;AC000;
; END SECTION .CODERES

SECTION .DATARES;AC000;
; END SECTION .DATARES

SECTION .TRANDATA;AC000;
	extern arg_buf_ptr
	extern BadCurDrv;AC000;
	extern clsstring
	extern dback_ptr
	extern display_ioctl;AN000;
	extern display_width;AN000;
	extern Extend_buf_ptr;AN049;
	extern linperpag;AN000;
	extern msg_disp_class;AN049;
	extern nulpath_ptr
	extern prompt_table
	extern string_buf_ptr;AC000;
	extern vermes_ptr
; END SECTION .TRANDATA

SECTION .TRANSPACE;AC000;
	extern Arg_Buf
	extern bwdbuf
	extern curdrv
	extern dirchar
	extern major_ver_num
	extern minor_ver_num
	extern srcxname;AN049;
	extern string_ptr_2
; END SECTION .TRANSPACE

SECTION .TRANCODE

; ASSUME	CS:TRANGROUP,DS:NOTHING,ES:NOTHING,SS:NOTHING

;---------------

SECTION .TRANSPACE;AC000;
	extern arg; the arg structure!
; END SECTION .transpace
;---------------

	extern cerror;AN049;
	extern crlf2
	extern drvbad
	extern std_printf

	global build_dir_for_chdir
	global build_dir_for_prompt
	global build_dir_string
	global cls
	global path
	global print_char
	global print_drive
	global print_version
	global print_b
	global print_back
	global print_eq
	global print_esc
	global print_g
	global print_l
	global print_prompt
	global version

	break	Version
; assume	ds:trangroup,es:trangroup

VERSION:
	call	crlf2
	call	print_version
	jmp	crlf2

print_version:
	mov	ah,Get_version
	int	int_command
	push	ax
	xor	ah,ah
	mov	major_ver_num,ax
	pop	ax
	xchg	ah,al
	xor	ah,ah
	mov	minor_ver_num,ax
	mov	dx,vermes_ptr
	jmp	std_printf

print_prompt:
	push	ds
	push	cs
	pop	ds				; MAKE SURE DS IS IN TRANGROUP
	push	es
	invoke	find_prompt			; LOOK FOR PROMPT STRING
	jc	PP0				; CAN'T FIND ONE
	cmp	byte [es:di],0
	jnz	PP1
PP0:
	call	print_drive			; USE DEFAULT PROMPT
	mov	al,sym
	call	print_char
	jmp	short PP5

PP1:
	mov	al,[es:di]			; GET A CHAR
	inc	di
	or	al,al
	jz	PP5				; NUL TERMINATED
	cmp	al,dollar			; META CHARACTER?
	jz	PP2				; NOPE
PPP1:
	call	print_char
	jmp	PP1

PP2:
	mov	al,[es:di]
	inc	di
	mov	bx,prompt_table-3
	or	al,al
	jz	PP5

PP3:
	add	bx,3
	invoke	upconv
	cmp	al,[bx]
	jz	PP4
	cmp	byte [bx],0
	jnz	PP3
	jmp	PP1

PP4:
	push	es
	push	di
	push	cs
	pop	es
	call	[bx+1]
	pop	di
	pop	es
	jmp	PP1

PP5:
	pop	es				; RESTORE SEGMENTS
	pop	ds
	return


print_back:
	mov	dx,dback_ptr
	jmp	std_printf

print_EQ:
	mov	al,'='
	jmp	short print_char

print_esc:
	mov	al,1BH
	jmp	short print_char

print_G:
	mov	al,rabracket
	jmp	short print_char

print_L:
	mov	al,labracket
	jmp	short print_char

print_B:
	mov	al,vbar

print_char:
	push	es
	push	ds
	pop	es
	push	di
	push	dx
	mov	dl,al				;AC000; Get char into al
	mov	ah,Std_CON_output		;AC000; print the char to stdout
	int	int_command			;AC000;
	pop	dx
	pop	di
	pop	es
	ret

print_drive:
	mov	ah,Get_Default_drive
	int	int_command
	add	al,capital_A
	call	print_char
	ret

; ASSUME	DS:TRANGROUP,ES:TRANGROUP

build_dir_for_prompt:
	xor	dl,dl
	mov	si,bwdbuf
	mov	di,SI
	mov	al,CurDrv
	add	al,'A'
	mov	ah,':'
	stosw
	mov	al,[dirchar]
	stosb
	xchg	si,di
	mov	string_ptr_2,di
	mov	ah,Current_dir
	int	int_command
	mov	dx,string_buf_ptr
	jnc	DoPrint
	mov	dx,BadCurDrv
DoPrint:
	call	std_printf

	ret

build_dir_for_chdir:
	call	build_dir_string
	mov	dx,bwdbuf
	mov	string_ptr_2,dx
	mov	dx,string_buf_ptr
	call	std_printf
	ret

build_dir_string:
	mov	dl,[ds:FCB]
	mov	al,DL
	add	al,'@'
	cmp	al,'@'
	jnz	gotdrive
	add	al,[CURDRV]
	inc	al

gotdrive:
	push	ax
	mov	si,bwdbuf+3
	mov	ah,Current_dir
	int	int_command
	jnc	dpbisok
	push	cs
	pop	ds
	jmp	drvbad

dpbisok:
	mov	di,bwdbuf
	mov	dx,di
	pop	ax
	mov	ah,':'
	stosw
	mov	al,[dirchar]
	stosb

	ret

	break	Path
; assume	ds:trangroup,es:trangroup

PATH:
	xor	al,al				;AN049; Set up holding buffer
	mov	di,srcxname	;AN049;   for PATH while parsing
	stosb					;AN049; Initialize PATH to null
	dec	di				;AN049; point to the start of buffer
	invoke	PGetarg 			; Pre scan for arguments
	jz	disppath			; Print the current path
	cmp	al,semicolon			;AC049; NUL path argument?
	jnz	pathslp 			;AC049;
	inc	si				;AN049; point past semicolon
	jmp	short scan_white		;AC049; Yes - make sure nothing else on line

pathslp:					; Get the user specified path
	lodsb					; Get a character
	cmp	al,end_of_line_in		;AC049; Is it end of line?
	jz	path_eol			;AC049; yes - end of command

	invoke	testkanj			;See if DBCS
	jz	notkanj2			;No - continue
	stosb					;AC049; Yes - store the first byte
	lodsb					;skip second byte of DBCS

path_hold:					;AN049;
	stosb					;AC049; Store a byte in the PATH buffer
	jmp	short pathslp			;continue parsing

notkanj2:
	invoke	upconv				;upper case the character
	cmp	al,semicolon			;AC049; ';' not a delimiter on PATH
	jz	path_hold			;AC049; go store it
	invoke	delim				;delimiter?
	jnz	path_hold			;AC049; no - go store character

scan_white:					;AN049; make sure were at EOL
	lodsb					;AN049; get a character
	cmp	al,end_of_line_in		;AN049; end of line?
	jz	path_eol			;AN049; yes - go set path
	cmp	al,blank			;AN049; whitespace?
	jz	scan_white			;AN049; yes - continue scanning
	cmp	al,tab_chr			;AN049; whitespace?
	jz	scan_white			;AN049; yes - continue scanning

	mov	dx,Extend_Buf_ptr ;AN049; no - set up error message
	mov	Extend_Buf_ptr,MoreArgs_ptr	;AN049; get "Too many parameters" message number
	mov	msg_disp_class,parse_msg_class	;AN049; set up parse error msg class
	jmp	cerror				;AN049;

path_eol:					;AN049; Parsing was clean
	xor	al,al				;AN049; null terminate the PATH
	stosb					;AN049;    buffer
	invoke	find_path			;AN049; Find PATH in environment
	invoke	delete_path			;AC049; Delete any offending name
	invoke	scan_double_null		;AC049; Scan to end of environment
	invoke	move_name			;AC049; move in PATH=
	mov	si,srcxname	;AN049; Set up source as PATH buffer

store_path:					;AN049; Store the PATH in the environment
	lodsb					;AN049; Get a character
	cmp	al,end_of_line_out		;AN049; null character?
	jz	got_paths			;AN049; yes - exit
	invoke	store_char			;AN049; no - store character
	jmp	short store_path		;AN049; continue

got_paths:					;AN049; we're finished
	xor	ax,ax				;null terminate the PATH in
	stosw					;    the environment
	return

disppath:
	invoke	find_path			;AN049;
	call	print_path
	call	crlf2
	return

print_path:
	cmp	byte [es:di],0
	jnz	path1

path0:
	mov	dx,nulpath_ptr
	push	cs
	pop	es
	push	cs
	pop	ds
	jmp	std_printf

path1:
	push	es
	pop	ds
	sub	di,5
	mov	si,di
; ASSUME	DS:RESGROUP
	invoke	scasb2				; LOOK FOR NUL
	cmp	cx,0FFH
	jz	path0
	push	cs
	pop	es
	mov	di,arg_buf
	mov	dx,100h
	sub	dx,cx
	xchg	dx,cx
	rep	movsb
	mov	dx,arg_buf_ptr
	push	cs
	pop	ds
	jmp	std_printf

; ASSUME	DS:TRANGROUP

	break	Cls

; ****************************************************************
; *
; * ROUTINE:	 CLS
; *
; * FUNCTION:	 Clear the screen using INT 10h.  If ANSI.SYS is
; *		 installed, send a control string to clear the
; *		 screen.
; *
; * INPUT:	 command line at offset 81H
; *
; * OUTPUT:	 none
; *
; ****************************************************************

; assume	ds:trangroup,es:trangroup

ANSI_installed		equ    0ffh

CLS:
	mov	ah,Mult_ANSI			;AN000; see if ANSI.SYS installed
	mov	al,0				;AN000;
	int	2fh				;AN000;
	cmp	al,ANSI_installed		;AN000;
	jz	ansicls 			;AN000; installed - go do ANSI CLS

check_lines:
	mov	ax,(IOCTL SHL 8) + generic_ioctl_handle ;AN000; get lines per page on display
	mov	bx,stdout			;AN000; lines for stdout
	mov	ch,ioc_sc			;AN000; type is display
	mov	cl,get_generic			;AN000; get information
	mov	dx,display_ioctl ;AN000;
	int	int_command			;AN000;
	jc	no_variable			;AN000; function had error, use default
	mov	ax,linperpag			;AN000; get number of rows returned
	mov	dh,al				;AN000; set number of rows
	mov	ax,display_width		;AN000; get number of columns returned
	mov	dl,al				;AN000; set number of columns
	jmp	short regcls			;AN000; go do cls

no_variable:
	mov	bx,stdout			;AC000; set handle as stdout
	mov	ax,IOCTL SHL 8			;AC000; do ioctl - get device
	int	int_command			;AC000;    info
	test	dl,devid_ISDEV			;AC000; is handle a device
	jz	ANSICLS 			;AC000; If a file put out ANSI
	test	dl,devid_SPECIAL		;AC000;
	jnz	cls_normal			;AC000; If not special CON, do ANSI

ansicls:
	call	ansi_cls			;AN000; clear the screen
	jmp	short cls_ret			;AN000; exit

;
; Get video mode
;

cls_normal:					;AC000;

	mov	ah,get_video_state		;AC000; set up to get video state
	int	video_io_int			;AC000; do int 10h - BIOS video IO
	cmp	al,video_alpha			;AC000; see if in text mode
	jbe	DoAlpha
	cmp	al,video_bw			;AC000; see if black & white card
	jz	DoAlpha
;
; We are in graphics mode.  Bogus IBM ROM does not scroll correctly.  We will
; be just as bogus and set the mode that we just got.  This will blank the
; screen too.
;
	mov	ah,set_video_mode		;AC000; set video mode call
	int	video_io_int			;AC000; do int 10h - BIOS video IO
	jmp	short cls_ret			;AC000; exit

DoAlpha:
;
; Get video mode and number of columns to scroll
;
	mov	ah,get_video_state		;AC000; set up to get current video state
	int	video_io_int			;AC000; do int 10h - BIOS video IO
	mov	dl,ah
	mov	dh,linesperpage 		;AC000; have 25 rows on the screen

regcls:
	call	reg_cls 			;AC000; go clear the screen

cls_ret:
	ret					;AC000; exit

; ****************************************************************
; *
; * ROUTINE:	 REG_CLS
; *
; * FUNCTION:	 Clear the screen using INT 10H.
; *
; * INPUT:	 DL = NUMBER OF COLUMNS
; *		 DH = NUMBER OF ROWS
; *
; * OUTPUT:	 none
; *
; ****************************************************************

reg_cls:;AC000;

;
; Set overscan to black.
;

	dec	dh				;AC000;  decrement rows and columns
	dec	dl				;AC000;     to zero base
	push	dx				;AN000;  save rows,columns
	mov	ah,set_color_palette		;AC000;  set up to set the color to blank
	xor	bx,bx
	int	video_io_int			;AC000; do int 10h - BIOS video IO
	pop	dx				;AN000;  retore rows,colums

	xor	ax,ax				;AC000;  zero out ax
	mov	CX,ax				;AC000;     an cx
;
; Scroll active page
;
	mov	ah,scroll_video_page		;AC000; set up to scroll page up
	mov	bh,video_attribute		;AC000; attribute for blank line
	xor	bl,bl				;AC000; set BL to 0
	int	video_io_int			;AC000; do int 10h - BIOS video IO
;
; Seek to cursor to 0,0
;
	mov	ah,set_cursor_position		;AC000; set up to set cursor position
	xor	dx,dx				;AC000; row and column 0
	mov	bh,0				;AC000;
	int	video_io_int			;AC000; do into 10h - BIOS video IO

	ret					;AC000;

; ENDP reg_cls;AC000;



; ****************************************************************
; *
; * ROUTINE:	 ANSI_CLS
; *
; * FUNCTION:	 Clear the screen using by writing a control code
; *		 to STDOUT.
; *
; * INPUT:	 none
; *
; * OUTPUT:	 none
; *
; ****************************************************************

ansi_cls:;AC000;

	mov	si,clsstring
	lodsb
	mov	cl,al
	xor	ch,ch
	mov	ah,Raw_CON_IO
clrloop:
	lodsb
	mov	DL,al
	int	int_command
	loop	clrloop
	return

; ENDP ansi_cls;AC000;

; END SECTION .trancode
	    ; end
