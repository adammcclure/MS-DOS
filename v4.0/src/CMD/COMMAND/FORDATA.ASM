;	SCCSID = @(#)fordata.asm	1.1 85/05/14
;	SCCSID = @(#)fordata.asm	1.1 85/05/14
; Data structure definitions included by tfor.asm

struc for_info
    for_args        DB          (arg_unit_size) DUP (?) ; argv[] structure
    FOR_COM_START   DB          (?)                     ; beginning of <command>
    FOR_EXPAND      DW          (?)                     ; * or ? item in <list>?
    FOR_MINARG      DW          (?)                     ; beginning of <list>
    FOR_MAXARG      DW          (?)                     ; end of <list>
    forbuf: times 64 dw 0; temporary buffer
    fordma: times 64 dw 0; FindFirst/Next buffer
    FOR_VAR         DB          (?)                     ; loop control variable
endstruc

; empty segment done for bogus addressing
SECTION .for_segment
f:
; END SECTION .for_segment
