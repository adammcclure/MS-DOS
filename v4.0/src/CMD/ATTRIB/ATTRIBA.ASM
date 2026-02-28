	; page	,132;
	; title	New_C.C - DOS entry to the KWC's 'C' programs

;
;	This module has been modified extensively for my personal
;	use.
;
; name		XCMAIN -- initiate execution of C program
;
; description	This is the main module for a C program on the
;		DOS implementation.  It initializes the segment
;		registers, sets up the stack, and calls the C main
;		function _main with a pointer to the remainder of
;		the command line.
;
;		Also defined in this module is the exit entry point
;		XCEXIT.
;
;	   $salut (4,12,18,41)
SETBLOCK   EQU	 4AH			;MODIFY ALLOCATED MEMORY BLOCKS
					;ES = SEGMENT OF THE BLOCK
					;BX = NEW REQUESTED BLOCK SIZE
					;    IN PARAGRAPHS
					;OUTPUT: BX=MAX SIZE POSSIBLE IF CY SET
					;AX = ERROR CODE IF CY SET

RET_CD_EXIT EQU  4CH			;EXIT TO DOS, PASSING RETURN CODE
					;AL=RETURN CODE

RET_EXIT   equ	 4ch			;AN000; ;terminate
ABORT	   equ	 2			;AN000; ;if >=, retry
XABORT	   equ	 1			;AN000; ;errorlevel return in al


	   extern _inmain;AC000;
	   extern _Reset_appendx;AN000;
	   extern _old_int24_off;AN000;


SECTION .psp;<--emk
psp_ret: dw 0;int 20h
psp_memsz: dw 0;memory size
	   org	 2ch
psp_env: dw 0;segid of environment
	   org	 80h
psp_parlen: db 0;length of DOS command line parms
psp_par: times 127 db 0;DOS command line parms
; END SECTION .psp
	   ; page

;
; The following segment serves only to force "pgroup" lower in
; memory.
;

SECTION .base

	   db	 00dh,00ah
	   db	 "----------\x0d\x0a"
	   db	 " DOS ATTRIB function \x0d\x0a"
	   db	 "--------------------\x0d\x0a"
	   db	 00dh,00ah,01ah

; END SECTION .base


;
; The data segment defines locations which contain the offsets
; of the base and top of the stack.
;

SECTION ._data

	   ; irp	 name,<_top,_base,_cs,_ss,_psp,_env,_rax,_rbx,_rcx,_rdx,_rds,_rsi,_rbp,_res,_rdi>
	   global name
; name	   dw	 0
	   %endmacro

; END SECTION ._data

;
; The stack segment is included to prevent the warning from the
; linker, and also to define the base (lowest address) of the stack.
;

SECTION .stack

SBase: times 128 dw 0

; END SECTION .stack

SECTION .null
; END SECTION .null
SECTION .const
; END SECTION .const
SECTION ._bss
; END SECTION ._bss
; pgroup	   group base,_text
; dgroup	   group null, _data, const, _bss, stack

	   ; page

;
; The main program must set up the initial segment registers
; and the stack pointer, and set up a far return to the DOS
; exit point at ES:0.  The command line bytes from the program
; segment prefix are moved onto the stack, and a pointer to
; them supplied to the C main module _main (which calls main).
;

SECTION ._text

	   global XCMAIN

	   ; assume cs:pgroup
	   ; assume ds:psp;<--emk
	   ; assume es:psp;<--emk
	   ; assume ss:stack;<--emk

XCMAIN:

	   mov	 ax,dgroup
	   mov	 ds,ax			;initialize ds and ss
	   ; assume ds:dgroup

	   mov	 bx,psp_memsz		;total memory size (paragraphs)
	   sub	 bx,ax
	   test  bx,0f000h
;	   $IF	 Z			;branch if more than or equal 64K bytes
	   JNZ $$IF1

	       mov   cl,4
	       shl   bx,cl		;highest available byte
;	   $ELSE
	   JMP SHORT $$EN1
$$IF1:
	       mov   bx,0fff0h
;	   $ENDIF
$$EN1:
	   cli				; disable interrupts while changing stack <---kwc
	   mov	 ss,ax			; set ss <---kwc
	   mov	 sp,bx			; set stack pointer <---kwc
	   sti				;enable interrupts
	   ; assume ss:DGroup;<--emk

	   mov	 _ss,ss
	   mov	 _cs,cs
	   mov	 _top,bx		;save top of stack

	   mov	 ax,SBase
	   mov	 _base,ax		;store ptr to bottom of stack

; code added here to allow allocates and exec's in the c code
;  we will have to calculate the size of the code that has been loaded

	   mov	 bx,sp			; bx = length of the stack
	   shr	 bx,1
	   shr	 bx,1
	   shr	 bx,1
	   shr	 bx,1			; bx = number of paragraphs in stack,
	   add	 bx,1			;   (fudge factor!)<--emk ,was 10
	   mov	 ax,ss
	   add	 bx,ax			; bx = paragraph a little past the stack
	   mov	 ax,es			; ax = paragraph of the psp
	   sub	 bx,ax			; bx = number of paragraphs in code
	   mov	 ah,setblock
	   int	 021h

; end of added code!

	   mov	 _psp,es		; save pointer to psp for setblock <---kwc
	   mov	 cl,psp_parlen		;get number of bytes <--emk
	   xor	 ch,ch			;cx = number of bytes of parms!
	   mov	 si,psp_par	;point to DOS command line parms <--emk

; more modified code, picking up argv[0] from the environment!

	   mov	 ds,psp_env		;set ds to segid of environment from es:psp
	   ; assume ds:nothing

	   mov	 _env,ds		;remember where environment is

	   mov	 si,0			;clear index to step thru env
;The env has a set of keyword=operand, each one ending with a single null byte.
;At the end of the last one is a double null.  We are looking for the end of
;all these keywords, by looking for the double null.
;	   $DO	 COMPLEX
	   JMP SHORT $$SD4
$$DO4:
	       inc   si 		;bump index to look at next byte in env
;	   $STRTDO
$$SD4:
	       cmp   word [si],0	;is this a double null delimiter?
;	   $ENDDO E			;ifdouble null found, exit
	   JNE $$DO4
;At end of env is the double null and a word counter
	   add	 si,4			;step over this double null delimiter
					; and the following word counter
	   push  si			;save pointer to next field in env
;This is the invocation statement, including the path name, even if not specified
;but supplied by PATH.

;continue stepping thru env looking for one more null byte, which indicates
;the end of the invocation command.
;	   $DO
$$DO7:
	       lodsb			;get a byte from env to al
	       cmp   al,0		;is this a null byte?
;	   $ENDDO E			;quit if null is found
	   JNE $$DO7

	   mov	 bx,si			; bx -> asciiz zero
	   pop	 si			; si -> first byte of agrv[0], the invocation command
	   sub	 bx,si			; bx = length of argv[0]
	   mov	 dx,bx			; (save for the copy later)
	   dec	 dx
	   add	 bx,cx			; add in the length of the rest of the parms
	   inc	 bx			; add one for the asciiz zero!
	   and	 bx,0fffeh		;force even number of bytes
	   add	 bx,2			;adjust for possible rounding error
	   sub	 sp,bx			;allocate space on stack
	   mov	 di,sp			; (es:di) -> where we will put the stuff
	   push  es
	   mov	 ax,ss
	   mov	 es,ax
	   xchg  cx,dx			; length of argv[0] to copy, save length of parms
	   rep	 movsb			; (ds:si) already point to argv[0]
	   pop	 es
	   mov	 ss:byte [di],' '	;store trailing blank!
	   inc	 di
	   mov	 _rdi,di		;AN000; save start of command parms
	   xchg  cx,dx			; restore length of parms
;	   $IF	 NCXZ			;if some bytes to move,
	   JCXZ $$IF9

	       mov   si,psp_par	;point to DOS command line parms in psp
;	       $DO
$$DO10:
		   mov	 al,es:[si]	;move bytes to stack
		   mov	 ss:[di],al
		   inc	 si
		   inc	 di
;	       $ENDDO LOOP
	       LOOP $$DO10
;	   $ENDIF			;bytes to move?
$$IF9:
	   xor	 ax,ax
	   mov	 ss:[di],al		;store null byte
	   mov	 ax,ss
	   mov	 ds,ax			;es, ds, and ss are all equal
	   ; assume ds:DGroup

	   mov	 es,ax			;es, ds, and ss are all equal
	   ; assume es:DGroup

	   mov	 ax,_rdi		;AN000; restore offset of parms on stack
	   push  ax			;ptr to command line

	   call  _inmain		;AC000; call C main

	   mov	 ah,ret_cd_exit 	;return to DOS
	   int	 21h			;errorlevel ret code in al

; ENDP XCMAIN

	   ; page

;
; name		XCEXIT -- terminate execution of C program
;
; description	This function terminates execution of the current
;		program by returning to DOS.  The error code
;		argument normally supplied to XCEXIT is ignored
;		in this implementation.
;
;	input - al = binary return code for dos/ERRORLEVEL
;

	   ; assume cs:PGroup
	   ; assume ds:DGroup
	   ; assume es:DGroup
	   ; assume ss:DGroup

	   global xcexit
XCEXIT:

	   mov	 ah,ret_cd_exit 	;				<--- kwc
	   int	 021h			;				<--- kwc

; ENDP XCEXIT

;--------------------------------------------------------------------------

	   ; PAGE

%macro CENTER 1
	   PUSH  BP			; SAVE CURRENT BP
	   MOV	 BP,SP			; POINT AT STACK WITH BP
WORKOFS    =	 0
	   ; IRP	 ANAME,<NAMELIST>; FOR EACH WORKING VARIABLE
	   %if 1  ; IFNB <&ANAME>
WORKOFS        =     WORKOFS-2		;  WE WILL ALLOCATE ONE
	       DOEQU &ANAME,%WORKOFS	;   WORD ON THE STACK THAT
	   %endif
	   %endmacro;    IS UNDER SS,BP
	   ADD	 SP,WORKOFS
	   %endmacro

%macro DOEQU 2
&NAME	   EQU	 &VALUE
	   %endmacro

%macro CEXIT 1
	   MOV	 SP,BP
	   POP	 BP
	   RET
	   %endmacro

	   ; PAGE

; INPUT PARAMATERS PASSED ON STACK

struc PARMS

OLD_BP: dw 0; SAVED BP
RETADD: dw 0; RETURN ADDRESS
PARM_1: dw 0
PARM_2: dw 0
PARM_3: dw 0
PARM_4: dw 0
PARM_5: dw 0
PARM_6: dw 0
PARM_7: dw 0
PARM_8: dw 0

endstruc

SAVE_SS    DW	 0
SAVE_SP    DW	 0

	   ; PAGE

;************************************************************************
;									;
; Subroutine Name:							;
;	getpspbyte							;
;									;
; Subroutine Function:							;
;	 get a byte from PSP						;		      ;
;									;
; Input:								;
;	SS:[BP]+PARM1 = offset in PSP					;
;									;
; Output:								;
;	AL =  byte from PSP:offset					;
;									;
; C calling convention: 						;
;	char = getpspbyte(offset);					;
;									;
;************************************************************************

MOFFSET    EQU	 PARM_1 		;AN000;

	   ; ASSUME CS:PGROUP;AN000;
	   ; ASSUME DS:DGROUP;AN000;
	   ; ASSUME ES:DGROUP;AN000;
	   ; ASSUME SS:DGROUP;AN000;

	   global _GETPSPBYTE;AN000;
_GETPSPBYTE:;AN000;

	   CENTER			;AN000;

	   PUSH  DS			;AN000;

	   MOV	 DS,_PSP		;AN000; get save PSP segment
	   MOV	 SI,[BP].MOFFSET	;AN000; get offset into PSP
	   LODSB			;AN000; get PSP byte
	   MOV	 AH,0			;AN000; zero high byte

	   POP	 DS			;AN000;

	   CEXIT			;AN000;

; ENDP _GETPSPBYTE


;************************************************************************
;									;
; Subroutine Name:							;
;	putpspbyte							;
;									;
; Subroutine Function:							;
;	 put a byte into PSP						;		      ;
;									;
; Input:								;
;	SS:[BP]+MVALUE = byte in AL					;
;	SS:[BP]+MOFFSET = offset in PSP 				;
;									;
; Output:								;
;	none								;
;									;
; C calling convention: 						;
;	putpspbyte(offset,char);					;
;									;
;************************************************************************


MVALUE	   EQU	 PARM_2 		;AN000;
MOFFSET    EQU	 PARM_1 		;AN000;

	   ; ASSUME CS:PGROUP;AN000;
	   ; ASSUME DS:DGROUP;AN000;
	   ; ASSUME ES:DGROUP;AN000;
	   ; ASSUME SS:DGROUP;AN000;

	   global _PUTPSPBYTE;AN000;
_PUTPSPBYTE:;AN000;

	   CENTER			;AN000;

	   PUSH  ES			;AN000;

	   MOV	 AX,[BP].MVALUE 	;AN000; get byte to store in PSP
	   MOV	 ES,_PSP		;AN000; get saved PSP segment
	   MOV	 DI,[BP].MOFFSET	;AN000; get offset in PSP
	   STOSB			;AN000; store the byte

	   POP	 ES			;AN000;

	   CEXIT			;AN000;

; ENDP _PUTPSPBYTE


;-------------------------------------------------------------------
;
;	MODULE: 	crit_err_handler()
;
;	PURPOSE:	Supplies assembler exit routines for
;			critical error situations
;
;	CALLING FORMAT:
;			crit_err_handler;
;-------------------------------------------------------------------
	   global _crit_err_handler;AN000;
	   global vector;AN000;
vector	   dd	 0						       ;AN000;
;								       ;AN000;
_crit_err_handler:;AN000;
	   pushf						       ;AN000;
	   push  ax			; save registers	       ;AN000;
	   push  ds						       ;AN000;
	   mov	 ax,dgroup		;get C data segment	       ;AN000;
	   mov	 ds,ax						       ;AN000;
	   mov	 ax,word ds:_old_int24_off ;get int24 offset       ;AN000;
	   mov	 word cs:vector,ax				       ;AN000;
	   mov	 ax,word ds:_old_int24_off+2 ;get int24 segment    ;AN000;
	   mov	 word cs:vector+2,ax			       ;AN000;
	   pop	 ds			;restore registers	       ;AN000;
	   pop	 ax						       ;AN000;
;								       ;AN000;
	   call  dword cs:vector	; invoke DOS err hndlr	       ;AN000;
	   cmp	 al,ABORT		; what was the user's response ;AN000;
	   jnge  retry			;			       ;AN000;
;								       ;AN000;
	   mov	 ax,dgroup		;get C data segment	       ;AN000;
	   mov	 ds,ax						       ;AN000;
	   mov	 es,ax						       ;AN000;
	   call  _Reset_appendx 	; restore user's orig append/x ;AN000;
;								       ;AN000;
	   mov	 ax,(RET_EXIT shl 8)+XABORT ; return to DOS w/criterr error ;AN000;
	   int	 21h			;			       ;AN000;
retry:								       ;AN000;
	   iret 						       ;AN000;
;								       ;AN000;
; ENDP _crit_err_handler;AN000;
; END SECTION ._text;AN000;
	   ; end	 XCMAIN;AN000;
