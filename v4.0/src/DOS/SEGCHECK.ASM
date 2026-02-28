;	SCCSID = @(#)segcheck.asm	1.2 85/07/24
; TITLE   SegCheck - internal consistency check
; NAME    SegCheck

; .xlist
%include "DOSSYM.INC"
%include "DEVSYM.INC"

ShareF  = FALSE

%if NOT SHAREF
%include "dosseg.asm"
%endif
; .list

AsmVars <NET, DEBUG>

DEBUG   = FALSE

%if NOT SHAREF
SECTION .CODE
; ASSUME  CS:DOSGroup
%else
SECTION .SHARE
; ASSUME  CS:SHARE
%endif

DEBUG   = FALSE

BREAK   <SegCheck - validate segments in MSDOS>

%macro Off 2
%if SHAREF
	mov     reg,var
%else
	mov     reg,var
%endif
%endmacro

%macro zfmt 2
; LOCAL a,b
	PUSHF
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
cargs = 2
; IRP item,<args>
%ifidn <AX>,<item>
	MOV     AX,[BP+2]
%else
	MOV     AX,item
%endif
	PUSH    AX
cargs = cargs + 2
%endmacro
	invoke  PFMT
	ADD     SP,Cargs
	POP     BP
	POP     AX
	POPF
%endmacro

struc segFrame
segbp: dw 0
segip: dw 0
segmes: dw 0
segtemp: dw 0
endstruc
;
;   SegCheck - assure that segments are correctly set up
;
;   Inputs:     top of stack points to:
;               2-byte jump
;               byte flags 04h is ES 02h is DS 01 is CS/SS
;               offset asciz message
;
;   Outputs:    message to screen (via INT 29h)
;   Nothing modified (flags too)

Procedure   SegCheck,NEAR
	; ASSUME  DS:NOTHING,ES:NOTHING,SS:NOTHING
	SaveReg <BP>
	MOV     BP,SP                   ; set up addressing
	PUSHF
	SaveReg <AX,BX,CX,DX>
	MOV     AL,byte [BP].segtemp; get flags
	MOV     CX,SS
	TEST    AL,1                    ; shall we use CS or SS?
	JZ      SegUseSS                ; use SS
	MOV     CX,CS                   ; use CS instead
SegUseSS:
	TEST    AL,2                    ; do we check DS?
	JZ      SegTestES               ; no, go check ES
	MOV     DX,DS
	CMP     CX,DX
	JZ      SegTestES               ; DS is valid, go check ES
	MOV     AX,[BP].segmes
	zfmt    <"Assumed DS invalid $s\n">,<AX>
SegTestES:
	TEST    AL,4                    ; do we check ES?
	JZ      SegTestDone             ; no, all done
	MOV     DX,ES
	CMP     CX,DX
	JZ      SegTestDone             ; ES is valid, all done
	MOV     AX,[BP].segmes
	zfmt    <"Assumed ES invalid $s\n">,<AX>
SegTestDone:
	RestoreReg  <DX,CX,BX,AX>
	POPF
	RestoreReg  <BP>
	ret     4                       ; release message, temp
EndProc SegCheck


%if NOT SHAREF
I_need  DPBHead,DWORD
I_need  BuffHead,DWORD
I_need  sftFCB,DWORD
I_need  AuxStack,BYTE
I_need  IOStack,BYTE
I_need  renbuf,byte
I_need  CurrentPDB,WORD
I_need  User_In_AX,WORD

extern ECritDisk

CritNOP:
	RET

struc AstFrame
Astbp: dw 0
Astip: dw 0
Astmes: dw 0
Astarg: dd 0
endstruc

global SGCHK001S,SGCHK001E
SGCHK001S:
DPBMes  DB  "DPB assertion failed: ",0
BUFMes  DB  "BUF assertion failed: ",0
SFTMes  DB  "SFT assertion failed: ",0
BlankSp DB  " ",0
Colon   DB  ":",0

Msg: dw 0

SGCHK001E:

SECTION .Table
    extern SectPDB, SectRef
; END SECTION .Table

;   DPBCheck - validate a supposed DPB pointer
;   Inputs:     Pushed arguments
;   Outputs:    Message to screen
;   Registers modified: none

Procedure   DPBCheck,NEAR
	MOV     Msg,DPBMes
	SaveReg <BP>
	MOV     BP,SP
	PUSHF
	SaveReg <AX,BX,DS,SI,ES,DI>
	LES     DI,DPBHead
	LDS     SI,[BP].Astarg
DPBLoop:CMP     DI,-1
	JZ      DPBNotFound
	invoke  PointComp
	JZ      DPBRet
	LES     DI,ES:[DI.dpb_next_dpb]
	JMP     DPBLoop
DPBNotFound:
	MOV     AX,[BP].Astmes
	zfmt    <"$s$x:$x $s\n">,<msg,ds,si,AX>
	CLI
a:      JMP     a                       ; slam the door.
DPBRet: RestoreReg  <DI,ES,SI,DS,BX,AX> ;   Done:
	POPF
	RestoreReg  <BP>
	RET     6
EndProc DPBCheck

;   SFTCheck - validate a supposed SFT pointer
;   Inputs:     Pushed arguments
;   Outputs:    Message to screen
;   Registers modified: none

Procedure   SFTCheck,NEAR
	MOV     Msg,SFTMes
	SaveReg <BP>
	MOV     BP,SP
	PUSHF
	SaveReg <AX,BX,DS,SI,ES,DI>
	LDS     SI,[BP].Astarg
	XOR     BX,BX                   ;   i = 0;
SFTLoop:
	SaveReg <BX>
	invoke  SFFromSFN               ;   while ((d=SF(i)) != NULL)
	RestoreReg  <BX>
	JC      Sft1
	invoke  PointComp
	JZ      DPBRet                  ;               goto Done;
SFTNext:INC     BX                      ;           else
	JMP     SFTLoop                 ;               i++;
SFT1:   LES     DI,sftFCB
	MOV     BX,ES:[DI.sfCount]
	LEA     DI,[DI.sfTable]
SFT2:
	invoke  PointComp
DPBRETJ:JZ      DPBRet
	ADD     DI,sf_entry_size
	DEC     BX
	JNZ     SFT2
;
; The SFT is not in the allocated tables.  See if it is one of the static
; areas.
;
	Context ES
	MOV     DI,AUXSTACK - SF_ENTRY_size
	Invoke  PointComp
	JZ      DPBRet
	MOV     DI,RenBuf
	Invoke  PointComp
	JZ      DPBRetj
DPBNotFoundJ:
	JMP     DPBNotFound
EndProc SFTCheck

;   BUFCheck - validate a supposed BUF pointer
;   Inputs:     Pushed arguments
;   Outputs:    Message to screen
;   Registers modified: none

Procedure   BUFCheck,NEAR
	MOV     Msg,BUFMes
	SaveReg <BP>
	MOV     BP,SP
	PUSHF
	SaveReg <AX,BX,DS,SI,ES,DI>
;
; CheckDisk - make sure that we are in the disk critical section...
;
	MOV     AL,byte ECritDisk
	CMP     AL,CritNOP
	JZ      CheckDone
	MOV     AX,CurrentPDB
	CMP     SectPDB + 2 * critDisk,AX
	MOV     AX,[BP].astmes
	JZ      CheckRef
	zfmt    <"$p: $x $s critDisk owned by $x\n">,<User_In_AX,AX,SectPDB+2*critDisk>
CheckRef:
	CMP     SectRef + 2 * critDisk,0
	JNZ     CheckDone
	zfmt    <"$p: $x $s critDisk ref count is 0\n">,<User_In_AX,AX>
CheckDone:

	LDS     SI,[BP].Astarg
	LES     DI,BUFFHead
BUFLoop:CMP     DI,-1
	JZ      DPBNotFoundJ
	invoke  PointComp
	JNZ     BufNext
	JMP     DPBRet
BufNext:
	LES     DI,ES:[DI.buf_link]
	JMP     BUFLoop
EndProc BUFCheck

; END SECTION .CODE
%else
; END SECTION .SHARE
%endif
; END
