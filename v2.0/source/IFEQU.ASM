;*************************************
; COMMAND EQUs which are switch dependant

%if 1  ; IF1 - pass-specific
    %if IBM
        %warning IBM version
    %else
        %warning Normal version
    %endif

    %if HIGHMEM
        %warning Highmem version
    %endif

    %if KANJI
        %warning Kanji version
    %endif
%endif
