
	; PAGE	,132

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  FILENAME:	  CPS Printer Device Driver EQUAL Include
;;  MODULE NAME:  CPSEQU
;;  TYPE:	  Include File
;;
;;  LINK PROCEDURE:  See CPSPx.ASM
;;
;;  INCLUDE FILES:
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;	Request Header (Common portion)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					;;
RH	EQU	ES:[DI] 		;; addressability to Request Header
					;;
struc RHC;; fields common to all request types
RHC_LEN: db 0;; length of Request Header
	db 0;; unit code (subunit)
RHC_CMD: db 0;; command code
RHC_STA: dw 0;; status
	dq 0;; reserved for DOS
endstruc;; end of common portion
					;;
					;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					;;
					;; Command in the Request Header
					;; (see CMD_CODES table)
					;;
					;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					;;
CMD_INI EQU	0			;; init  command
CMD_WRT EQU	8			;; write command
CMD_GIO EQU	19			;; generic IOCTL command
					;; (see major/minor GIO functions)
					;;
					;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					;;
					;; status values for RHC_STA
					;;
					;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					;;
STAT_DONE EQU	01H			;; function complete - high order byte
STAT_CMDERR EQU 8003H			;; invalid command code error
STAT_ERROR EQU	8000H			;; error returned by normal driver
					;;
;; see Generic IOCTL Request Header section
;; for more errorneous status.		;;
					;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;	Request Header for INIT
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					;;
					;;
struc RH0;;
	DB	(TYPE RHC) DUP (?)	;; common portion
					;;
	db 0;; not used for CHAR devices
RH0_ENDO: dw 0;; offset  of ending address
RH0_ENDS: dw 0;; segment of ending address
RH0_BPBA: dd 0;; pointer to BPBA
	db 0
RH0_CONFIG_ERRMSG dw 0			;DCR D493 "Error in CONFIG.SYS..." msg flag.
endstruc;;
					;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;	Request Header for IOCTL
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					;;
struc RH3;;
	DB	(TYPE RHC) DUP (?)	;; common portion
					;;
					;;
	db 0;; media descriptor
RH3_DTAO: dw 0;; offset  of transfer address
RH3_DTAS: dw 0;; segment of transfer address
RH3_CNT: dw 0;; byte count
endstruc;;
					;;
					;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;	Request Header for GENERIC IOCTL
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					;;
struc GIH;;
	DB	(TYPE RHC) DUP (?)	;; common portion
					;;
					;;
GIH_MAF: db 0;; major function
GIH_MIF: db 0;; minor function
GIH_SI: dw 0;; content of SI
GIH_DI: dw 0;; content of DI
GIH_GBA: dd 0;; Address of Generic Buffer
endstruc;;
					;;
					;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					;;
					;; GIO major/minor functions
					;; (see GIO_CODES table)
					;;
					;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MAF_CON EQU	03			;; major function for CON  device
MAF_PTR EQU	05			;; major function for LPTX device
					;;
MIF_DST EQU	4CH			;; minor function : designate start
MIF_DEN EQU	4DH			;;		    designate end
MIF_IVK EQU	4AH			;;		    invoke
MIF_QIV EQU	6AH			;;		    query-invoked
MIF_QLS EQU	6BH			;;		    query-list
					;;
					;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					;; Designate Start (MIF_DST)Flags
					;; see GBIS structure
					;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					;;
DSF_FIFOCP EQU	08000H			;; Single code page FIFO command
DSF_CARTCP EQU	00001H			;; Code page for Cartridge/semi-
					;; hardware RAM
					;;
					;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					;; Generic IOCTL errorneous status
					;; upon return
					;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					;;
STAT_DELETE EQU 08000H			;; previous degignate deleted (DST)
					;; STAT_DELETE : only for FIFO
STAT_NOFIND EQU 08008H			;; codepage,device not found  (DST)
STAT_DEVERR EQU 0800AH			;; Device error (DST,IVK,QIV,QLS,WRT)
STAT_BADATA EQU 0800CH			;; bad font file (DST)
STAT_NOBUFF EQU 0800CH			;; no font buffer for (REFRESH)
STAT_BADDEN EQU 0800CH			;; no DST (DEN)
STAT_bffDEN EQU 08000H			;; bad font file (DEN)
STAT_TOMANY EQU 0800aH			;; too manay codepages (DST)
STAT_DUPLCP EQU 0800aH			;; too manay codepages (DST)
STAT_NOCPIV EQU 08007H			;; no codepage designated/invoked
STAT_NOCP EQU	08007H			;; no codepage designated/invoked
					;; (IVK, QIV, QLS)
					;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;	Generic IOCTL Buffer   DS:[SI]
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GIOB	EQU	DS:[SI] 		;;
					;;
struc GB1S;;
GB1_FLAG: dw 0;; flag
GB1_LEN: dw 0;; length
GB1_NUM: dw 0;; length
GB1_CP: dw 0;;
endstruc;;
					;;
					;;
struc GB2S;;
GB2_LEN: dw 0;; length
GB2_CP: dw 0;;
endstruc;;
					;;
					;;
struc GB3S;;
GB3_LEN: dw 0;; length
GB3_GBL: dw 0;; hardware code page number
endstruc;;
					;;
GB3_MINILEN EQU 4			;; minimium length of GB3
					;;
struc GBLS;;
GBL_LEN: dw 0;; length
GBL_CP: dw 0;; hardware code page number
endstruc;;
					;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;	DEVICE	Header	   DS:[SI]	-- to locate the next LPTn header
;;	NEXT device header ES:[DI]
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
HP	EQU	DS:[SI] 		;;
NHD	EQU	ES:[DI] 		;;
					;;
NAME_LEN EQU	8			;;
					;;
struc DHS;;
DH_NEXTO: dw 0;; offset of pointer to next header
DH_NEXTS: dw 0;; segment of pointer to next header
	dw 0;; attribute
DH_STRAO: dw 0;; offset to strategy routine
DH_INTRO: dw 0;; offset to interrupt routine
DH_NAME DB	NAME_LEN DUP(0) 	;; device name in this header
endstruc;; end of common portion
					;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;	FONT_PARSER data
;;
;;	-- Interface table : FTABLE
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					;;
FPKT	EQU	DS:[SI] 		;;
					;;
FTP	EQU	ES:[BX] 		;;
					;; ( I=Input  O=Output )
struc FTBLK;;
FTB_LENGTH DW	TYPE FTBLK		;; (NOT TO BE CHANGED)
FTB_STATUS DW	0FFFFH			;; (O) parsing compelte
FTB_TYPE DW	0			;; (O)
FTB_TID: times 8 db 0;; (I)
FTB_CP	DW	0FFFFH			;; (I)
FTB_MOD DW	0			;; (O)
FTB_FONTS DW	0			;; (O)
FTB_ROWS  DB	0			;; (O) DISPLAY TYPE DEVICE
FTB_COLS  DB	0			;; (O) DISPLAY TYPE DEVICE
FTB_X	  DB	0			;; (O) DISPLAY TYPE DEVICE
FTB_Y	  DB	0			;; (O) DISPLAY TYPE DEVICE
FTB_COUNT DW	0			;; (O) DISPLAY TYPE DEVICE
FTB_SELECT DW	0			;; (O) PRINTER TYPE DEVICE
FTB_SELLEN DW	0			;; (O) PRINTER TYPE DEVICE
FTB_DLEFT DW	0			;; (O)	=0, none to come
FTB_DLEN DW	0			;; (O)	=0, not in this packet
FTB_DALO DW	0			;; (O)	in the DOS "packet" buffer
FTB_DAHI DW	0			;; (O)	"  "   "    "       "
TARGET_LO DW	0			;;  internal registers
TARGET_HI DW	0			;;  internal registers
endstruc;;
					;;
TYPE_DISPLAY EQU 01H			;; display type device
TYPE_PRINTER EQU 02H			;; printer type device
					;;
struc FBUFS;;
FLAG	DW	0			;;
BUFFER_LEN DW	0			;;
BUFFER_ADDR DD	0			;;
NUM_FTBLK DW	0			;; no. of FTBKL entries
endstruc;;
					;;
					;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					;; FLAGS :
FLAG_RESTART EQU 000001H		;; bit 1 = restart the parsing
					;;
					;;
					;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					;; STATUS : (in FTB_STATUS)
					;;
FSTAT_COMPLETE EQU 0FFFFH		;; parsing compeleted. (good status)
FSTAT_FONT  EQU 0FFFEH			;; font data is defined and returned
FSTAT_FOUND EQU 0FFFDH			;; informations including font-length
FSTAT_MATCH EQU 0FFFCH			;; font header matches	FTBLK
FSTAT_SEARCH EQU 0FFFBH 		;; seraching for header & font
FSTAT_BOTTOM EQU 0FFF0H 		;; below this are the DOS_STATUS.
					;;
;; the FSTAT with value lower than 0FFF0H is to be returned to the DOS
					;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;	DEVICE Command Parser Table   ES:[DI]
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					;;
table_len	equ	290		;;
					;;
PSE	EQU	ES:[DI] 		;;
					;;
struc PAR_OT;;
PAR_DEV_NUM: dw 0;;
PAR_OFF: dw 0;;
endstruc;;
					;;
struc PAR_DEVOT;; OFFSET to the parameters of a device
PAR_onum: dw 0;; number of offsets in the table
PAR_DNMO: dw 0;; device-name table offset
PAR_DIDO: dw 0;; device-id table offset
PAR_HWCPO: dw 0;; hwcp table offset
PAR_DESGO: dw 0;; designate table offset
PAR_PARMO: dw 0;; parameter table offset
endstruc;;
					;;
struc PAR_DNMT;; DEVICE NAME table
PAR_DNML: dw 0;; length of device name
PAR_DNM: db 0;; device name
endstruc;;
					;;
struc PAR_DIDT;; DEVICE ID table
PAR_DIDL: dw 0;; device ID length
PAR_DID: db 0;; device ID
endstruc;;
					;;
struc PAR_HWCPT;; hwcp table
PAR_HWCPL: dw 0;; hwcp entry number
PAR_HWCP: dw 0;; hwcp
endstruc;;
					;;
					;;
struc PAR_DESGT;; DESIGNATE table
PAR_DESGL: dw 0;; entry number
PAR_DESG: dw 0;; designate
PAR_FONT: dw 0;; fonts
endstruc;;
					;;
					;;
struc PAR_PARMT;; parameter table
PAR_PARML: dw 0;; length
PAR_PARM: dw 0;;
endstruc;;
					;;
					;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; LPTn	printer data structure	CS:[BX]
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					;;
BUF	EQU	CS:[BX] 		;;
					;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					;; STATES
					;;
NORMAL	EQU	0			;; normal state
CPSW	EQU	1			;;
DESG_WR EQU	2			;; designate write
DESG_END EQU	3			;; designate end
LOCKED	 EQU	4			;; WGR locked
					;;
					;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GOOD	EQU	0			;; STATUS :
REPLX	EQU	8000H			;; codepage replaced in DST
FAIL	EQU	4000H			;; fail in designate
LOADED	EQU	2000H			;; the font has just been loaded to
REFRESH EQU	0800H			;; there was a refresh via DST
					;;
					;; also
					;; -- DSF_CARTCP
					;;
					;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					;;
					;; for BFLAG :
BF_PRN	EQU	0			;;  0 = PRN  initialized (interrupt)
BF_LPT1 EQU	1			;;  1 = LPT1 initialized (interrupt)
BF_LPT2 EQU	2			;;  2 = LPT2 initialized (interrupt)
BF_LPT3 EQU	3			;;  3 = LPT3 initialized (interrupt)
BF_MEM_DONE  EQU 08000H 		;;  memory done for this device
					;;
					;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					;; BUFFER DATA structure
struc BUF_DATA;;.................................
BFLAG	 DW	-1			;; buf flag for initialisation
					;; -1 = buf not yet initialised
					;; (see BF_PRN, BF_LPT's)
					;;
DEV_HDRO DW	-1			;; device driver n header offset
DEV_HDRS DW	-1			;;
LPT_STRAO DW	-1			;; dos lptn strategy offset
LPT_STRAS DW	-1			;;
LPT_INTRO DW	-1			;; dos lptn strategy offset
LPT_INTRS DW	-1			;;
RH_PTRO DW	-1			;; request header offset
RH_PTRS DW	-1			;; segment ....................(unique)
					;;
					;; (following is replicated for LPT1 )
					;;
RNORMO	DW	-1			;; request-normal driver header offset
prn_bufo dw	-1			;; offset to prn buffer
did_prn  dw	 0			;; where PRN is in the DID order
PCLASS	 DW	 0			;;
STATE	DW	NORMAL			;;
STATUS	DW	GOOD			;;
					;; (the followings should be used
					;;  IFF BUT.STATE <> NORMAL : )
					;;
PDESCO	DW	-1			;; offset to printer description table.
					;;
					;;===== hwcp and designated slots ====
HSLMX	DW	0			;; HSLMX is the size of HARDslot (at
					;; HARDSO) and the buffer(at HRBUFO)
					;;
HARDMX	DW	0			;; no. of HWCP+cart slots supported
					;; (less than or equal to .HSLOTS)
HARDSO	DW	-1			;; offset to hardware slots n
					;;
HCARMX	DW	0			;; no. of cart slots supported
HRBUFO	DW	-1			;; offset to cart slots' buffer
					;;
					;;===== physical and designated RAM ===
					;;
RSLMX	DW	0			;; RSLMX is the size of RAMslot (at
					;; RAMSO) and the RAM buffer(at RMBUFO)
					;;
					;;
RAMMX	DW	0			;; no. of physical RAM slots(max.=1)
RAMSO	DW	-1			;; offset to RAM slots(incl. designated
					;;
RBUFMX	DW	0			;; no. of designated RAM slots supported
RMBUFO	DW	-1			;; offset to RAM slots's buffer
					;;
FTSZPA	DW	-1			;; font buffer in paragraph = FONTSZ
FTSIZE	DW	0			;; font buffer size = FTSZPA x 16
FTSTART DW	-1			;; start of font buffer
FTSLOTO DW	-1			;; segment address of font buffer
					;; -- of the one to be designated to
FTDLO	DW	-1			;; offset to where the FTSTART:OFFSET
					;; (next destination = total length
					;;		       so far)
FSELEN	DW	0			;; length of selection control copied
					;; to the selection buffer
					;; (USED BY SELECT TYPE = 1 ONLY)
					;; -- initialized to 0, if selection
					;;    is not 0, copied the selection
					;;    from the font file until the
					;;    length is reached. After copying
					;;    to selection buffer, reset to 0
FSELMAX DW	0			;; max. room reserved for selection
					;; controls.
					;;
PAR_EXTRACTO DB (TYPE PAR_DEVOT) DUP (-1);; Offset to parameter extracts
SAVED_CP    DW	-1			;; WGR saved code page during lock	    ;AN000;
BUFEND	DW	0			;; END OF BUFFER, for LPT1 copy.
endstruc;;
					;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;	Printer Description Table
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					;;
DEVN_LEN EQU	8			;; device name (type-id) length
					;;
struc PDSH;;
PD_LEN	DW	30			;; length of each entry
TYPEID	DB	'        '              ;; device name (id), length DEVN_LEN
VMINOR	DB	0			;; version :  .00
VMAJOR	DB	1			;; version : 1.
CLASS: dw 0;; reserved
FONTSZ: dw 0;; font buffer size in paragraph (max)
HSLOTS: dw 0;; hard-slots number (max # of Hslots)
HWCPMIN: dw 0;; what left by min_hwcp can be cart.
RSLOTS: dw 0;; ram-slots number  (max # of Rslots)
endstruc;; the SELH_O, and SELR_O are defined
					;; in the next two entries in PDS
					;;
					;;
struc PDS;;
	DB	(TYPE PDSH) DUP (?)	;; common portion
SELH_O: dw 0;; offset to select controls on Hslots
SELR_O: dw 0;; offset to select controls on Rslots
SELB_O: dw 0;; offset to buffered select controls
endstruc;;
					;;
					;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;	HARD / RAM slots table structure/constants
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					;; NOTE : must be only FOUR bytes for
					;;	  codepage positioning
					;;	  calculation as compared
					;;	  with each entry in FTDL_OFF
					;;
struc SLTS;; slots-table structure
SLT_CP	DW	-1			;; code page : no code page
SLT_AT	DW	0			;; attribute : empty
endstruc;;
					;;
					;; ATTRIBUTES :
AT_RAM1 EQU	 00001H 		;; in the 1st physical RAM slot
AT_RAM2 EQU	 00002H 		;; in the 2nd physical RAM slot
AT_RAM3 EQU	 00004H 		;; in the 3rd physical RAM slot
AT_RAM4 EQU	 00008H 		;; in the 4th physical RAM slot
AT_RAMS EQU	 0000FH 		;;(note the current logic supports
					;; only ONE physical RAM slot)
					;;
AT_OCC	EQU	 01000H 		;; slot occupied
AT_ACT	EQU	 02000H 		;; slot active
AT_HWCP EQU	 04000H 		;; slot is hwcp
AT_OLD	EQU	 08000H 		;; codepage in buffer is not newly
					;; designated.
AT_LOAD EQU	 00100H 		;; slot with font to be loaded
AT_FONT EQU	 00200H 		;; font in this slot has been loaded
AT_NO_LOAD	EQU	NOT  AT_LOAD	;; to reset the bit
AT_NO_FONT	EQU	NOT  AT_FONT	;; to reset the bit
AT_SELECT EQU	 00400H 		;; for SELECT TYPE = 1
					;; -- mark the FTBLK where control is
					;;    copied from.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					;; constants on SLOTS
HARDSL_MAX EQU	12			;;
					;;
RAMSL_MAX EQU	12			;;
					;;
CTL_MAX 	EQU	32		;; max.length of each selection control
CTL5202_OFFS	EQU	8		;; offset to CTL5202_H for codepage
					;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;	General Constants
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					;;
STACK_SIZE	EQU	28H		;; in paragraph, total 200H bytes
					;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
; STRUCS AND EQUATES
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					;;
struc PARSE_NAME;;					    ;AN000;
N_LENGTH: dw 0;;					    ;AN000;
FNAME	      DB    "        "          ;;                                          ;AN000;
endstruc;;					    ;AN000;
					;;
struc PARSE_OFFSETS;;					    ;AN000;
	      dw 0;;					    ;AN000;
DN_OFFSET: dw 0;;					    ;AN000;
DI_OFFSET: dw 0;;					    ;AN000;
DCP_OFFSET: dw 0;;					    ;AN000;
DD_OFFSET: dw 0;;					    ;AN000;
	      dw 0;;					    ;AN000;
endstruc;;					    ;AN000;
					;;
struc PARSE_HWCP;;					    ;AN000;
NUM_HWCPS: dw 0;;					    ;AN000;
HWCP_1: dw 0;;					    ;AN000;
HWCP_2: dw 0;;					    ;AN000;
HWCP_3: dw 0;;					    ;AN000;
HWCP_4: dw 0;;					    ;AN000;
HWCP_5: dw 0;;					    ;AN000;
HWCP_6: dw 0;;					    ;AN000;
HWCP_7: dw 0;;					    ;AN000;
HWCP_8: dw 0;;					    ;AN000;
HWCP_9: dw 0;;					    ;AN000;
HWCP_10: dw 0;;					    ;AN000;
endstruc;;					    ;AN000;
					;;
struc PARSE_DESG;;					    ;AN000;
NUM_VALUES: dw 0;;					    ;AN000;
NUM_DESGS: dw 0;;					    ;AN000;
NUM_FONTS: dw 0;;					    ;AN000;
endstruc;;					    ;AN000;
					;;
					;;
ZERO	EQU	0H			;;					    ;AN000;
ONE	EQU	1H			;;					    ;AN000;
TWO	EQU	2H			;;					    ;AN000;
THREE	EQU	3H			;;					    ;AN000;
FOUR	EQU	4H			;;					    ;AN000;
FIVE	EQU	5H			;;					    ;AN000;
SIX	EQU	6H			;;					    ;AN000;
SEVEN	EQU	7H			;;					    ;AN000;
EIGHT	EQU	8H			;;					    ;AN000;
NINE	EQU	9H			;;					    ;AN000;
TEN	EQU    0AH			;;					    ;AN000;
NUMBER	      EQU    1			;;					    ;AN000;
STRING	      EQU    3			;;					    ;AN000;
COMPLEX       EQU    4			;;					    ;AN000;
RC_EOL	      EQU    -1 		;;					    ;AN000;
RC_NO_ERROR   EQU    0			;;					    ;AN000;
RC_OP_MISSING EQU    2			;;					    ;AN000;
ON	      EQU    1			;;					    ;AN000;
OFF	      EQU    0			;;					    ;AN000;
BAD_SYNTAX_MSG EQU   12 		;;					    ;AN000;
BAD_DEVICE_MSG EQU   2			;;					    ;AN000;
;

