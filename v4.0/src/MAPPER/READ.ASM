; page 80,132

; title CP/DOS DosRead mapper   * * *

SECTION .dosxxx
        ; assume  cs:dosxxx,ds:nothing,es:nothing,ss:nothing

;**********************************************************************
;*
;*   MODULE:   dosreade
;*
;*   FUNCTION: Read a specified number of bytes from the file
;*
;*   CALLING SEQUENCE:
;*
;*       push      word     file handle
;*       push@     other    buffer area
;*       push      word     buffer length
;*       push@     word     bytes read
;*       call      dosread
;*
;*   MODULES CALLED:  PC-DOS Int 21h, ah=3fh,
;*
;*********************************************************************

            global dosread
            ; .sall
            ; .xlist
            %include "macros.inc"
            ; .list

struc str
old_bp: resw 1
return: resd 1
Written: resd 1; number of bytes actually read
Bufflng: resw 1; number of bytes to be read
Buffer: resd 1; read buffer
Handle: resw 1; handle
endstruc

dosread:
            Enter    Dosread           ; save registers

            mov      bx,[bp].handle    ; fill registers for
            lds      dx,[bp].buffer    ; function call
            mov      cx,[bp].bufflng   ; number of bytes to read

            mov      ah,3fh            ; load opcode
            int      21h               ; read from file
            jc       exit              ; jump if error

            lds      si,[bp].written   ; else, set return data area
            mov      word [si],ax  ; save number of bytes read
            sub      ax,ax             ; set good return code

exit:       mexit                      ; pop registers
            ret      str_size - 6      ; rturn

; ENDP dosread

; END SECTION .dosxxx

            ; end
