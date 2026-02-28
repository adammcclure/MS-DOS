; page 80,132

; title CP/DOS DosWrite mapper

SECTION .dosxxx
        ; assume  cs:dosxxx,ds:nothing,es:nothing,ss:nothing

;**********************************************************************
;*
;*   MODULE:   doswrite
;*
;*   FUNCTION:  Write a specified number of bytes to a file
;*
;*   CALLING SEQUENCE:
;*
;*       push      word     file handle
;*       push@     other    buffer area
;*       push      word     buffer length
;*       push@     word     bytes written
;*       call      doswrite
;*
;*   MODULES CALLED:  PC-DOS Int 21h, ah=40h, write
;*
;*********************************************************************

            global doswrite
            ; .sall
            ; .xlist
            %include "macros.inc"
            ; .list

struc str
old_bp: dw 0
return: dd 0
Written: dd 0; number of bytes actually written
Bufflng: dw 0; number of bytes to be written
Buffer: dd 0; write buffer address
Handle: dw 0; file handle
endstruc

doswrite:

            Enter    doswrite            ; push registers

            mov      bx,[bp].handle      ; get handle
            lds      dx,[bp].buffer      ; set write buffer
            mov      cx,[bp].bufflng     ; number of bytes to be written

            mov      ah,40h              ; load opcode
            int      21h                 ; write bytes to the file
            jc       exit                ; jump if error

            lds      si,[bp].written     ; pointer to return data
            mov      word [si],ax    ; save actual number of bytes written
            sub      ax,ax               ; set good return code

exit:       mexit                        ; pop registers
            ret      str_size - 6        ; return

; ENDP doswrite

; END SECTION .dosxxx

            ; end
