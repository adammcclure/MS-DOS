;	SCCSID = @(#)intnat.asm	1.1 85/04/10
BREAK <International data structure format>

;
; Current structure of the data returned by the international call
;
struc internat_block
Date_tim_format: resw 1; 0-USA, 1-EUR, 2-JAP
Currency_sym: resb 1; Currency Symbol 5 bytes
		resb 1
		resb 1
		resb 1
		resb 1
Thous_sep: resb 1; Thousands separator 2 bytes
		resb 1
Decimal_sep: resb 1; Decimal separator 2 bytes
		resb 1
Date_sep: resb 1; Date separator 2 bytes
		resb 1
Time_sep: resb 1; Decimal separator 2 bytes
		resb 1
Bit_field: resb 1; Bit values
					;   Bit 0 = 0 if currency symbol first
					;	  = 1 if currency symbol last
					;   Bit 1 = 0 if No space after currency symbol
					;	  = 1 if space after currency symbol
Currency_cents: resb 1; Number of places after currency dec point
Time_24: resb 1; 1 if 24 hour time, 0 if 12 hour time
Map_call: resw 1; Address of case mapping call (DWORD)
		resw 1; THIS IS TWO WORDS SO IT CAN BE INITIALIZED
					;  in pieces.
Data_sep: resb 1; Data list separator character
		resb 1
endstruc

;
; Max size of the block returned by the INTERNATIONAL call
;
internat_block_max	EQU	32
