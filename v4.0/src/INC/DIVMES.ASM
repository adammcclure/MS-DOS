; THIS IS THE ONLY DOS "MESSAGE". IT DOES NOT NEED A TERMINATOR.
	global DIVMES
global DIVM001S,DIVM001E
DIVM001S:

%include "msdos.cl1"

	global DivMesLen
DivMesLen   DW	$-DivMes	; Length of the above message in bytes
DIVM001E:
