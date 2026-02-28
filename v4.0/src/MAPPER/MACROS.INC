;
        %if 1  ; IF1 - pass-specific
                %warning macros.inc
        %endif


%macro pushal 0
        push    bx
        push    cx
        push    dx
        push    si
        push    di
        push    ds
        push    es
        push    ss
        push    bp
        %endmacro
;
%macro popal 0
        pop     bp
        pop     ss
        pop     es
        pop     ds
        pop     di
        pop     si
        pop     dx
        pop     cx
        pop     bx
        %endmacro
;
%macro Enter 1

        push    bp
        mov     bp,sp
        pushal

        %endmacro
;
%macro Mexit 0

        popal
        mov     sp,bp
        pop     bp

        %endmacro
