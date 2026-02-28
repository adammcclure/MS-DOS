;
; page 60,132
;
; title CP/DOS DosSetCtryCode mapper
;
SECTION .dosxxx
        ; assume  cs:dosxxx,ds:dosxxx,es:dosxxx,ss:dosxxx
;
;**********************************************************************
;*
;*   MODULE:   dossetctrycode
;*
;*   FILE NAME: dos049.asm
;*
;*   CALLING SEQUENCE:
;*
;*       push@     dword   country code
;*       call      dossetctrycode
;*
;*   MODULES CALLED:  PC-DOS Int 21h, ah=38h, set country code
;*
;*********************************************************************

            global dossetctrycode
            ; .sall
            %include "macros.inc"

struc str
Old_bp: dw 0
Return: dd 0
Ccode: dd 0; country code
endstruc

dossetctrycode:
            Enter    dossetctrycode        ; push registers

            lds      si,[bp].ccode
            mov      ax,word [si]      ; get country code
            mov      cx,255
            cmp      ax,cx                 ; check for country code >= 255
            jl       okay                  ; branch if less

            mov      bx,ax                 ; if so, load into bx
            mov      al,cl                 ; and set flag
okay:       mov      dx,0ffffh             ; Set DX

            mov      ah,38h                ; DOS INT function code
            int      21h                   ; set country information
            jc       exit                  ; branch if error

            sub      ax,ax                 ; set good return
exit:       mexit                          ; pop registers
            ret      str_size - 6         ; return

; ENDP dossetctrycode
; END SECTION .dosxxx
            ; end
