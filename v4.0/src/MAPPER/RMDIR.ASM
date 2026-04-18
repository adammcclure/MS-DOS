; page 80,132

; title CP/DOS DosRmDir mapper

SECTION .dosxxx
        ; assume  cs:dosxxx,ds:nothing,es:nothing,ss:nothing

;**********************************************************************
;*
;*   MODULE:   dosrmdir
;*
;*   FUNCTION:  remove directory
;*
;*   CALLING SEQUENCE:
;*
;*       push@     asciiz  directory name
;*       push      dword   reserved (must be zero)
;*       call      dosrmdir
;*
;*   MODULES CALLED:  PC-DOS Int 21h, ah=3ah, remove subdirectory
;*
;*********************************************************************

            global dosrmdir
            ; .sall
            %include "macros.inc"

struc str
old_bp: resw 1
return: resd 1
rsrvd: resd 1; reserved
asciiz: resd 1; directory name pointer
endstruc

dosrmdir:

            Enter    dosrmdir            ; push registers

            lds      dx,[bp].asciiz      ; set pointer to directory name

            mov      ah,3ah              ; load opcode
            int      21h                 ; remove directory
            jc       exit                ; check for error

            sub      ax,ax               ; set good return code
exit:       Mexit                        ; pop registers
            ret      str_size - 6        ; return

; ENDP dosrmdir

; END SECTION .dosxxx

            ; end
