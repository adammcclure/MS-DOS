%macro CallInstall 5
%macro BREAK 1
	; SUBTTL	subtitle
	; PAGE
%endmacro
; .xcref	break
%if Installed
    %if 1  ; IFNB <save>
	SaveReg <save>
    %endif
	MOV	AX,(mpx SHL 8) + fn
	INT	2Fh
    %if 1  ; IFNB <restore>
	RestoreReg  <restore>
    %endif
%else
	Invoke	name
%endif
%endmacro

BREAK <SaveReg - save a set of registers>

%macro SaveReg 1;; push those registers
; IRP reg,<reglist>
	?stackdepth = ?stackdepth + 1
	PUSH	reg
%endmacro
%endmacro
; .xcref	SaveReg

BREAK <RestoreReg - unsave some registers>

%macro RestoreReg 1;; pop those registers
; IRP reg,<reglist>
	?stackdepth = ?stackdepth - 1
	POP	reg
%endmacro
%endmacro
; .xcref	RestoreReg
