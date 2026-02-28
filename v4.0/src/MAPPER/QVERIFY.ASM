;
; page 80,132
;
; title CP/DOS DosQVerify mapper
;
SECTION .dosxxx
        ; assume  cs:dosxxx,ds:nothing,es:nothing,ss:nothing
;
;**********************************************************************
;*
;*   MODULE:   dosqverify       Returns the value of the verify flag
;*
;*   FILE NAME: dos041.asm
;*
;*   CALLING SEQUENCE:
;*
;*       push@     word     verify setting
;*       call      dosqverify
;*
;*   MODULES CALLED:  PC-DOS Int 21h, ah=54h, get verify setting
;*
;*********************************************************************

            global dosqverify
            ; .sall
            ; .xlist
            %include "macros.inc"
            ; .list

struc str
old_bp: dw 0
return: dd 0
verify: dd 0; return data area pointer
endstruc

dosqverify:
            Enter   dosqverify             ; save registers

            mov      ah,54h
            int      21h                   ; get verify flag setting

            lds      si,[bp].verify        ; setup return data area
            cbw                            ; fill word
            mov      word [si],ax      ; save verify flag setting
            sub      ax,ax                 ; set good return code

exit:       Mexit                          ; pop registers
            ret      str_size - 6          ; return

; ENDP dosqverify

; END SECTION .dosxxx

            ; end
