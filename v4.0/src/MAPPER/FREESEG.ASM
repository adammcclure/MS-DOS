;
; page 60,132
;
; title CP/DOS  DosFreeSeg  mapper
;
SECTION .dosxxx
        ; assume  cs:dosxxx,ds:nothing,es:nothing,ss:nothing
;
; ************************************************************************* *
; *
; *      MODULE: DosFreeSeg
; *
; *      FILE NAME: dos023.asm
; *
; *      FUNCTION: This module deallocates a segment
; *
; *
; *      CALLING SEQUENCE:
; *
; *             push    selector        ; selector of the segment
; *             call    dosfreeseg
; *
; *      RETURN SEQUENCE:
; *
; *      MODULES CALLED:  DOS int 21h, ah=49h
; *
; *************************************************************************

        global dosfreeseg
        ; .sall
        ; .xlist
        %include "macros.inc"
        ; .list

invalid_selector equ 0006h


struc str
Old_bp: dw 0
Return: dd 0
Selector: dw 0; selector of the segment to be freed
endstruc

dosfreeseg:
        Enter   dosfreeseg              ; push registers

        mov     es,[bp].selector        ; get selector in es

        mov     ah,49h
        int     21h                     ; free memory segment
        jc      error                   ; jump if error

        sub     ax,ax                   ; zero return code
        jmp     exit                    ; go to exit

error:  mov     ax,invalid_selector     ; put in error code

exit:   Mexit                           ; pop registers
        ret     str_size - 6            ; return

; ENDP dosfreeseg

; END SECTION .dosxxx

        ; end
