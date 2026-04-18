;	SCCSID = @(#)envdata.asm	1.1 85/05/14
;	SCCSID = @(#)envdata.asm	1.1 85/05/14
; This file is included by command.asm and is used as the default command
; environment.

SECTION .ENVARENA
	ORG 0
	DB  10h  DUP (?)		 ;Pad for memory allocation addr mark
; END SECTION .ENVARENA

SECTION .ENVIRONMENT; Default COMMAND environment

	global ECOMSPEC,ENVIREND,PATHSTRING

	ORG	0
PATHSTRING DB	"PATH="
USERPATH:

	DB	0		; Null path
	DB	"COMSPEC="
ECOMSPEC DB	"\COMMAND.COM"      ;AC062
	times 134 db 0

ENVIREND:

ENVIRONSIZ EQU	$-PATHSTRING
ENVIRONSIZ2 EQU $-ECOMSPEC
; END SECTION .ENVIRONMENT
