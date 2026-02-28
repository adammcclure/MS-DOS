;
; page 80,132
;
; title CP/DOS  DosChDir  mapper
;
SECTION .dosxxx
        ; assume  cs:dosxxx,ds:nothing,es:nothing,ss:nothing
;
; ************************************************************************* *
; *
; *      MODULE: DosChDir
; *
; *      FUNCTION: change directory name
; *
; *      FUNCTION: This module will change the current directory for the
; *                requesting process.
; *
; *
; *      CALLING SEQUENCE:
; *
; *                PUSH@ ASCIIZ Dirname ; Directory path name
; *                PUSH  DWORD  0       ; Reserved (must be zero)  took out @
; *                                     ; 5/28 to match 3/25 spec
; *                CALL DosChDir
; *
; *
; *      RETURN SEQUENCE:
; *
; *                IF ERROR (AX NOT = 0)
; *
; *                   AX = Error Code:
; *
; *                   o   Invalid directory path
; *
; *      MODULES CALLED:
; *                     DOS int 21h   function 3Bh ; Change current directory
; *
; *************************************************************************

        global DosChDir
        ; .sall
        ; .xlist
        %include "macros.inc"
        ; .list

struc str
old_bp: dw 0
return: dd 0
dtrm006 dd      0h           ;reserved  (must be zero)
dnam006: dd 0;address of directory path name
endstruc

DosChDir:
        Enter   DosChDir                 ; push registers

        mov     dx, word [bp].dnam006    ;load directory name offset
        mov     ax, word [bp].dnam006+2  ;load directory name segment

        push    ax                       ; set segment in DS
        pop     ds

        mov     ax,03b00h                ; load chdir op code
        int     21h                      ; call dos to change the directory
        jc      exit                     ; jump if error

        xor     ax,ax                    ; else, good return code
exit:   mexit                            ; pop registers
        ret     str_size - 6             ; return

; ENDP DosChDir

; END SECTION .dosxxx

        ; end
