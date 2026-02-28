;
; page 60,132
;
; title CP/DOS VioWrtCharStrAtt mapper
;
SECTION .vioxxx
        ; assume  cs:vioxxx,ds:nothing,es:nothing,ss:nothing
;
; ************************************************************************* *
; *
; *      MODULE:  viowrtcharstratt     Write character string with attribute
; *
; *      FILE NAME:  wchstra.asm
; *
; *      CALLING SEQUENCE:
; *
; *             push@   dword   char_str
; *             push    word    length
; *             push    word    row
; *             push    word    column
; *             push@   dword   attribute
; *             push    word    vio handle
; *             call    viowrtcharstr
; *
; *
; *      MODULES CALLED:  BIOS int 10h
; *
; *************************************************************************

        global viowrtcharstratt
        ; .sall
        ; .xlist
        %include "macros.inc"
        ; .list

full_scr_err equ 0001h
error_bvs_parameter     equ 0002h

struc str
old_bp: dw 0
return: dd 0
handle: dw 0; vio handle
attr: dd 0; attribute pointer
column: dw 0; column number
row: dw 0; starting position for output
lngth: dw 0; length of the string
addr: dd 0; string to be written (pointer)
endstruc

viowrtcharstratt:
        Enter   viowrtcharstratt         ; push registers

        sub     bh,bh
        sub     ax,ax                    ; Start with clean error condition
        mov     dx,[bp].column           ; get column number
        cmp     dl,80                    ; check for upper boundry
        jg      error                    ; branch if illegal number

        mov     ax,[bp].row              ; get row number
        cmp     al,25                    ; check for upper boundry
        jg      error                    ; branch if illegal number
        mov     dh,al
        mov     ah,02h
        pushal                           ; Save registers in case int 10h
                                         ;   messes them up
        int     10h                      ; Set start cursor position

        popal
        lds     si,[bp].attr             ; Set up attribute in BL
        mov     bl,byte ds:[si]
        lds     si,[bp].addr             ; DS:SI is pointer to string
        mov     di,[bp].lngth
                                         ;  ****************************
;       cmp     bl,15                    ;  ** assume good attribute! **
;       jg      error                    ;  ****************************

top:    mov     al,byte [si]
        mov     ah,09h                   ; set write char/attrib function code
        mov     cx,1                     ; write only one character
        pushal                           ; Save registers in case int 10h
                                         ;   messes them up
        int     10h                      ; Output one character

        popal                            ; restore registers
        inc     si
        dec     di
        inc     dl
        cmp     dl,80                    ; Handle end of line condition
        jne     around                   ;    |
        inc     dh                       ;    |
        mov     dl,00                    ;    V
        cmp     dh,25                    ; Handle end of screen condition
        jne     around                   ;    |
        mov     ax,full_scr_err          ; Error in AX
        jmp     exit

around: mov     ah,02h
        pushal                           ; Save registers in case int 10h
                                         ;   messes them up
        int     10h                      ; Increment cursor position

        popal
        cmp     di,0                     ; check if complete string is written
        jne     top                      ; else, go and write next character

        sub     ax,ax                    ; set no error code

error:  mov     ax,error_bvs_parameter

exit:   Mexit                            ; return
        ret     str_size - 6
;
; ENDP viowrtcharstratt
; END SECTION .vioxxx
        ; end
