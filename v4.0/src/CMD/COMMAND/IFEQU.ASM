;       SCCSID = @(#)ifequ.asm  1.1 85/05/14
;       SCCSID = @(#)ifequ.asm  1.1 85/05/14
;*************************************
; COMMAND EQUs which are switch dependant

%if 1  ; IF1 - pass-specific
    %if IBM
        %warning DBCS Enabled IBM  version
    %else
        %warning Normal version
    %endif

;;  IF   KANJI                  3/3/KK
;;      %OUT Kanji version      3/3/KK
;;  ENDIF                       3/3/KK

%endif
