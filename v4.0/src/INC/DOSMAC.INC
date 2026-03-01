;	SCCSID = @(#)dosmac.asm	1.1 85/04/10
;	SCCSID = @(#)dosmac.asm	1.1 85/04/10
;
; Macro file for MSDOS.
;

TRUE    EQU 0FFFFh
FALSE   EQU 0

; SUBTTL BREAK a listing into pages and give new subtitles
; PAGE
%macro BREAK 1
	; SUBTTL  subtitle
	; PAGE
%endmacro
; .xcref  break

BREAK   <ASMVAR - handle assembly variables once and for all>

%macro AsmVars 1
; IRP     var,<varlist>
AsmVar  var
%endmacro
%endmacro

%macro AsmVar 1
%ifndef var
var equ FALSE
%endif
%endmacro

BREAK <I_NEED: declare a variable external, if necessary, and allocate a size>

;
; declare a variable external and allocate a size
;
AsmVar  InstalledData
%macro I_NEED 2
%if ~InstalledData
	SECTION .DATA
    %ifidn <len>,<WORD>
	extern &sym
    %else
	%ifidn <len>,<DWORD>
	extern &sym
	%else
	extern &sym
	%endif
    %endif
	; END SECTION .DATA
%endif
%endmacro
	; .xcref I_need

;
; call a procedure that may be external.  The call will be short.
;
%macro invoke 1
; .xcref
	%if 1  ; IF2 - pass-specific
	    %ifndef name
	extern name
	    %endif
	%endif
; .cref
	CALL    name
%endmacro
; .xcref  invoke

; PAGE
;
; jump to a label that may be external.  The jump will be near.
;
%macro transfer 1
; .xcref
	%if 1  ; IF2 - pass-specific
	    %ifndef name
	extern name
	    %endif
	%endif
; .cref
	JUMP    name
%endmacro
; .xcref  transfer

;
; get a short address in a word
;
%macro short_addr 1
    %ifnidn <name>,<?>
; .xcref
	%if 1  ; IF2 - pass-specific
	    %ifndef name
	extern name
	    %endif
	%endif
; .cref
	DW  name
    %else
	dw 0
    %endif
%endmacro
; .xcref  short_addr

;
; get a long address in a dword
;
%macro long_addr 1
; .xcref
	%if 1  ; IF2 - pass-specific
	    %ifndef name
	extern name
	    %endif
	%endif
; .cref
	DD  name
%endmacro
; .xcref  long_addr

;
; declare a PROC near or far but PUBLIC nonetheless
;
; .xcref ?frame
; .xcref ?aframe
; .xcref ?stackdepth
; .xcref ?initstack
?frame equ 0; initial
?aframe equ 0; initial
?stackdepth equ 0; initial stack size
?initstack equ 0; initial stack size

%macro procedure 2
	?frame equ 0
	?aframe equ 2;; remember the pushed BP
	global name
	%if 1  ; IF1 - pass-specific
	%warning name... pass 1
	%endif
	%if 1  ; IF2 - pass-specific
	%warning name... pass 2
	%endif
; name    PROC    distance
	?initstack equ ?stackdepth;; beginning of procedure
%endmacro
; .xcref  procedure

;
; end a procedure and check that stack depth is preserved
;
%macro EndProc 2
	%ifnidn <chk>,<NoCheck>;; check the stack size
	%if 1  ; IF2 - pass-specific
	%if ?initstack NE ?stackdepth;; is it different?
	%warning ***** Possible stack error_size in name *****
	%endif
	%endif
	%endif
; name    ENDP
%endmacro
; .xcref  endproc
; PAGE
;
; define a data item to be public and of an appropriate size/type
;

%macro I_AM 3
;; declare the object public
	global name
;; declare the type of the object
    %ifidn <size>,<WORD>
; name    LABEL WORD
	I_AM_SIZE equ 1
	I_AM_LEN equ 2
    %else
	%ifidn <size>,<DWORD>
; name    LABEL DWORD
	I_AM_SIZE equ 2
	I_AM_LEN equ 2
	%else
	    %ifidn <size>,<BYTE>
; name    LABEL BYTE
	I_AM_SIZE equ 1
	I_AM_LEN equ 1
	    %else
; name    LABEL BYTE
	I_AM_SIZE equ size
	I_AM_LEN equ 1
	    %endif
	%endif
    %endif
;; if no initialize then allocate blank storage
    %if 0  ; IFB <init>
	DB  I_AM_SIZE*I_AM_LEN DUP (?)
    %else
%if ~InstalledData
	; IRP itm,<init>
	    %if I_AM_LEN EQ 1
		DB  itm
	    %else
		DW  itm
	    %endif
	    I_AM_SIZE equ I_AM_SIZE - 1
	%endmacro
	%if I_AM_SIZE NE 0
	    %warning ***** initialization of name not complete *****
	%endif
%else
	DB  I_AM_SIZE*I_AM_LEN DUP (?)
%endif
    %endif
%endmacro
; .xcref  I_AM
; .xcref  I_AM_SIZE
; .xcref  I_AM_LEN
I_AM_SIZE equ 0
I_AM_LEN equ 0

; PAGE

;
; define an entry in a procedure
;
%macro entry 1
	global name
name:
%endmacro
; .xcref  entry

BREAK <ERROR - store an error code then jump to a label>

%macro error 1
; .xcref
	MOV AL,code
	transfer    SYS_RET_ERR
; .cref
%endmacro
; .xcref  error

BREAK <JUMP - real jump that links up shortwise>
;
; given a label <lbl> either 2 byte jump to another label <lbl>_J
; if it is near enough or 3 byte jump to <lbl>
;

%macro jump 1
    ; LOCAL a
; .xcref

    %ifndef lbl;; is this the first invocation
a:      JMP lbl
    %else
	%if (lbl&_J GE $) OR ($-lbl&_J GT 126)
a:      JMP lbl                         ;; is the jump too far away?
	%else
a:      JMP lbl&_J                      ;; do the short one...
	%endif
    %endif
    lbl&_j = a
; .cref
%endmacro
; .xcref  jump

BREAK <RETURN - return from a function>

%macro return 1
    ; LOCAL a
; .xcref
a:
	RET
ret_l equ a
; .cref
%endmacro
; .xcref  return

BREAK <CONDRET - conditional return>

%macro condret 2
    ; LOCAL a
; .xcref
; .xcref a
; .cref
    %ifdef ret_l;; if ret_l is defined
	%if (($ - ret_l) le 126) and ($ gt ret_l)
					;;     if ret_l is near enough then
	    a:  j&cc    ret_l           ;;         a: j<CC> to ret_l
	    ret_&cc = a                 ;;         define ret_<CC> to be a:
	    exitm
	%endif
    %endif
    %ifdef ret_;; if ret_<CC> defined
	%if (($ - ret_&cc) le 126) and ($ gt ret_&cc)
					;;     if ret_<CC> is near enough
	    a:  j&cc    ret_&cc         ;;         a: j<CC> to ret_<CC>
	    ret_&cc = a                 ;;         define ret_<CC> to be a:
	    exitm
	%endif
    %endif
    j&ncc   a                           ;; j<NCC> a:
    return                              ;; return
    a:                                  ;; a:
    ret_&cc = ret_l                     ;; define ret_<CC> to be ret_l
%endmacro
; .xcref  condret

BREAK <RETZ - return if zero, links up shortwise if necessary>

%macro retz 0
    condret z,nz
%endmacro
; .xcref  retz

BREAK <RETNZ - return if not zero, links up shortwise if necessary>

%macro retnz 0
    condret nz,z
%endmacro
; .xcref  retnz

BREAK <RETC - return if carry set, links up shortwise if necessary>

%macro retc 0
    condret c,nc
%endmacro
; .xcref  retc

BREAK <RETNC - return if not carry, links up shortwise if necessary>

%macro retnc 0
    condret nc,c
%endmacro
; .xcref  retnc

BREAK <CONTEXT - set the DOS context to a particular register>

%macro context 1
	PUSH    SS
	POP     r
	; ASSUME  r:DOSGROUP
%endmacro
; .xcref  context

BREAK <SaveReg - save a set of registers>

%macro SaveReg 1;; push those registers
; IRP reg,<reglist>
	?stackdepth equ ?stackdepth + 1
	PUSH    reg
%endmacro
%endmacro
; .xcref  SaveReg

BREAK <RestoreReg - unsave some registers>

%macro RestoreReg 1;; pop those registers
; IRP reg,<reglist>
	?stackdepth equ ?stackdepth - 1
	POP     reg
%endmacro
%endmacro
; .xcref  RestoreReg

BREAK <Critical section macros>

%macro EnterCrit 1
	Invoke  E&section
%endmacro

%macro LeaveCrit 1
	Invoke  L&section
%endmacro

Break   <message - display a message>

AsmVars <ShareF,Cargs,Redirector>

%if debug
%macro fmt 4
; LOCAL a,b,c
	PUSHF
%if 1  ; IFNB <typ>
	TEST    BugTyp,typ
	JZ      c
	CMP     BugLev,lev
	JB      c
%endif
	PUSH    AX
	PUSH    BP
	MOV     BP,SP
%if (not sharef) and (not redirector)
SECTION .Table
a       db      fmts,0
; END SECTION .Table
	MOV     AX,a
%else
	jmp     short b
a       db      fmts,0
%if sharef
b:      mov     ax,a
%else
b:      mov     ax,a
%endif
%endif
	PUSH    AX
cargs equ 2
; IRP item,<args>
%ifidn <AX>,<item>
	MOV     AX,[BP+2]
%else
	MOV     AX,item
%endif
	PUSH    AX
cargs equ cargs + 2
%endmacro
	invoke  PFMT
	ADD     SP,Cargs
	POP     BP
	POP     AX
c:
	POPF
%endmacro
%else
%macro fmt 0
%endmacro
%endif

Break   <DOSAssume - validate assumes>

AsmVar  Debug,$temp

%if debug
%macro DOSAssume 3
; LOCAL a,b
    %ifidn <reg>,<CS>
	$temp equ 1
    %else
	%ifidn <reg>,<SS>
	    $temp equ 0
	%else
	    %warning ***** Invalid DOS register reg in DOSAssume *****
	%endif
    %endif
    ; IRP r,<reglist>
	%ifidn <r>,<DS>
	    $temp equ $temp OR 2
	%else
	    %ifidn <r>,<ES>
		$temp equ $temp OR 4
	    %else
		%warning ***** Invalid register reg in DOSAssume *****
	    %endif
	%endif
    %endmacro
	PUSH    AX
	MOV     AX,$temp
	PUSH    AX
%if SHAREF
	MOV     AX,a
%else
	MOV     AX,a
%endif
	PUSH    AX
	Invoke  SegCheck
	POP     AX
%if ~SHAREF
SECTION .Table
a       DB      message,0
; END SECTION .Table
%else
	JMP     SHORT a
b       DB      message,0
a:
%endif
; IRP r,<reglist>
    ; ASSUME  r:DOSGroup
%endmacro
%endmacro
%else
%macro DOSAssume 3
; IRP r,<reglist>
    ; ASSUME  r:DOSGroup
%endmacro
%endmacro
%endif

BREAK   <ASSERT - make assertions about registers>

%if DEBUG
%macro Assert 3
	; LOCAL a,b
    %ifidn <kind>,<Z>
	CMP     objs,0
	JZ      a
	fmt <>,<>,<message>
a:
    %else
	%ifidn <kind>,<NZ>
	CMP     objs,0
	JNZ     a
	fmt <>,<>,<message>
a:
	%else
    PUSH    AX
	    ; IRP obj,<objs>
	PUSH    obj
	    %endmacro
	    %if SHAREF
    MOV     AX,b
	    %else
    MOV     AX,b
	    %endif
    PUSH    AX
	    %ifidn <kind>,<ISBUF>
	Invoke  BUFCheck
	    %endif
	    %ifidn <kind>,<ISSFT>
	Invoke  SFTCheck
	    %endif
	    %ifidn <kind>,<ISDPB>
	Invoke  DPBCheck
	    %endif
    POP     AX
	    %if SHAREF
    JMP SHORT a
b   DB  Message,0
a:
	    %else
SECTION .Table
b   db  Message,0
; END SECTION .Table
	    %endif
	%endif
    %endif
%endmacro
%else
%macro Assert 0
%endmacro
%endif

Break   <CallInstall - hook to installable pieces>

%macro CallInstall 5
%if Installed
    %if 1  ; IFNB <save>
	SaveReg <save>
    %endif
	MOV     AX,(mpx SHL 8) + fn
	INT     2Fh
    %if 1  ; IFNB <restore>
	RestoreReg  <restore>
    %endif
%else
	Invoke  name
%endif
%endmacro

Break   <Stack frame manipulators>

%macro localvar 2
; LOCAL a
	%ifidn <length>,<BYTE>
	    ?frame equ ?frame + 1
	    a equ ?frame
	    ; name EQU  BYTE PTR [BP-a]
	%else
	    %ifidn <length>,<WORD>
		?frame equ ?frame + 2
		a equ ?frame
		; name EQU  WORD PTR [BP-a]
	    %else
		%ifidn <length>,<DWORD>
		    ?frame equ ?frame + 4
		    a equ ?frame
		    ; name EQU  DWORD PTR [BP-a]
		    name&l EQU  word [BP-a]
		    name&h EQU  word [BP-a+2]
		%else
		    ?frame equ ?frame + length
		    a equ ?frame
		    ; name EQU  BYTE PTR [BP-a]
		%endif
	    %endif
	%endif
%endmacro

%macro enter 0
	push    bp
	mov     bp,sp
	sub     sp,?frame
%endmacro

%macro leave 0
	mov     sp,bp
	pop     bp
%endmacro

%macro Argvar 2
; LOCAL a
	%ifidn <length>,<BYTE>
	    a equ ?aframe
	    ?aframe equ ?aframe + 1
	    ; name EQU  BYTE PTR [BP+a]
	%else
	    %ifidn <length>,<WORD>
		a equ ?aframe
		?aframe equ ?aframe + 2
		; name EQU  WORD PTR [BP+a]
	    %else
		%ifidn <length>,<DWORD>
		    a equ ?aframe
		    ?aframe equ ?aframe + 4
		    ; name EQU  DWORD PTR [BP+a]
		    name&l EQU  word [BP+a]
		    name&h EQU  word [BP+a+2]
		%else
		    a equ ?aframe
		    ?aframe equ ?aframe + length
		    ; name EQU  BYTE PTR [BP+a]
		%endif
	    %endif
	%endif
%endmacro

BREAK   <errnz - generate compilation errors>

%macro errnz 1
%if x NE 0
    %warning ***** FATAL error: x <> 0
foobar
%endif
%endmacro
