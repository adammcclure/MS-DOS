;---Revised 8-17-84 FOR KBX	(ADDED ADDITIONAL KEYBOARD FLAG - KB_FLAG_3)
;----------------------------------------
;	 0286 INTERRUPT LOCATIONS (READ):
;----------------------------------------
SECTION .ABS0
STG_LOC0:
	ORG 2*4
NMI_PTR:
	ORG 5*4
INT5_PTR:
	ORG 8*4
INT_ADDR:
INT_PTR:
	ORG 10H*4
VIDEO_INT:
	ORG 13H*4			; NEW FDISK
ORG_VECTOR:
	ORG 18H*4
BASIC_PTR:
	ORG 19H*4
BOOT_VEC:
BOOT_VECTOR:
	ORG 1DH*4
PARM_PTR:; POINTER TO VIDEO PARMS
	ORG 1EH*4
DISK_POINTER:
	ORG 01FH*4
EXT_PTR:
	ORG 40H*4			; DISKETTE POINTER
DISK_VECTOR:
       ORG 41H*4
HF_TBL_VEC:
	ORG 46H*4
HF1_TBL_VEC:
	ORG 70H*4
SLAVE_INT_PTR:
RTC_INT_VEC:; REAL TIME CLOCK INT
	ORG 76H*4			; FIXED DISK INTERRUPT VECTOR
HDISK_INT:
	ORG	400H
DATA_AREA:;ABSOLUTE LOCATION OF DATA SEGMENT
DATA_WORD:
	ORG	0500H
MFG_TEST_RTN:
	ORG	7C00H
BOOT_LOCN:
; END SECTION .ABS0
; PAGE
;------------------------------------------------
; STACK -- USED DURING INITIALIZATION ONLY	:
;------------------------------------------------
SECTION .STACK
	times 128 dw 0
TOS:
; END SECTION .STACK
;----------------------------------------
;	ROM BIOS DATA AREAS		:
;----------------------------------------
SECTION .DATA
;DATA_BASE	 LABEL	 BYTE
RS232_BASE: times 4 dw 0; ADDRESSES OF RS232 ADAPTERS
PRINTER_BASE: times 4 dw 0; ADDRESSES OF PRINTERS
EQUIP_FLAG: times 1 dw 0; INSTALLED HARDWARE
MFG_TST: times 1 db 0; INITIALIZATION FLAG
MEMORY_SIZE: times 1 dw 0; MEMORY SIZE IN K BYTES
MFG_ERR_FLAG: times 1 db 0; SCRATCHPAD FOR MANUFACTURING
		times 1 db 0; ERROR CODES
; PAGE
;----------------------------------------
;	KEYBOARD DATA AREAS		:
;----------------------------------------
KB_FLAG: times 1 db 0
KB_FLAG_1: times 1 db 0; SECOND BYTE OF KEYBOARD STATUS
ALT_INPUT: times 1 db 0; STORAGE FOR ALTERNATE KEYPAD ENTRY
BUFFER_HEAD: times 1 dw 0; POINTER TO HEAD OF KEYBOARD BUFFER
BUFFER_TAIL: times 1 dw 0; POINTER TO TAIL OF KEYBOARD BUFFER
KB_BUFFER: times 16 dw 0; ROOM FOR 15 ENTRIES
KB_BUFFER_END:

;------ HEAD = TAIL INDICATES THAT THE BUFFER IS EMPTY

;----------------------------------------
;	DISKETTE DATA AREAS		:
;----------------------------------------
SEEK_STATUS: times 1 db 0; DRIVE RECALIBRATION STATUS
					; BIT 3-0 = DRIVE 3-0 NEEDS RECAL
					; BEFORE NEXT SEEK IF BIT IS = 0
MOTOR_STATUS: times 1 db 0; MOTOR STATUS
					; BIT 3-0 = DRIVE 3-0 IS CURRENTLY
					;   RUNNING
					; BIT 7 = CURRENT OPERATION IS A WRITE,
					;   REQUIRES DELAY
MOTOR_COUNT: times 1 db 0; TIME OUT COUNTER FOR DRIVE TURN OFF
DISKETTE_STATUS: times 1 db 0; RETURN CODE STATUS BYTE
CMD_BLOCK:
HD_ERROR:
NEC_STATUS: times 7 db 0; STATUS BYTES FROM NEC
; PAGE
;----------------------------------------
;	VIDEO DISPLAY DATA AREA 	:
;----------------------------------------
CRT_MODE: times 1 db 0; CURRENT CRT MODE
CRT_COLS: times 1 dw 0; NUMBER OF COLUMNS ON SCREEN
CRT_LEN: times 1 dw 0; LENGTH OF REGEN IN BYTES
CRT_START: times 1 dw 0; STARTING ADDRESS IN REGEN BUFFER
CURSOR_POSN: times 8 dw 0; CURSOR FOR EACH OF UP TO 8 PAGES
CURSOR_MODE: times 1 dw 0; CURRENT CURSOR MODE SETTING
ACTIVE_PAGE: times 1 db 0; CURRENT PAGE BEING DISPLAYED
ADDR_6845: times 1 dw 0; BASE ADDRESS FOR ACTIVE DISPLAY CARD
CRT_MODE_SET: times 1 db 0; CURRENT SETTING OF THE 3X8 REGISTER
CRT_PALLETTE: times 1 db 0; CURRENT PALLETTE SETTING COLOR CARD
; PAGE
;----------------------------------------
;	POST DATA AREA			:
;----------------------------------------
IO_ROM_INIT: times 1 dw 0; PNTR TO OPTIONAL I/O ROM INIT ROUTINE
IO_ROM_SEG: times 1 dw 0; POINTER TO IO ROM SEGMENT
INTR_FLAG: times 1 db 0; FLAG TO INDICATE AN INTERRUPT HAPPEND
;----------------------------------------
;	TIMER DATA AREA 		:
;----------------------------------------
TIMER_LOW: times 1 dw 0; LOW WORD OF TIMER COUNT
TIMER_HIGH: times 1 dw 0; HIGH WORD OF TIMER COUNT
TIMER_OFL: times 1 db 0; TIMER HAS ROLLED OVER SINCE LAST READ
;----------------------------------------
;	SYSTEM DATA AREA		:
;----------------------------------------
BIOS_BREAK: times 1 db 0; BIT 7=1 IF BREAK KEY HAS BEEN HIT
RESET_FLAG: times 1 dw 0; WORD=1234H IF KEYBOARD RESET UNDERWAY
; PAGE
;----------------------------------------
;	HARD FILE DATA AREAS		:
;----------------------------------------
DISK_STATUS1: times 1 db 0
HF_NUM: times 1 db 0
CONTROL_BYTE: times 1 db 0
PORT_OFF: times 1 db 0
;------------------------------------------------------
;	PRINTER AND RS232 TIME-OUT VARIABLES	      :
;------------------------------------------------------
PRINT_TIM_OUT: times 4 db 0
RS232_TIM_OUT: times 4 db 0
;----------------------------------------
;	ADDITIONAL KEYBOARD DATA AREA	:
;----------------------------------------
BUFFER_START: times 1 dw 0
BUFFER_END: times 1 dw 0
;---------------------------------------
;	ADDITIONAL FLOPPY DATA	       ;
;---------------------------------------
	ORG	8BH
LASTRATE: times 1 db 0; LAST DATA RATE SELECTED
; PAGE
;---------------------------------------
;	ADDITIONAL HARD FILE DATA      :
;---------------------------------------
	ORG	8CH
HF_STATUS: times 1 db 0; STATUS REGISTER
HF_ERROR: times 1 db 0; ERROR REGISTER
HF_INT_FLAG: times 1 db 0; HARD FILE INTERRUPT FLAG
HF_CNTRL: times 1 db 0; COMBO HARD FILE/FLOPPY CARD BIT 0=1
;----------------------------------------
;	ADDITIONAL DISKETTE AREA       :
;----------------------------------------
	ORG	90H
DSK_STATE:
		times 1 db 0; DRIVE 0 MEDIA STATE
		times 1 db 0; DRIVE 1 MEDIA STATE
		times 1 db 0; DRIVE 0 OPERATION START STATE
		times 1 db 0; DRIVE 1 OPERATION START STATE
DSK_TRK: times 1 db 0; DRIVE 0 PRESENT CYLINDER
		times 1 db 0; DRIVE 1 PRESENT CYLINDER
		times 1 db 0; RESERVED
;----------------------------------------				AEV
;	ADDITIONAL KEYBOARD FLAG FOR KBX:				AEV
;----------------------------------------				AEV
	ORG	96H			;				AEV
KB_FLAG_3: times 1 db 0;				AEV
;----------------------------------------
;	ADDITIONAL KEYBOARD LED FLAG	:
;----------------------------------------
	ORG	97H
KB_FLAG_2: times 1 db 0
; PAGE
;----------------------------------------
;	REAL TIME CLOCK DATA AREA	:
;----------------------------------------
	ORG	98H
USER_FLAG: times 1 dw 0; OFFSET ADDR OF USERS WAIT FLAG
USER_FLAG_SEG: times 1 dw 0; SEG ADDR OF USER WAIT FLAG
RTC_LOW: times 1 dw 0; LOW WORD OF USER WAIT FLAG
RTC_HIGH: times 1 dw 0; HIGH WORD OF USER WAIT FLAG
RTC_WAIT_FLAG: times 1 db 0; WAIT ACTIVE FLAG
; END SECTION .DATA
;----------------------------------------
;	EXTRA DATA AREA 		:
;----------------------------------------
SECTION .XXDATA
STATUS_BYTE: times 1 db 0
; END SECTION .XXDATA
;----------------------------------------
;	VIDEO DISPLAY BUFFER		:
;----------------------------------------
SECTION .VIDEO_RAM
REGEN:
REGENW:
	times 16384 db 0
; END SECTION .VIDEO_RAM
