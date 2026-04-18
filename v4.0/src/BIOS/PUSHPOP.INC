	%if 1  ; IF1 - pass-specific;3.30

%macro SaveReg 1;; push those registers
; IRP reg,<reglist>
	?stackdepth equ ?stackdepth + 1
	PUSH	reg
%endmacro
%endmacro
; .xcref	SaveReg


%macro RestoreReg 1;; pop those registers
; IRP reg,<reglist>
	?stackdepth equ ?stackdepth - 1
	POP	reg
%endmacro
%endmacro
; .xcref	RestoreReg

	%endif;3.30
