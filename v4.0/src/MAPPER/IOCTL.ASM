; page 80,132

; title CP/DOS DosDevIOCTl   mapper

SECTION .dosxxx
        ; assume  cs:dosxxx,ds:nothing,es:nothing,ss:nothing
;
;**********************************************************************
;*
;*   MODULE:   dosdevioctl
;*
;*   FILE NAME: dos007.asm
;*
;*   CALLING SEQUENCE:
;*
;*       push@     dword   Data
;*       push@     dword   Paramlist
;*       push      word    Function
;*       push      word    Category
;*       push@     word    Devicehandle
;*
;*       call      doschgfileptr
;*
;*   MODULES CALLED:  PC-DOS Int 21h, ah=42h, move file pointer
;*
;*********************************************************************

            global dosdevioctl
            ; .sall
            ; .xlist
            %include "macros.inc"
            ; .list

struc str
Old_bp: dw 0
Return: dd 0
Handle: dw 0; handle
Category: dw 0; device category
Function: dw 0; device function
Parmlist: dd 0; command arguments
Data: dd 0; data area
endstruc

dosdevioctl:
        Enter   dosdevioctl           ; push registers

        mov     bx,[bp].handle        ; get handle

        cmp     bx,0ffe5h             ; is it a device handle ??
        jl      filehandle            ; branch if not

; Convert DASD device handle to drive number as follows:
;  Drive        Open    IOCTL
;  Letter       Handle  DASD #
; -----------------------------
;    A           -2      1
;    B           -3      2
;    C           -4      3
;    D           -5      4
;    E           -6      5
        neg     bx                    ; convert dev handle to
        dec     bx                    ; drive number

filehandle:
        mov     ax,[bp].function      ; get function code
        cmp     ax,020H               ; check for right function
        je      continue1             ; continue if right function code
        mov     ax,01H                ; else, load error code
        jmp     exit                  ; return

continue1:                            ; only category 8 is supported
        mov     ax,[bp].category      ; set category

        mov     ah,44h
        int     21h                   ; do ioctl
        jnc     continue              ; check for error

        cmp     ax,1                  ; if error and return code = 1
        jne     exit                  ; then it is network drive
                                      ; therefore continue
continue:
        lds     si,[bp].data          ; media changable
        mov     byte [si],al      ; save in data area
        xor     ax,ax                 ; set no error coe

exit:   mexit                         ; pop registers
        ret     str_size - 6          ; return

; ENDP dosdevioctl

; END SECTION .dosxxx

            ; end
