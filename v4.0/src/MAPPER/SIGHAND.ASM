; page 80,132

; title CP/DOS DosSetSigHandler  mapper

        %include "msc.inc"

SECTION .dosxxx
        ; assume  cs:dosxxx,ds:nothing,es:nothing,ss:nothing

;**********************************************************************
;*
;*   MODULE:   dossetsighandler
;*
;*   FILE NAME: dos007.asm
;*
;*   CALLING SEQUENCE:
;*
;*       push      word    file handle
;*       push      dword   distance
;*       push      word    move type
;*       push@     dword   new pointer
;*       call      doschgfileptr
;*
;*   MODULES CALLED:  PC-DOS Int 21h, ah=42h
;*
;*********************************************************************

            global dossetsighandler
            ; .sall
            ; .xlist
            %include "macros.inc"
            ; .list

struc str
old_bp: resw 1
return: resd 1
Signumber: resw 1; signal number
Action: resw 1; action code
Prevaction: resd 1; previous action code
Prevadrs: resd 1; previous vector address
Routineadrs: resd 1; interrupt handler address
endstruc

; While we hate to do this, we have to.  The following data areas are
; expected to be in the CODE segment.

NextControlBreakHandler:
NextControlBreakHandlerOffset   dw      DummyControlBreakHandler
NextControlBreakHandlerSegment  dw      dosxxx

NextCriticalErrorHandler:
NextCriticalErrorHandlerOffset  dw      DummyCriticalErrorHandler
NextCriticalErrorHandlerSegment dw      dosxxx

dossetsighandler:

        Enter    dossetsighandler       ; push registers

        mov      ax,[bp].action         ; get action code
        cmp      ax,2                   ; action code 2 ??
        je       continue1              ; branch if true
        mov      ax,1                   ; else, set error code
        jmp      exit                   ; return

continue1:
        mov      ax,[bp].signumber      ; get signel number
        cmp      ax,1                   ; signal 1 (cntrl chara) ??
        je       cntrlc                 ; jump if true
        cmp      ax,4                   ; signal 4 (cntrl chara) ??
        je       cntrlc                 ; jump if true
        mov      ax,2                   ; else, set error code
        jmp      exit                   ; return

cntrlc: mov      ax,03523h
        int      21h                    ; get old vector address

        lds      si,[bp].prevadrs       ; previous handler pointer
        mov      word [si],bx       ; save it in prevsdrs
        mov      word [si]+2,es

        lds      dx,[bp].routineadrs    ; get address of signal  handler

        mov     NextControlBreakHandlerOffset,dx   ; save it
        mov     NextControlBreakHandlerSegment,ds

        mov     dx,cs
        mov     ds,dx
        mov     dx,RealControlBreakHandler

        mov      ax,02523H
        int      21h                   ; set signal handler addrs in vector

        sub      ax,ax                 ; set good return code

exit:   mexit                          ; pop registers
        ret      str_size - 6          ; return

; ENDP dossetsighandler

        ; page

;------------------------------------------------------------------------------

; This routine will get control on  control break, and it will make
;  sure that the environment is acceptable prior to calling the new
;  handler.  NOTE: we expect the new handler to be written in MicroSoft 'C'

RealControlBreakHandler:

        push    ds
        push    es
        push    di
        push    si
        push    bp
        push    dx
        push    cx
        push    bx
        push    ax

; reestablish the es and ds segment registers before going to 'C'

        mov     ax,seg DGroup
        mov     ds,ax
        mov     es,ax

        call    NextControlBreakHandler

        pop     ax
        pop     bx
        pop     cx
        pop     dx
        pop     bp
        pop     si
        pop     di
        pop     es
        pop     ds

        iret

; ENDP RealControlBreakHandler

        ; page

;------------------------------------------------------------------------------

; This routine will get control on the control break, and it will make
;  sure that the environment is acceptable prior to calling the new
;  handler.  NOTE: we expect the new handler to be written in MicroSoft 'C'

RealCriticalErrorHandler:

        push    ds
        push    es
        push    di
        push    si
        push    bp
        push    dx
        push    cx
        push    bx
        push    ax

; reestablish the es and ds segment registers before going to 'C'

        mov     ax,seg DGroup
        mov     ds,ax
        mov     es,ax

        call    NextControlBreakHandler

        pop     ax
        pop     bx
        pop     cx
        pop     dx
        pop     bp
        pop     si
        pop     di
        pop     es
        pop     ds

        iret

; ENDP RealCriticalErrorHandler

        ; page

;------------------------------------------------------------------------------

DummyControlBreakHandler:

                iret

; ENDP DummyControlBreakHandler

DummyCriticalErrorHandler:

                iret

; ENDP DummyCriticalErrorHandler



; END SECTION .dosxxx

            ; end
