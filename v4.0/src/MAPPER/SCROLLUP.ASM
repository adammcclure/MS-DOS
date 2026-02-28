;
; page 60,132
;
; title CP/DOS VioScrollUp mapper
;
SECTION .vioxxx
        ; assume  cs:vioxxx,ds:nothing,es:nothing,ss:nothing
;
; ************************************************************************* *
; *
; *      MODULE: VioScrollUp
; *
; *      FILE NAME: scrollup.asm
; *
; *      CALLING SEQUENCE:
; *
; *
; *             push    word    toprow
; *             push    word    leftcol
; *             push    word    botrow
; *             push    word    rightcol
; *             push    word    lines
; *             push@   dword   cell
; *             push    word    vio handle
; *             call    vioscrollup
; *
; *      MODULES CALLED:  BIOS Int 10h
; *
; *
; *
; *************************************************************************

        global vioscrollup
        ; .sall
        ; .xlist
        %include "macros.inc"
        ; .list

error_bvs_parameter equ 0002h

struc str
old_bp: dw 0
return: dd 0
handle: dw 0; vio handle
cell: dd 0; cell to be written
lines: dw 0; number of blank lines
rightcol: dw 0; right column
botrow: dw 0; bottom row
leftcol: dw 0; left column
toprow: dw 0; top row
endstruc

vioscrollup:
        Enter   VioScrollUp             ; save registers

        mov     bx,[bp].lines           ; get number of blank lines
        cmp     bl,25                   ; check for validity
        jg      error                   ; jump if invalid

        mov     al,bl
        jmp     ar02

ar01:   mov     al,00h
ar02:   mov     ah,06h                  ; set scroll up function code

        mov     bx,[bp].rightcol        ; get right col number
        cmp     bl,80                   ; check the validity
        jg      error                   ; branch if error
        mov     dl,bl                   ; right column number in DL

        mov     bx,[bp].botrow          ; get bottom row
        cmp     bl,25                   ; check for validity
        jg      error                   ; branch if error
        mov     dh,bl                   ; bottom row in DH

        mov     bx,[bp].leftcol         ; get left column number
        mov     cl,bl                   ; left column in CL

        mov     bx,[bp].toprow          ; get top row number
        mov     ch,bl                   ; top row in CH

        lds     si,[bp].cell            ; Set up cell in BX
        mov     bx,ds:[si]              ;                    *****************
;       cmp     bl,15                   ; check validity     ** assume good **
;       jg      error                   ; branch if error    ** attribute!  **
                                        ;                    *****************
        mov     bh,bl                   ; filler attribute in BH
        pushal                          ; Save registers in case int 10h
                                        ;   messes them up
        int     10h                     ; scrollup the display

        popal
        sub     ax,ax                   ; set no error code
        jmp     exit                    ; return

error:  mov     ax,error_bvs_parameter  ; set error code

exit:   Mexit                           ; pop registers
        ret     str_size - 6            ; return

; ENDP vioscrollup
; END SECTION .vioxxx
        ; end
