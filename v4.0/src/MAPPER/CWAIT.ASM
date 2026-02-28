;
; page 60,132
;
; title CP/DOS  DOSCWait  mapper

; ************************************************************************* *
; *
; *      MODULE: DosCWait
; *
; *      ACTION:    Wait for a child termination
; *
; *      CALLING SEQUENCE:
; *
; *             push    actioncode      ; execution options
; *             push    waitoption      ; wait options
; *             push@   resultcode      ; address to put result code
; *             push@   processidword   ; address to put process id
; *             push    processid       ; process id of process to wait for
; *             call    doscwait
; *
; *      RETURN SEQUENCE:
; *
; *
; *
; *      MODULES CALLED:   None
; *
; *
; *
; *************************************************************************

SECTION .buffer

        extern DosExecPgmCalled
        extern DosExecPgmReturnCode

; END SECTION .buffer

SECTION .dosxxx
        ; assume  cs:dosxxx,ds:nothing,es:nothing,ss:nothing

        global doscwait
        ; .sall
        ; .xlist
        %include "macros.inc"
        ; .list
;
struc str
old_bp: dw 0
return: dd 0
Qprocessid: dw 0; Child process ID
Aprocessid: dd 0; process id pointer
resultcode: dd 0; result code pointer
waitoption: dw 0; wait option
actioncode: dw 0; action code
endstruc

doscwait:
        Enter   doscwait                 ; push registers

        mov     ax,seg buffer
        mov     ds,ax                    ; set temporary buffer
        ; assume  ds:buffer

        cmp     DosExecPgmCalled,0       ; ??????
        jz      WeHaveExeced

        mov     ax,31
        jmp     ErrorExit                ; error exit

WeHaveExeced:
        mov     ax,DosExecPgmReturnCode
        lds     si,[bp].ResultCode
        ; assume  ds:nothing
        mov     ds:[si],ax               ; return termination code

        mov     ax,[bp].Qprocessid       ; return child process id
        lds     si,[bp].Aprocessid
        mov     ds:[si],ax

        xor     ax,ax                    ; set good return code

ErrorExit:
        Mexit                            ; pop registers
        ret     str_size - 6             ; return

; ENDP doscwait

; END SECTION .dosxxx

        ; end
