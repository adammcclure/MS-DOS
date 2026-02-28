; comment $
cmacros - assembly macros for interfacing to HHLs
(C)Copyright 1984, 1988 Microsoft Corporation
$
%if 1  ; IF1 - pass-specific
%macro outif 4
    %ifndef name
	%if 0  ; IFB <defval>
	    name=0
	%else
	    name=defval
	%endif
    %endif
    %if name
	name=1
	%if 1  ; IFNB <onmsg>
	    %warning ! onmsg
	%endif
    %else
	%if 1  ; IFNB <offmsg>
	    %warning ! offmsg
	%endif
    %endif
%endmacro

%macro error 1
bug
%warning E r r o r ----- msg
%endmacro
%warning cMacros Version 1.04
outif memS,0,<Small Model>
outif memM,0,<Medium Model>
outif memL,0,<Large Model>
outif memC,0,<Compact Model>
outif memH,0,<Huge Model>
memMOD= memS + memM + memL + memC + memH
%if memMOD ne 1
%if memMOD eq 0
memS= 1
outif memS,0,<Small Model>
%else
error <Must have only 1 memory model selected>
%endif
%endif
sizeC= memM + memL + memH
sizeD= memL + memC + (memH*2)
outif ?DF,0,<No segments or groups will be defined>
outif ?WIN,0,<Windows Support>
outif ?PLM,0,<PLM calling convention>
%endif
 ; .XCREF
 ; .XCREF ?N,?AX,?AH,?AL,?BX,?BH
 ; .XCREF ?BL,?CX,?CH,?CL,?DX,?DH
 ; .XCREF ?DL,?SI,?DI,?ES,?DS,?BP
 ; .XCREF ?SP,?SS,?CS
 ; .XCREF ?RSL,?CPD,?argl,?argc,?BA
 ; .XCREF ?ACB,???,?PO
 ; .XCREF ?PAS,?PC
 ; .XCREF Uconcat,mPush,mPop
 ; .XCREF ?RI,?pp,?pp1,?al1
 ; .XCREF ?aD,?AP,?Atal,?pd,?dd,?dd1,?ex1,?cas
 ; .XCREF ?pg,?pg1,?aloc,?cs1,?cs2
 ; .XCREF ?lb1,?lblpu
 ; .XCREF ?DF,?PLM,?WIN,?IA,?PU,?ADJ
 ; .CREF
?RSL = 0
?CPD = 0
?ArgL = 0
?ArgC = 0
?BA = 0
?ACB = 0
??? = 0
?PO = 0
?PAS = 0
?PC = 0
?IA = 0
?PU = 0
?ADJ = 0
?lblpu = 0
?N = 0000000000000000B
?AX = 0000000000000011B
?AH = 0000000000000001B
?AL = 0000000000000010B
?BX = 0000000000001100B
?BH = 0000000000000100B
?BL = 0000000000001000B
?CX = 0000000000110000B
?CH = 0000000000010000B
?CL = 0000000000100000B
?DX = 0000000011000000B
?DH = 0000000001000000B
?DL = 0000000010000000B
?SI = 0000000100000000B
?DI = 0000001000000000B
?ES = 0000010000000000B
?DS = 0000100000000000B
?BP = 0001000000000000B
?SP = 0010000000000000B
?SS = 0100000000000000B
?CS = 1000000000000000B
%macro uconcat 6
n1&n2 o1&o2 p1&p2
%endmacro
%macro mpush 1
; irp x,<ax,bx,cx,dx,si,di,es,ds,bp,sp,ss,cs>
%if rV AND ?&&x
push x
%endif
%endmacro
%endmacro
%macro mpop 1
; irp x,<cs,ss,sp,bp,ds,es,di,si,dx,cx,bx,ax>
%if rV AND ?&&x
pop x
%endif
%endmacro
%endmacro
%macro SAVE 1
?RSL = 0
?RI ?RSL,<rL>
%endmacro
%macro smashes 2
 ; .xcref
 ; .xcref ?SM&n
 ; .cref
?SM&n = 0
?RI ?SM&n,<rL>
%endmacro
%macro ?RI 2
; irp x,<rL>
ifdef ?&&x
n = n or ?&&x
%endif
%endmacro
%endmacro
%macro parmB 1
?pp <&nL>,<byte>,2,1
%endmacro
%macro parmW 1
?pp <&nL>,<word>,2,2
%endmacro
%macro parmD 1
%if (?PLM) == 0
; irp x,<nL>
?pp <&&x>,<DWORD>,0,4
?pp <Off_&&x>,<WORD>,2,2
?pp <Seg_&&x>,<WORD>,2,2
%endmacro
%else
; irp x,<nL>
?pp <Seg_&&x>,<WORD>,2,2
?pp <Off_&&x>,<WORD>,2,2
?pp <&&x>,<DWORD>,0,4
%endmacro
%endif
%endmacro
%macro parmQ 1
?pp <&nL>,<QWORD>,8,8
%endmacro
%macro parmT 1
?pp <&nL>,<TBYTE>,10,10
%endmacro
%if sizeC
%macro parmCP 1
parmD <nl>
%endmacro
%else
%macro parmCP 1
parmW <nl>
%endmacro
%endif
%if sizeD
%macro parmDP 1
parmD <nl>
%endmacro
%else
%macro parmDP 1
parmW <nl>
%endmacro
%endif
%macro ?pp 4
%if ?CPD
 ; .xcref
%if (?PLM) == 0
; irp x,<nL>
?pp1 x,<t>,%?PO,%?adj,%(?PO+?adj)
?PO = ?PO + l
 ; .xcref ?T&&x
?T&&x = s
%endmacro
%else
; irp x,<nL>
?PO = ?PO + l
?pp1 x,<t>,%?PO,%?adj,%(?PO+?adj)
 ; .xcref ?T&&x
?T&&x = s
%endmacro
%endif
 ; .cref
%else
%warning Parm(s) "&nl" declared outside proc def.
%endif
%endmacro
%macro ?pp1 5
%if (?PLM) == 0
n equ t ptr [bp+b]
%else
n equ t ptr [bp+a+?PO-o]
%endif
%endmacro
%macro localB 1
?aLoc <&nL>,<byte>,1,1,0
%endmacro
%macro localW 1
?aLoc <&nL>,<word>,2,2,1
%endmacro
%macro localD 1
; irp x,<nL>
?aLoc <Seg_&&x>,<word>,2,2,1
?aLoc <Off_&&x>,<word>,2,2,1
?aLoc <&&x>,<dword>,0,4,1
%endmacro
%endmacro
%macro localQ 1
?aLoc <&nL>,<qword>,8,8,1
%endmacro
%macro localT 1
?aLoc <&nL>,<tword>,10,10,1
%endmacro
%if sizeC
%macro localCP 1
localD <nL>
%endmacro
%else
%macro localCP 1
localW <nL>
%endmacro
%endif
%if sizeD
%macro localDP 1
localD <nL>
%endmacro
%else
%macro localDP 1
localW <nL>
%endmacro
%endif
%macro localV 2
?aLoc <&n>,,%(&a),0,1
%endmacro
%macro ?aLoc 5
%if ?CPD
 ; .xcref
??? = ??? + l
%if a
??? = ((??? + 1) AND 0FFFEH)
%endif
; irp x,<nL>
?aL1 x,<t>,%???
 ; .xcref ?T&&x
?T&&x = s
%endmacro
 ; .cref
%else
%warning Locals "&nl" declared outside procedure def.
%endif
%endmacro
%macro ?aL1 3
%if ?IA
n equ t [bp-?IA-o]
%else
n equ t [bp-o]
%endif
%endmacro
%macro globalB 3
?aD <n>,1
?dd n,1,<BYTE>,<DB>,<i>,<s>
%endmacro
%macro globalW 3
?aD <n>,2
?dd n,1,<WORD>,<DW>,<i>,<s>
%endmacro
%macro globalD 3
?aD <n>,4
?dd n,1,<DWORD>,<DD>,<i>,<s>
%endmacro
%macro globalQ 3
?aD <n>,8
?dd n,1,<QWORD>,<DQ>,<i>,<s>
%endmacro
%macro globalT 3
?aD <n>,10
?dd n,1,<TBYTE>,<DT>,<i>,<s>
%endmacro
%if sizeC
%macro globalCP 3
globalD n,<i>,<s>
%endmacro
%else
%macro globalCP 3
globalW n,<i>,<s>
%endmacro
%endif
%if sizeD
%macro globalDP 3
globalD n,<i>,<s>
%endmacro
%else
%macro globalDP 3
globalW n,<i>,<s>
%endmacro
%endif
%macro staticB 3
?aD <n>,1
?dd n,0,<BYTE>,<DB>,<i>,<s>
%endmacro
%macro staticW 3
?aD <n>,2
?dd n,0,<WORD>,<DW>,<i>,<s>
%endmacro
%macro staticD 3
?aD <n>,4
?dd n,0,<DWORD>,<DD>,<i>,<s>
%endmacro
%macro staticQ 3
?aD <n>,8
?dd n,0,<QWORD>,<DQ>,<i>,<s>
%endmacro
%macro staticT 3
?aD <n>,10
?dd n,0,<TBYTE>,<DT>,<i>,<s>
%endmacro
%if sizeC
%macro staticCP 3
staticD n,<i>,<s>
%endmacro
%else
%macro staticCP 3
staticW n,<i>,<s>
%endmacro
%endif
%if sizeD
%macro staticDP 3
staticD n,<i>,<s>
%endmacro
%else
%macro staticDP 3
staticW n,<i>,<s>
%endmacro
%endif
%macro ?dd 6
%if (?PLM) == 0
n:
?dd1 _&n,p,<d>,<i>,<s>
%else
?dd1 n,p,<d>,<i>,<s>
%endif
%endmacro
%macro ?dd1 5
%if p
global n
%endif
%if 0  ; IFB <s>
n d i
%else
%if 0  ; IFB <i>
n d s DUP (?)
%else
n d s DUP (i)
%endif
%endif
%endmacro
%macro externB 1
?ex1 <&nL>,1,<BYTE>
%endmacro
%macro externW 1
?ex1 <&nL>,2,<WORD>
%endmacro
%macro externD 1
?ex1 <&nL>,4,<DWORD>
%endmacro
%macro externQ 1
?ex1 <&nL>,8,<QWORD>
%endmacro
%macro externT 1
?ex1 <&nL>,10,<TBYTE>
%endmacro
%macro externNP 1
?ex1 <&nL>,2,<NEAR>
%endmacro
%macro externFP 1
?ex1 <&nL>,4,<FAR>
%endmacro
%if sizeC
%macro externP 1
?ex1 <&nL>,4,<FAR>
%endmacro
%else
%macro externP 1
?ex1 <&nL>,2,<NEAR>
%endmacro
%endif
%if sizeC
%macro externCP 1
?ex1 <&nL>,4,<DWORD>
%endmacro
%else
%macro externCP 1
?ex1 <&nL>,2,<WORD>
%endmacro
%endif
%if sizeD
%macro externDP 1
?ex1 <&nL>,4,<DWORD>
%endmacro
%else
%macro externDP 1
?ex1 <&nL>,2,<WORD>
%endmacro
%endif
%macro ?ex1 3
; irp x,<nL>
 ; .xcref
 ; .xcref ?T&&x
 ; .cref
?T&&x = s
%if (?PLM) == 0
extern _&&x:&d
x equ _&&x
%else
extern x:&d
%endif
%endmacro
%endmacro
%macro labelB 1
?lb1 <&nL>,1,<BYTE>
%endmacro
%macro labelW 1
?lb1 <&nL>,2,<WORD>
%endmacro
%macro labelD 1
?lb1 <&nL>,4,<DWORD>
%endmacro
%macro labelQ 1
?lb1 <&nL>,8,<QWORD>
%endmacro
%macro labelT 1
?lb1 <&nL>,10,<TBYTE>
%endmacro
%macro labelNP 1
?lb1 <&nL>,2,<NEAR>
%endmacro
%macro labelFP 1
?lb1 <&nL>,4,<FAR>
%endmacro
%if sizeC
%macro labelP 1
?lb1 <&nL>,4,<FAR>
%endmacro
%else
%macro labelP 1
?lb1 <&nL>,2,<NEAR>
%endmacro
%endif
%if sizeC
%macro labelCP 1
?lb1 <&nL>,4,<DWORD>
%endmacro
%else
%macro labelCP 1
?lb1 <&nL>,2,<WORD>
%endmacro
%endif
%if sizeD
%macro labelDP 1
?lb1 <&nL>,4,<DWORD>
%endmacro
%else
%macro labelDP 1
?lb1 <&nL>,2,<WORD>
%endmacro
%endif
%macro ?lb1 3
?lblpu = 0
; irp x,<nL>
%ifidn <x>,<PUBLIC>
?lblpu = 1
%else
 ; .xcref
 ; .xcref ?T&&x
 ; .cref
?T&&x = s
%if (?PLM) == 0
%if ?lblpu
global _&&x
%endif
_&&x label &d
x equ _&&x
%else
%if ?lblpu
global x
%endif
x label &d
%endif
%endif
%endmacro
%endmacro
%macro defB 1
?aD <&nL>,1
%endmacro
%macro defW 1
?aD <&nL>,2
%endmacro
%macro defD 1
?aD <&nL>,4
%endmacro
%macro defQ 1
?aD <&nL>,8
%endmacro
%macro defT 1
?aD <&nL>,10
%endmacro
%if sizeC
%macro defCP 1
defD <nL>
%endmacro
%else
%macro defCP 1
defW <nL>
%endmacro
%endif
%if sizeD
%macro defDP 1
defD <nL>
%endmacro
%else
%macro defDP 1
defW <nL>
%endmacro
%endif
%macro ?aD 2
; irp x,<nL>
 ; .xcref
 ; .xcref ?T&&x
 ; .cref
?T&&x = s
%endmacro
%endmacro
%macro regPtr 3
 ; .xcref
 ; .xcref ?T&n,?SR&n,?OR&n
 ; .cref
?T&n = 0FFFFH
?SR&n = 0
?RI ?SR&n,<&S>
?OR&n = 0
?RI ?OR&n,<&O>
%endmacro
%macro arg 1
; irp x,<aL>
?argc = ?argc + 1
?Atal <x>,%?argc
%endmacro
%endmacro
%macro ?Atal 2
 ; .xcref
 ; .xcref ?ALI&i
 ; .cref
?ALI&i &macro
?AP n
&endm
%endmacro
%macro ?AP 1
?argl = ?argl + 2
ifdef ?T&n
%if (?T&n-1) == 0
push word (n)
exitm
%endif
%if (?T&n-2) == 0
push n
exitm
%endif
%if (?T&n-4) == 0
push word (n)+2
push word (n)
?argl = ?argl + 2
exitm
%endif
%if (?T&n-8) == 0
push word (n)+6
push word (n)+4
push word (n)+2
push word (n)
?argl = ?argl + 6
exitm
%endif
%if (?T&n-0FFFFH) == 0
mpush %(?SR&n),1
mpush %(?OR&n),1
?argl = ?argl + 2
exitm
%endif
%if (?T&n) == 0
push word (n)
exitm
%endif
%endif
push n
%endmacro
%if (?PLM) == 0
%macro ccall 3
%if 1  ; IFNB <a>
Arg <a>
%endif
ifdef ?SM&n
?RSL = ?RSL AND ?SM&n
%endif
mpush %?RSL
?argl = 0
?ACB = ?argc
%rep ?argc
uconcat <?ALI>,%?ACB
uconcat <purge>,,<?ALI>,%?ACB
?ACB = ?ACB - 1
%endmacro
%if (?PLM) == 0
%if 0  ; IFB <sleaze>
call _&n
%else
call n
%endif
%else
call n
%endif
%if ?argl
add sp,?argl
%endif
mpop %?RSL
?RSL = 0
?argc = 0
?argl = 0
%endmacro
%else
%macro ccall 2
%if 1  ; IFNB <a>
Arg <a>
%endif
ifdef ?SM&n
?RSL = ?RSL AND ?SM&n
%endif
mpush %?RSL
?argl = 0
?ACB = 1
%rep ?argc
uconcat <?ALI>,%?ACB
uconcat <purge>,,<?ALI>,%?ACB
?ACB = ?ACB + 1
%endmacro
%if (?PLM) == 0
call _&n
%else
call n
%endif
mpop %?RSL
?RSL = 0
?argc = 0
?argl = 0
%endmacro
%endif
%macro cProc 3
?pd n,<cl>,<s>,4
%endmacro
%macro ?pd 4
%if ?CPD
?UTPE
%endif
?CPD = 1
??? = 0
?argc = 0
?BA = 0
?PO = 0
?PU = 0
?IA = 0
?adj = i
?PAS = 0
%if 1  ; IFNB <a>
?RI ?PAS,<a>
%endif
?PC = sizeC
; irp x,<c>
%ifidn <x>,<FAR>
?PC = 1
%endif
%ifidn <x>,<NEAR>
?PC = 0
%endif
%ifidn <x>,<PUBLIC>
?PU = 1
%endif
%endmacro
%if ?PC
%if ?WIN
?IA = 2
%endif
?adj = ?adj + 2
%endif
%if (?PLM) == 0
%if (?PC) == 0
n:
%else
n:
%endif
?pg <_&n>,%?PU,%?PC,%?PAS
%else
?pg <n>,%?PU,%?PC,%?PAS
%endif
%endmacro
%macro ?pg 4
    ; .xcref
    cBegin &macro g
	; .xcref
	?pg1 <n>,c,a,%?PO
	?CPD = 0
	?argc = 0
	?BA = 1
	??? = (???+1) AND 0FFFEH
	%if p
	    global n
	%endif
	%if (c) == 0
	    n:
	%else
	    n:
	%endif
	%ifidn <g>,<nogen>
	    %if ???+?PO+a
		%warning <cBegin - possible invalid use of nogen>
	    %endif
	%else
	    %if ?IA
		mov ax,ds
		nop
		inc bp
		push bp
		mov bp,sp
		push ds
		mov ds,ax
	    %else
		push bp
		mov bp,sp
	    %endif
	    %if ???
		sub sp,???
	    %endif
	    mPush a,1
	%endif
	; .cref
	; purge cBegin
    &endm
    ?UTPE &macro
	%warning Unterminated Procedure Definition: "&n"
    &endm
%endmacro

%macro ?pg1 4
    ; .xcref
    cEnd &macro g
	; .xcref
	?BA = 0
	%ifidn <g>,<nogen>
	    %if o+a
		%warning <cEnd - possible invalid use of nogen>
	    %endif
	%else
	    mPop a,1
	    %if ?IA
		sub bp,2
		mov sp,bp
		pop ds
		pop bp
		dec bp
	    %else
		mov sp,bp
		pop bp
	    %endif
	    %if (?PLM) == 0
		ret
	    %else
		ret o
	    %endif
	%endif
	; ENDP n
	; .cref
	; purge cEnd
    &endm
    ; .cref
%endmacro

%macro assumes 2
; LOCAL assumed
assumed = 0
%ifidn <code>,<g>
?cas <s>
assumed = 1
%endif
%ifidn <CODE>,<g>
?cas <s>
assumed = 1
%endif
%ifidn <data>,<g>
; assume s&:dgroup
assumed = 1
%endif
%ifidn <DATA>,<g>
; assume s&:dgroup
assumed = 1
%endif
%if (assumed) == 0
; assume s&:&g
%endif
%endmacro
%if sizeC
%macro ?cas 1
; assume s&:_TEXT
%endmacro
%else
%macro ?cas 1
; assume s&:IGROUP
%endmacro
%endif
%macro createSeg 6
%if 1  ; IFNB <grp>
%ifidn <grp>,<IGROUP>
%if (sizeC) == 0
addSeg IGROUP,n
%endif
%else
addSeg grp,n
%endif
%endif
%if 1  ; IFNB <cl>
SECTION .n
%else
SECTION .n
%endif
; END SECTION .n
?cs1 <n>,<ln>
%endmacro
%if 1  ; IF1 - pass-specific
ASMpass=1
%else
ASMpass=2
%endif
%macro addSeg 2
%ifndef def_
def_&grp= 0
%endif
%if def_&grp ne ASMpass
add_&grp &macro s
in_&grp <seg>,s
&endm
in_&grp &macro sl,s
%if 0  ; IFB <s>
; grp group sl
%else
add_&grp &macro ns
in_&grp <sl,s>,ns
&endm
%endif
&endm
def_&grp=ASMpass
%else
add_&grp seg
%endif
%endmacro
%macro defGrp 1
addSeg nam
%endmacro
%macro ?cs1 2
begin&ln &macro
?cs2 <n>
SECTION .n
&endm
%endmacro

%macro ?cs2 1
    sEnd &macro
	; END SECTION .n
    &endm
%endmacro

%macro sBegin 1
    begin&ln
%endmacro

%if (?DF) == 0
    createSeg _TEXT,code,byte,public,CODE,IGROUP
    createSeg _DATA,data,word,public,DATA,DGROUP
    %if ?WIN
	%if (sizeC) == 0
	    createSeg _INITTEXT,initcode,byte,public,CODE,IGROUP
	    createSeg _INITDATA,initdata,word,public,DATA,DGROUP
	%endif
    %endif
    %if (sizeC) == 0
	defGrp IGROUP
    %endif
    defGrp DGROUP
    %if sizeC
	codeOFFSET equ 
    %else
	codeOFFSET equ 
    %endif
    dataOFFSET equ 
%endif

%macro errnz 1
    %if 1  ; IF2 - pass-specific
	%if x
	    errnz1 <x>,%(x)
	%endif
    %endif
%endmacro

%macro errnz1 2
    = *ERRNZ* x1 = x2
%endmacro

%macro errn$ 2
    errnz <$ - l x>
%endmacro
