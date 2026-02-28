;
; This file contains three macros used in debugging the system.  If the
; variable "itest" (in msbio.asm) is nonzero code is included in the
; modules to print debugging messages.	The level of debugging is controlled
; by the value of the variable fTestBits in msbio.asm.	Specific bits in
; the variable determine which messages to print.  The equ's below tell
; which bits control which funcitons.  For example the fifth bit
; cooresponds to disk activity (see fTestDisk equ below).
;
;   The macros in the file are:
;
;	message    Prints an ascii string on the screen.
;		   Example usage:
;
;		      message fTestDisk, <"Start Disk Write", CR, LF>
;		      message fTestINIT, <"Begin BDS initialization">
;
;
;	MNUM	   Print the value in a register or memory location on
;		   the screen. Value is displayed in hex.
;		   Usage:
;		      MNUM  bitpattern, valueLocation
;
;		   valueLocation is typically a regester:
;
;		      mnum  fTestCom, AX
;		      mnum  fTestDisk, DX
;
;		   ValueLocation can also be a memory location:
;
;		      mnum  fTestINIT, Final_Dos_Location
;
;		   If no valueLocation is given the macro defaults to
;		   the BX register.
;
;	ZWAIT	    Stops the program until any key is pressed.
;
;
;	The three macros preserve all register values.	If "test" is zero
;	defined during assembly then the  marco produce no code.
;

	%if iTEST;3.30
	   %ifndef MSGOUT;3.30
		extern MSGOUT,MSGNUM;3.30
	   %endif;3.30
	   %ifndef NUMBUF;3.30
	    extern NUMBUF,DIGITS,FTESTBITS;3.30
	   %endif;3.30
	   %ifndef DUMPBYTES;3.30
		extern DUMPBYTES,OUTCHAR,HEX_TO_ASCII;3.30
	   %endif;3.30



fTestALL    equ     1111111111111111b	; watch everything
fTestHARD   equ     0000000000000001b	; watch hard disk initialization
fTest96     equ     0000000000000010b	; watch 96 tpi activity
FTEST13     EQU     0000000000000100B	; WATCH INT 13 ACTIVITY 	  ;3.30
FTESTCOM    EQU     0000000000001000B	; WATCH PACKET ACTIVITY 	  ;3.30
FTESTINIT   EQU     0000000000010000B	; WATCH INITIALIZATION MESSAGES   ;3.30
FTESTDISK   EQU     0000000000100000B	; WATCH DISK DEVICE DRIVER CALLS  ;3.30
FTESTCON    EQU     0000000001000000B	; WATCH SYSTEM WAIT ACTIVITY IN CO;3.30 NSOLE
FtestClock  equ     0000000010000000b	; wathc clock device  5/2/86  ;3.30


;
; message macro -- see above for description
;

%macro MESSAGE 2
	    ; LOCAL A,B;3.30
	jmp	SHORT b
a:	db	msg,0
b:	push	SI
	push	AX
	mov	AX,Bits
	mov	SI,a
	call	MSGOUT
	pop	AX
	pop	SI
%endmacro


;
; mnum macro -- see above for description
;

%macro MNum 2
	push	AX
%if 0  ; IFB <num>
	mov	AX,Bits
	call	MSGNUM
%else
	push	BX
	mov	BX,num
	mov	AX,Bits
	call	MSGNUM
	pop	BX
%endif
	pop	AX
%endmacro


;
; zwait macro -- see above for description
;

%macro ZWAIT 0
	Message fTestALL,<"? ">
	CALL	ZWAITrtn
%endmacro

ZWAITrtn:
	pushf				; save the flags
	push	AX			; preserve AX
	xor	AH, AH			; set command to get character ;3.30*
	int	16h			; call rom keyboard routine    ;3.30*
	pop	AX			; restore AX
	popf				; restore the flags
	ret

;Dump_byte dumps the memory contents in hex. 				  ;3.30
;DUMPOFFLABEL should be a label or a variable defined in DUMPSEG.	  ;3.30
%macro DUMP_BYTE 3;3.30
	push	es							  ;3.30
	PUSH	DS							  ;3.30
	PUSH	SI							  ;3.30
	PUSH	CX							  ;3.30
									  ;3.30
	MOV	CX, DUMPSEG						  ;3.30
	MOV	DS, CX							  ;3.30
	MOV	SI, DUMPOFFLABEL 				  ;3.30
	MOV	CX, BYTELENGTH						  ;3.30
	call	dumpbytes						  ;3.30
									  ;3.30
	POP	CX							  ;3.30
	POP	SI							  ;3.30
	POP	DS							  ;3.30
	pop	es							  ;3.30
	%endmacro;3.30
									  ;3.30
;Dump_Byte_Reg dumps the memory contents in hex. -  4/9/86		  ;3.30
;DUMPOFFREG should be a register contains the offset value in DUMPSEG.	  ;3.30
%macro DUMP_BYTE_REG 3;3.30
	push	es							  ;3.30
	PUSH	DS							  ;3.30
	PUSH	SI							  ;3.30
	PUSH	CX							  ;3.30
									  ;3.30
	MOV	CX, DUMPSEG						  ;3.30
	MOV	DS, CX							  ;3.30
	MOV	SI, DUMPOFFREG						  ;3.30
	MOV	CX, BYTELENGTH						  ;3.30
	call	dumpbytes						  ;3.30
									  ;3.30
	POP	CX							  ;3.30
	POP	SI							  ;3.30
	POP	DS							  ;3.30
	pop	es							  ;3.30
	%endmacro;3.30

%else
		; if test is not defined then make macro into null statements
%macro Message 0
%endmacro

%macro MNUM 0
%endmacro

%macro ZWAIT 0
%endmacro

%macro DUMP_BYTE 0;3.30
	    %endmacro;3.30
%macro DUMP_BYTE_REG 0;3.30
	    %endmacro;3.30
	%endif;3.30
									  ;3.30
%macro PATHSTART 2;3.30
	%ifdef PATHGEN;3.30
	    global ABBR&INDEX&S,ABBR&INDEX&E;3.30
	    ABBR&INDEX&S LABEL	 BYTE					  ;3.30
	%endif;3.30
	%endmacro;3.30
									  ;3.30
%macro PATHEND 2;3.30
	%ifdef PATHGEN;3.30
	    ABBR&INDEX&E LABEL	 BYTE					  ;3.30
	%endif;3.30
	%endmacro;3.30

