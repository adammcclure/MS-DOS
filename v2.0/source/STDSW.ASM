TRUE    EQU     0FFFFH
FALSE   EQU     NOT TRUE

; Use the switches below to produce the standard Microsoft version or the IBM
; version of the operating system
MSVER   EQU     false
IBM     EQU     true
WANG    EQU     FALSE
ALTVECT EQU     FALSE

; Set this switch to cause DOS to move itself to the end of memory
HIGHMEM EQU     FALSE

        %if IBM
ESCCH   EQU     0                       ; character to begin escape seq.
CANCEL  EQU     27
TOGLINS EQU     TRUE                    ;One key toggles insert mode
TOGLPRN EQU     TRUE                    ;One key toggles printer echo
ZEROEXT EQU     TRUE
        %else
        %if WANG;Are we assembling for WANG?
ESCCH   EQU     1FH                     ;Yes. Use 1FH for escape character
        %else
ESCCH   EQU     1BH
        %endif
CANCEL  EQU     "X"-"@"                 ;Cancel with Ctrl-X
TOGLINS EQU     WANG                    ;Separate keys for insert mode on
                                        ;and off if not WANG
TOGLPRN EQU     FALSE                   ;Separate keys for printer echo on
                                        ;and off
ZEROEXT EQU     TRUE
        %endif

