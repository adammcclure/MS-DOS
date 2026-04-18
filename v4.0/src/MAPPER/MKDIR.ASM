; page 80,132

; title CP/DOS DosMkDir mapper

SECTION .dosxxx
        ; assume  cs:dosxxx,ds:nothing,es:nothing,ss:nothing
;
;**********************************************************************
;*
;*   MODULE:   dosmkdir
;*
;*   FUNCTION:  Create  a new directory
;*
;*   CALLING SEQUENCE:
;*
;*       push@     asciiz  directory name
;*       push      dword   reserved (must be zero)
;*       call      dosmkdir
;*
;*   MODULES CALLED:  PC-DOS Int 21h, ah=39h
;*
;*********************************************************************

            global dosmkdir
            ; .sall
            %include "macros.inc"

struc str
old_bp: resw 1
return: resd 1
rsrvd: resd 1
Asciiz: resd 1; new directory name pointer
endstruc

dosmkdir:

            Enter    DosMkdir            ; push registers
            lds      dx,[bp].asciiz      ; set pointer to directory name

            mov      ah,39h              ; load opcode
            int      21h                 ; create new directory
            jc       exit                ; jump if error

            sub      ax,ax               ; else, set good return code

exit:       mexit                        ; pop registers
            ret      str_size - 6        ; return

; ENDP dosmkdir

; END SECTION .dosxxx

            ; end
