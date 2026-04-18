;
; page 80,132
;
; title CP/DOS DosSelectDisk mapper
;
SECTION .dosxxx
        ; assume  cs:dosxxx,ds:nothing,es:nothing,ss:nothing
;
;**********************************************************************
;*
;*   MODULE:   dosselectdisk
;*
;*   FILE NAME: dos048.asm
;*
;*   CALLING SEQUENCE:
;*
;*       push      word  drive          drive number
;*       call      dosselectdisk
;*
;*   MODULES CALLED:  PC-DOS Int 21h, ah=0eh, select disk
;*
;*********************************************************************

            global dosselectdisk
            ; .sall
            ; .xlist
            %include "macros.inc"
            ; .list

struc str
old_bp: resw 1
Return: resd 1
Drive: resw 1; drive number
endstruc

dosselectdisk:
        Enter   Dosselectdisk         ; push registers

        mov     dx,[bp].drive         ; load drive number
        dec     dx                    ; adjust for cp/dos incompatibility

        mov     ah,0eh
        int     21h                   ; select the drive

        sub     ax,ax                 ; set good return code

        mexit                         ; pop registers
        ret     str_size - 6          ; return

; ENDP dosselectdisk

; END SECTION .dosxxx

            ; end
