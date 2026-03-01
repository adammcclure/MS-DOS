; page 80,132

; title CP/DOS  DosFindClose  mapper

        %include "find.inc"


SECTION .FindSegment

; We will use the offset into the segment 'FindSegment' as the handle that we
;  return and use in subsequent FindNext and FindClose calls.  The data that is
;  in the word is the offset into the 'FindSegment' to the DTA that we should
;  use.
                extern FindDTAs
                extern FindHandles

; END SECTION .FindSegment


; ************************************************************************* *
; *
; *      MODULE: DosFindClose
; *
; *      FUNCTION:  Close Find Handle
; *
; *      FUNCTION: This module closes the directory handle used by CP/DOS
; *                in a find first/find next search.  Since PC/DOS does not
; *                use directory handles it will simply return to the caller
; *                removing the parameters passed on the stack.
; *
; *      CALLING SEQUENCE:
; *
; *                PUSH  WORD  DirHandle   ; Directory search handle
; *                CALL DosFindClose
; *
; *
; *      RETURN SEQUENCE:
; *
; *                IF ERROR (AX not = 0)
; *
; *                   AX = Error Code:
; *
; *
; *      MODULES CALLED:  None
; *
; *************************************************************************

        global DosFindClose
        ; .sall
        ; .xlist
        %include "macros.inc"
        ; .list

struc str
old_bp: resw 1
return: resd 1
DirHandle: resw 1; dirctory search handle
endstruc


SECTION .dosxxx
        ; assume  cs:dosxxx,ds:nothing,es:nothing,ss:nothing

DosFindClose:
        Enter   DosFindClose               ; push registers

        mov     ax,seg FindSegment         ; get address to our data
        mov     ds,ax
        ; assume  ds:FindSegment

; Close the handle

; The 'DirHandle' that the mapper returns from FindFirst, is the offset into
; 'FindSegment' of the pointer to the DTA for that Handle.  The 08000h bit
; of the pointer is used to indicate that the handle is open.  Reset the bit.

; Special Logic to handle DirHandle = 1

        mov     si,[bp].DirHandle          ; get directory hanlde
        cmp     si,1                       ; handle = 1??
        jne     CheckForClose              ; branch if not

        mov     si,FindHandles

CheckForClose:
        test    [ds:si],OpenedHandle       ; handle is open ??
        jnz     OkToClose                  ; go and close if it is open

        mov     ax,6                       ; else load error code
        jmp     ErrorExit                  ; return

OkToClose:
        and     [ds:si],not OpenedHandle   ; set close flag
        xor     ax,ax                      ; set good return code

ErrorExit:
        mexit                              ; pop registers
        ret     str_size - 6               ; return

; ENDP DosFindClose

; END SECTION .dosxxx

        ; end
