;	SCCSID = @(#)intnat.asm	1.1 85/04/10
BREAK <International data structure format>

;
; Current structure of the data returned by the international call
;
struc internat_block
Date_tim_format: dw 0; 0-USA, 1-EUR, 2-JAP
Currency_sym: db 0; Currency Symbol 5 bytes
		db 0
		db 0
		db 0
		db 0
Thous_sep: db 0; Thousands separator 2 bytes
		db 0
Decimal_sep: db 0; Decimal separator 2 bytes
		db 0
Date_sep: db 0; Date separator 2 bytes
		db 0
Time_sep: db 0; Decimal separator 2 bytes
		db 0
Bit_field: db 0; Bit values
					;   Bit 0 = 0 if currency symbol first
					;	  = 1 if currency symbol last
					;   Bit 1 = 0 if No space after currency symbol
					;	  = 1 if space after currency symbol
Currency_cents: db 0; Number of places after currency dec point
Time_24: db 0; 1 if 24 hour time, 0 if 12 hour time
Map_call: dw 0; Address of case mapping call (DWORD)
		dw 0; THIS IS TWO WORDS SO IT CAN BE INITIALIZED
					;  in pieces.
Data_sep: db 0; Data list separator character
		db 0
endstruc

;
; Max size of the block returned by the INTERNATIONAL call
;
internat_block_max	EQU	32
