;
; page 60,132
;
; title CP/DOS  DOSQhandtype  mapper
;
SECTION .dosxxx
        ; assume  cs:dosxxx,ds:nothing,es:nothing,ss:nothing
;
; ************************************************************************* *
; *
; *      MODULE: DosQhandtype
; *
; *      FILE NAME: DosQhandtype
; *
; *      FUNCTION: Determine whether a handle is file or device
; *
; *      CALLING SEQUENCE:
; *
; *             push    handle          ; file handle
; *             push@   handtype        ; handle type
; *             push@   flagword        ; device descriptor word
; *             call    dosqhandtype
; *
; *      RETURN SEQUENCE:
; *
; *             handle type:   0  - if a file
; *                            1  - if a device
; *      MODULES CALLED:
; *
; *
; *************************************************************************

        global dosqhandtype
        ; .sall
        ; .xlist
        %include "macros.inc"
        ; .list


struc str
old_bp: resw 1
return: resd 1
AttributePtr: resd 1; Device descriptor word returned if device
HandleTypePtr: resd 1; handle type; 0 = file handle, 1 = device handle
Handle: resw 1; file handle
endstruc


dosqhandtype:

        Enter   dosqhandtype            ; push registers

        mov     bx,[bp].Handle          ; get file handle
        mov     ax,4400h
        int     21h                     ; get handle type

        lds     si,[bp].AttributePtr    ; setup area for attribute return
        mov     [ds:si],dx

        lds     si,[bp].HandleTypePtr
        mov     ds:word [si],0      ; assume it is a file

        test    dx,00080h               ; test for file
        jz      ItIsAFile               ; jump if true

        mov     ds:word [si],1      ; else, it is a device, set flag

ItIsAFile:
        Mexit                           ; pop registers
        ret     str_size - 6            ; return

; ENDP dosqhandtype

; END SECTION .dosxxx

        ; end
