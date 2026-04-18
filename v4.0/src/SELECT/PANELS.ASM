;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
;
;	PANELS.ASM
;
;
;
;
;
;
; CODE Segment
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; .alpha; arrange segments alphabetically

	%include "SEL-PAN.INC";AN024;
	%include "PAN-LIST.INC";AN024;
					;
	global PCB_VECTOR;AN024;
	global NUM_PCB;AN024;
					;
PANEL	EQU	1			;AN024;
SCROLL	EQU	0			;AN024;
					;
SECTION .CODE;AN024;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Panel Control Block Vector
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB_VECTOR:;AC024;
	DW	0,PCB1		;AC024;PCB1  segment, offset
	DW	0,PCB2		;AC024;PCB2  segment, offset
	DW	0,PCB3		;AC024;PCB3  segment, offset
	DW	0,PCB4		;AC024;PCB4  segment, offset
	DW	0,PCB5		;AC024;PCB5  segment, offset
	DW	0,PCB6		;AC024;PCB6  segment, offset
	DW	0,PCB7		;AC024;PCB7  segment, offset
	DW	0,PCB8		;AC024;PCB8  segment, offset
	DW	0,PCB9		;AC024;PCB9 segment, offset
	DW	0,PCB10		;AC024;PCB10 segment, offset
	DW	0,PCB11		;AC024;PCB11 segment, offset
	DW	0,PCB12		;AC024;PCB12 segment, offset
	DW	0,PCB13		;AC024;PCB13 segment, offset
	DW	0,PCB14		;AC024;PCB14 segment, offset
	DW	0,PCB15		;AC024;PCB15 segment, offset
	DW	0,PCB16		;AC024;PCB16 segment, offset
	DW	0,PCB17		;AC024;PCB17 segment, offset
	DW	0,PCB18		;AC024;PCB18 segment, offset
	DW	0,PCB19		;AC024;PCB19 segment, offset
	DW	0,PCB20		;AC024;PCB20 segment, offset
	DW	0,PCB21		;AC024;PCB21 segment, offset
	DW	0,PCB22		;AC024;PCB22 segment, offset
	DW	0,PCB23		;AC024;PCB23 segment, offset
	DW	0,PCB24		;AC024;PCB24 segment, offset
	DW	0,PCB25		;AC024;PCB25 segment, offset
	DW	0,PCB26		;AC024;PCB26 segment, offset
	DW	0,PCB27		;AC024;PCB27 segment, offset
	DW	0,PCB28		;AC024;PCB28 segment, offset
	DW	0,PCB29		;AC024;PCB29 segment, offset
	DW	0,PCB30		;AC024;PCB30 segment, offset
	DW	0,PCB31		;AC024;PCB31 segment, offset
	DW	0,PCB32		;AC024;PCB32 segment, offset
	DW	0,PCB33		;AC024;PCB33 segment, offset
	DW	0,PCB34		;AC024;PCB34 segment, offset
	DW	0,PCB35		;AC024;PCB35 segment, offset
	DW	0,PCB36		;AC024;PCB36 segment, offset
	DW	0,PCB37		;AC024;PCB37 segment, offset
	DW	0,PCB38		;AC024;PCB38 segment, offset
	DW	0,PCB39		;AC024;PCB39 segment, offset
	DW	0,PCB40		;AC024;PCB40 segment, offset
	DW	0,PCB41		;AC024;PCB41 segment, offset
	DW	0,PCB42		;AC024;PCB42 segment, offset
	DW	0,PCB43		;AC024;PCB43 segment, offset
	DW	0,PCB44		;AC024;PCB44 segment, offset
	DW	0,PCB45		;AC024;PCB45 segment, offset
	DW	0,PCB46		;AC024;PCB46 segment, offset
	DW	0,PCB47		;AC024;PCB47 segment, offset
	DW	0,PCB48		;AC024;PCB48 segment, offset
	DW	0,PCB49		;AC024;PCB49 segment, offset
	DW	0,PCB50		;AC024;PCB50 segment, offset
	DW	0,PCB51		;AC024;PCB51 segment, offset
	DW	0,PCB52		;AC024;PCB52 segment, offset
	DW	0,PCB53		;AC024;PCB53 segment, offset
	DW	0,PCB54		;AC024;PCB54 segment, offset
	DW	0,PCB55		;AC024;PCB55 segment, offset
	DW	0,PCB56		;AC024;PCB56 segment, offset
	DW	0,PCB57		;AC024;PCB57 segment, offset
	DW	0,PCB58		;AC024;PCB58 segment, offset
	DW	0,PCB59		;AC024;PCB59 segment, offset
	DW	0,PCB60		;AC024;PCB60 segment, offset
	DW	0,PCB61		;AC024;PCB61 segment, offset
	DW	0,PCB62		;AC024;PCB62 segment, offset
	DW	0,PCB63		;AC024;PCB63 segment, offset
	DW	0,PCB64		;AC024;PCB64 segment, offset
	DW	0,PCB65		;AC024;PCB65 segment, offset
	DW	0,PCB66		;AC024;PCB66 segment, offset
	DW	0,PCB67		;AC024;PCB67 segment, offset
	DW	0,PCB68		;AC024;PCB68 segment, offset
	DW	0,PCB69		;AC024;PCB69 segment, offset
	DW	0,PCB70		;AC024;PCB70 segment, offset
	DW	0,PCB71		;AC024;PCB71 segment, offset
	DW	0,PCB72		;AC024;PCB72 segment, offset
	DW	0,PCB73		;AC024;PCB73 segment, offset
	DW	0,PCB74		;AC024;PCB74 segment, offset
	DW	0,PCB75		;AC024;PCB75 segment, offset
	DW	0,PCB76		;AC024;PCB76 segment, offset
	DW	0,PCB77		;AC024;PCB77 segment, offset
	DW	0,PCB78		;AC024;PCB78 segment, offset
	DW	0,PCB79		;AC024;PCB79 segment, offset
	DW	0,PCB80		;AC024;PCB80 segment, offset
	DW	0,PCB81		;AC024;PCB81 segment, offset
	DW	0,PCB82		;AC024;PCB82 segment, offset
	DW	0,PCB83		;AC024;PCB82 segment, offset
	DW	0,PCB84		;AC024;PCB84 segment, offset
	DW	0,PCB85		;AC024;PCB85 segment, offset
	DW	0,PCB86		;AC024;PCB86 segment, offset
	DW	0,PCB87		;AC024;PCB87 segment, offset
	DW	0,PCB88		;AC024;PCB88 segment, offset
	DW	0,PCB89		;AC024;PCB89 segment, offset
	DW	0,PCB90		;AC024;PCB90 segment, offset
	DW	0,PCB91		;AC024;PCB91 segment, offset
	DW	0,PCB92		;AC024;PCB92 segment, offset
	DW	0,PCB93		;AC024;PCB93 segment, offset
	DW	0,PCB94		;AC024;PCB94 segment, offset
	DW	0,PCB95		;AC024;PCB95 segment, offset
	DW	0,PCB96		;AC024;PCB96 segment, offset
	DW	0,PCB97		;AC024;PCB97 segment, offset
	DW	0,PCB98		;AC024;PCB98 segment, offset
	DW	0,PCB99		;AC024;PCB99 segment, offset
	DW	0,PCB100		;AC024;PCB100 segment, offset
	DW	0,PCB101		;AC024;PCB101 segment, offset
	DW	0,PCB102		;AC024;PCB102 segment, offset
	DW	0,PCB103		;AC024;PCB102 segment, offset
NUM_PCB        EQU	($-PCB_VECTOR)/4;AN024;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_WELCOME	EQU	1		; Welcome Screen
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB1:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW     (80-PANEL1_W)/2	;AN000;column location of panel
	DW	PANEL1_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW     PANEL1_W*PANEL1_L;AN000;Length expanded panel in mem
	DW	PANEL1	;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	2		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;

CHILD2:;AN000;
	DW	CHILD_ENTER	;AN000;child PCB element number
	DW	25		;AN000;row override
	DW	1		;AN000;column override
	DW	BLACK_WHITE	;AN000;color index pointer override
	DW	9		;AN000;function key attribute
	DB 0,0; ENTER,0 	;AN000;keystroke associated with child
	DW	CHD_ABS 	;AN000;option word

	DW	CHILD_QUIT	;AN000;child PCB element number
	DW	25		;AN000;row override
	DW	PANEL52_W+3	;AN000;column override
	DW	BLACK_WHITE	;AN000;color index pointer override
	DW	9		;AN000;function key attribute
	DB 0,0; ESCAPE,0	;AN000;keystroke associated with child
	DW	CHD_ABS 	;AN000;option word

	DW	CHILD_F1HELP	;AN000;child PCB element number
	DW	25		;AN000;row override
	DW	PANEL52_W+3+PANEL51_W+2 ;AC028;column override
	DW	BLACK_WHITE	;AN000;color index pointer override
	DW	9		;AN000;function key attribute
	DB 0,0; 0,F1		;AN000;keystroke associated with child
	DW	CHD_ABS 	;AN000;option word
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_INTRO	EQU	2		; Introduction Screen
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB2:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL2_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW     PANEL2_W*PANEL2_L;AN000;Length expanded panel in mem
	DW	PANEL2	;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	2		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_CONFIRM	EQU	3		; Confirmation Screen
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB3:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW     (80-PANEL3_W)/2	;AN000;column location of panel
	DW	PANEL3_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW     PANEL3_W*PANEL3_L;AN000;Length expanded panel in mem
	DW	PANEL3	;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	2		;AN000;Number of child panel entries
	DW	CHILD4	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds

CHILD4:;AN000;
	DW	CHILD_F3EXIT	;AN000;child PCB element number
	DW	25		;AN000;row override
	DW	1		;AN000;column override
	DW	WHITE_RED	;AN000;color index pointer override
	DW	9		;AN000;function key attribute
	DB  0,0; 0,F3		;AN000;keystroke associated with child
	DW	CHD_ABS 	;AN000;option word

	DW	CHILD_ENTER	;AN000;child PCB element number
	DW	25		;AN000;row override
	DW	PANEL40_W+3	;AN000;column override
	DW	WHITE_RED	;AN000;color index pointer override
	DW	9		;AN000;function key attribute
	DB  0,0; 13,0		;AN000;keystroke associated with child
	DW	CHD_ABS 	;AN000;option word
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_WORKSPACE EQU	4		; User memory needs screen
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB4:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL4_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW     PANEL4_W*PANEL4_L;AN000;Length expanded panel in mem
	DW	PANEL4	;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	3		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_CTY_KYB	  EQU	   5	  ;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB5:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL5_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW     PANEL5_W*PANEL5_L;AN000;Length expanded panel in mem
	DW	PANEL5	;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	3		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_COUNTRY	  EQU	   6	  ;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB6:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL6_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW     PANEL6_W*PANEL6_L;AN000;Length expanded panel in mem
	DW	PANEL6	;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	3		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_KEYBOARD	  EQU	   7	  ;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB7:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL7_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW     PANEL7_W*PANEL7_L;AN000;Length expanded panel in mem
	DW	PANEL7	;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	3		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_KYBD_ALT	  EQU	   8	  ;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB8:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL8_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW     PANEL8_W*PANEL8_L;AN000;Length expanded panel in mem
	DW	PANEL8	;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	3		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_DEST_DRIVE  EQU	  9	  ;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB9:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL9_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL9_W*PANEL9_L	;AN000;Length expanded panel in mem
	DW	PANEL9	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	3		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_DOS_LOC	  EQU	  10	  ;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB10:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL10_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL10_W*PANEL10_L;AN000;Length expanded panel in mem
	DW	PANEL10	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	3		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_PRINTER	  EQU	  11	  ;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB11:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL11_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL11_W*PANEL11_L;AN000;Length expanded panel in mem
	DW	PANEL11	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	3		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_PRT_TYPE	  EQU	  12	  ;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB12:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL12_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL12_W*PANEL12_L;AN000;Length expanded panel in mem
	DW	PANEL12	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	3		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_PARALLEL	  EQU	  13	  ;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB13:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL13_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL13_W*PANEL13_L;AN000;Length expanded panel in mem
	DW	PANEL13	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	3		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_SERIAL	  EQU	  14	  ;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB14:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL14_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL14_W*PANEL14_L;AN000;Length expanded panel in mem
	DW	PANEL14	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	3		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_REVIEW	  EQU	  15	  ;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB15:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL15_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL15_W*PANEL15_L;AN000;Length expanded panel in mem
	DW	PANEL15	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	3		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_FUNC_DISK   EQU	  16	  ;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB16:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL16_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL16_W*PANEL16_L;AN000;Length expanded panel in mem
	DW	PANEL16	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	3		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; err_prt_no_hdwr EQU	  17	  ;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB17:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	11		;AN000;row location of panel
	DW	LEFT_COL+1	;AN000;column location of panel
	DW	PANEL17_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_RED	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL17_W*PANEL17_L;AN000;Length expanded panel in mem
	DW	PANEL17	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_DOS_PARAM   EQU	  18	  ;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB18:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL18_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL18_W*PANEL18_L;AN000;Length expanded panel in mem
	DW	PANEL18	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	3		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_SHELL	  EQU	  19	  ;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB19:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL19_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL19_W*PANEL19_L;AN000;Length expanded panel in mem
	DW	PANEL19	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	3		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; ERR_EXIT
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB20:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	11		;AN000;row location of panel
	DW	LEFT_COL+1	;AN000;column location of panel
	DW	PANEL20_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_RED	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL20_W*PANEL20_L;AN000;Length expanded panel in mem
	DW	PANEL20	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_FASTOPEN	  EQU	  21	  ;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB21:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL21_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL21_W*PANEL21_L;AN000;Length expanded panel in mem
	DW	PANEL21	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	3		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_SHARE	  EQU	  22	  ;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB22:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL22_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL22_W*PANEL22_L;AN000;Length expanded panel in mem
	DW	PANEL22	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	3		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_GRAPHICS	  EQU	  23	  ;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB23:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL23_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL23_W*PANEL23_L;AN000;Length expanded panel in mem
	DW	PANEL23	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	3		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_EXP_MEMORY  EQU	  24	  ;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB24:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL24_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL24_W*PANEL24_L;AN000;Length expanded panel in mem
	DW	PANEL24	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	3		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_VDISK	  EQU	  25	  ;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB25:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL25_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL25_W*PANEL25_L;AN000;Length expanded panel in mem
	DW	PANEL25	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	3		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_CONFIG_PARS EQU	  26	  ;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB26:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL26_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL26_W*PANEL26_L;AN000;Length expanded panel in mem
	DW	PANEL26	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	3		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_FIXED_FIRST EQU	  27	  ;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB27:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL27_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL27_W*PANEL27_L;AN000;Length expanded panel in mem
	DW	PANEL27	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	3		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_FIXED_BOTH  EQU	  28	  ;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB28:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL28_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL28_W*PANEL28_L;AN000;Length expanded panel in mem
	DW	PANEL28	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	3		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_REBOOT	  EQU	  29	  ;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB29:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	4		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL29_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL29_W*PANEL29_L;AN000;Length expanded panel in mem
	DW	PANEL29	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	3		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_date_time   EQU	  30	  ;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB30:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL30_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL30_W*PANEL30_L;AN000;Length expanded panel in mem
	DW	PANEL30	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	2		;AN000;Number of child panel entries
	DW	CHILD31	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds

CHILD31:;AN000;
	DW	CHILD_ENTER	;AN000;child PCB element number
	DW	25		;AN000;row override
	DW	1		;AN000;column override
	DW	BLACK_WHITE	;AN000;color index pointer override
	DW	9		;AN000;function key attribute
	DB 0,0; ENTER,0 	;AN000;keystroke associated with child
	DW	CHD_ABS 	;AN000;option word

	DW	CHILD_F1HELP	;AN000;child PCB element number
	DW	25		;AN000;row override
	DW	17		;AC087;SEH increased for translation space ;AN000;column override
	DW	BLACK_WHITE	;AN000;color index pointer override
	DW	9		;AN000;function key attribute
	DB 0,0; 0,F1		;AN000;keystroke associated with child
	DW	CHD_ABS 	;AN000;option word

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_FORMAT	  EQU	  31	  ;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB31:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL31_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL31_W*PANEL31_L;AN000;Length expanded panel in mem
	DW	PANEL31	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	2		;AN000;Number of child panel entries
	DW	CHILD31	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_INST_PROMPT EQU	  32	  ;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB32:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL+12	;AN000;column location of panel
	DW	PANEL32_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL32_W*PANEL32_L;AN000;Length expanded panel in mem
	DW	PANEL32	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	1		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; err_keyb    EQU      33      ;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB33:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	11		;AN000;row location of panel
	DW	LEFT_COL+3	 ;AN000;column location of panel
	DW	PANEL33_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_RED	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL33_W*PANEL33_L;AN000;Length expanded panel in mem
	DW	PANEL33	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_COMPLETE_1  EQU	  34	  ;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB34:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL+12	;AC028;column location of panel
	DW	PANEL34_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL34_W*PANEL34_L;AN000;Length expanded panel in mem
	DW	PANEL34	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	1		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_COMP_KYS_1C   EQU     35	    ;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB35:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	left_col+7	;AC028;column location of panel
	DW	PANEL35_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL35_W*PANEL35_L;AN000;Length expanded panel in mem
	DW	PANEL35	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; contextual help
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB36:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL36_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	BLACK_WHITE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL36_W*PANEL36_L;AN000;Length expanded panel in mem
	DW	PANEL36	;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	3		;AN000;Number of child panel entries
	DW	CHILD37	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
				;

CHILD37:;AN000;
	DW	CHILD_QUIT	;AN000;child PCB element number
	DW	PANEL36_L-1	;AN000;row override
	DW	2		;AN000;column override
	DW	BLACK_WHITE	;AN000;color index pointer override
	DW	9		;AN000;function key attribute
	DB	27,0		;AN000;keystroke associated with child
	DW	0 ;CHD_ABS	;AN000;option word

	DW	CHILD_F1HELP	;AN000;child PCB element number
	DW	PANEL36_L-1	;AN000;row override
	DW	16		;AC081;SEH ;AN000;column override
	DW	BLACK_WHITE	;AN000;color index pointer override
	DW	9		;AN000;function key attribute
	DB	0,F1		;AN000;keystroke associated with child
	DW	0 ;CHD_ABS	;AN000;option word

	DW	CHILD_F9KEYS	;AN000;child PCB element number
	DW	PANEL36_L-1	;AN000;row override
	DW	30		;AC081;SEH ;AN000;column override
	DW	BLACK_WHITE	;AN000;color index pointer override
	DW	9		;AN000;function key attribute
	DB	0,F9		;AN000;keystroke associated with child
	DW	0 ;CHD_ABS	;AN000;option word
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; HORIZONTAL BAR
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB37:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	24		;AN000;row location of panel
	DW	1		;AN000;column location of panel
	DW	PANEL37_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL37_W*PANEL37_L;AN000;Length expanded panel in mem
	DW	PANEL37	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_CONT_OPTION	EQU 38
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB38:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	22		;AN000;row location of panel
	DW   (80-PANEL38_W)/2	;AN000;column location of panel
	DW	PANEL38_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL38_W*PANEL38_L;AN000;Length expanded panel in mem
	DW	PANEL38	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_PRINTER_1
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB39:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	4		;AN000;row location of panel
	DW	left_col	;AN000;column location of panel
	DW	PANEL39_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL39_W*PANEL39_L;AN000;Length expanded panel in mem
	DW	PANEL39	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; CHILD F3=Exit
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB40:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL40_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL40_W*PANEL40_L;AN000;Length expanded panel in mem
	DW	PANEL40	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_FIXED_1
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB41:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	4		;AN000;row location of panel
	DW	left_col	;AN000;column location of panel
	DW	PANEL41_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL41_W*PANEL41_L;AN000;Length expanded panel in mem
	DW	PANEL41	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_LOG_DRIVE EQU 42	;AN000;JW
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB42:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	5		;AC000;row location of panel  JW
	DW	left_col	;AN000;column location of panel
	DW	PANEL42_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL42_W*PANEL42_L;AN000;Length expanded panel in mem
	DW	PANEL42	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_REBOOT_KEYS
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB43:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	21		;AN000;row location of panel
	DW	left_col	;AN000;column location of panel
	DW	PANEL43_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL43_W*PANEL43_L;AN000;Length expanded panel in mem
	DW	PANEL43	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_INSTALL_1
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB44:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	left_col	;AN000;column location of panel
	DW	PANEL44_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL44_W*PANEL44_L;AN000;Length expanded panel in mem
	DW	PANEL44	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_INSTALL_2
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB45:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	left_col	;AN000;column location of panel
	DW	PANEL45_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL45_W*PANEL45_L;AN000;Length expanded panel in mem
	DW	PANEL45	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_COMP_VER
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB46:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	left_col+7	;AC028;column location of panel
	DW	PANEL46_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL46_W*PANEL46_L;AN000;Length expanded panel in mem
	DW	PANEL46	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_KEYS_1
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB47:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	21		;AN000;row location of panel
	DW	left_col+5	;AN028;column location of panel
	DW	PANEL47_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL47_W*PANEL47_L;AN000;Length expanded panel in mem
	DW	PANEL47	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_KEYS_2
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB48:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	left_col+7	;AC028;column location of panel
	DW	PANEL48_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL48_W*PANEL48_L;AN000;Length expanded panel in mem
	DW	PANEL48	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; CHILD F1=HELP
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB49:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL49_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL49_W*PANEL49_L;AN000;Length expanded panel in mem
	DW	PANEL49	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; CHILD F9=keys
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB50:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL50_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL50_W*PANEL50_L;AN000;Length expanded panel in mem
	DW	PANEL50	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; CHILD esc
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB51:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL51_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL51_W*PANEL51_L;AN000;Length expanded panel in mem
	DW	PANEL51	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; CHILD ENTER
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB52:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL52_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL52_W*PANEL52_L;AN000;Length expanded panel in mem
	DW	PANEL52	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_COMP_REP
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB53:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	left_col+7	;AC028;column location of panel
	DW	PANEL53_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL53_W*PANEL53_L;AN000;Length expanded panel in mem
	DW	PANEL53	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; ERROR PANEL 1
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB54:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	11		;AN000;row location of panel
	DW	LEFT_COL+3	 ;AN000;column location of panel
	DW	PANEL54_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_RED	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL54_W*PANEL54_L;AN000;Length expanded panel in mem
	DW	PANEL54	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; ERROR PANEL 2
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB55:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	11		;AN000;row location of panel
	DW	LEFT_COL+3	 ;AN000;column location of panel
	DW	PANEL55_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_RED	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL55_W*PANEL55_L;AN000;Length expanded panel in mem
	DW	PANEL55	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; ERROR PANEL 3
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB56:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	11		;AN000;row location of panel
	DW	LEFT_COL+3	 ;AN000;column location of panel
	DW	PANEL56_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_RED	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL56_W*PANEL56_L;AN000;Length expanded panel in mem
	DW	PANEL56	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; ERROR PANEL 4
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB57:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	11		;AN000;row location of panel
	DW	LEFT_COL+3	 ;AN000;column location of panel
	DW	PANEL57_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_RED	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL57_W*PANEL57_L;AN000;Length expanded panel in mem
	DW	PANEL57	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_INS_START_B
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB58:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL58_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL58_W*PANEL58_L;AN000;Length expanded panel in mem
	DW	PANEL58	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_REM_SEL_A
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB59:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL59_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL59_W*PANEL59_L;AN000;Length expanded panel in mem
	DW	PANEL59	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_REM_START_B
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB60:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL60_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL60_W*PANEL60_L;AN000;Length expanded panel in mem
	DW	PANEL60	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_REM_DOS_A
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB61:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL61_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL61_W*PANEL61_L;AN000;Length expanded panel in mem
	DW	PANEL61	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; ERR_BAD_PATH
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB62:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	11		;AN000;row location of panel
	DW	LEFT_COL+1	;AN000;column location of panel
	DW	PANEL62_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_RED	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL62_W*PANEL62_L;AN000;Length expanded panel in mem
	DW	PANEL62	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; ERR_BAD_PRT_FILE
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB63:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	11		;AN000;row location of panel
	DW	LEFT_COL+1	;AN000;column location of panel
	DW	PANEL63_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_RED	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL63_W*PANEL63_L;AN000;Length expanded panel in mem
	DW	PANEL63	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; ERR_BAD_PRT_PROFILE
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB64:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	11		;AN000;row location of panel
	DW	LEFT_COL+1	;AN000;column location of panel
	DW	PANEL64_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_RED	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL64_W*PANEL64_L;AN000;Length expanded panel in mem
	DW	PANEL64	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; FORMAT_DISK
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB65:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL65_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL65_W*PANEL65_L;AN000;Length expanded panel in mem
	DW	PANEL65	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; FORMAT_DISKETTE
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB66:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL66_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL66_W*PANEL66_L;AN000;Length expanded panel in mem
	DW	PANEL66	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; ERR_border
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB67:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	10		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL67_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_RED	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL67_W*PANEL67_L;AN000;Length expanded panel in mem
	DW	PANEL67	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	2		;AN000;Number of child panel entries
	DW	CHILD68	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds

CHILD68:;AN000;
	DW	CHILD_F3EXIT	;AN000;child PCB element number
	DW	PANEL67_L-1	;AN000;row override
	DW	2		;AN000;column override
	DW	WHITE_RED	;AN000;color index pointer override
	DW	9		;AN000;function key attribute
	DB	0,F3		;AN000;keystroke associated with child
	DW	0 ;CHD_ABS	;AN000;option word

	DW	CHILD_ENTER	;AN000;child PCB element number
	DW	PANEL67_L-1	;AN000;row override
	DW	16		;AN000;column override
	DW	WHITE_RED	;AN000;color index pointer override
	DW	9		;AN000;function key attribute
	DB	13,0		;AN000;keystroke associated with child
	DW	0 ;CHD_ABS	;AN000;option word
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; ERR_DOS_DISK
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB68:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	11		;AN000;row location of panel
	DW	LEFT_COL+1	;AN000;column location of panel
	DW	PANEL68_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_RED	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL68_W*PANEL68_L;AN000;Length expanded panel in mem
	DW	PANEL68	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; ERR_INSTALL
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB69:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	11		;AN000;row location of panel
	DW	LEFT_COL+1	;AN000;column location of panel
	DW	PANEL69_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_RED	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL69_W*PANEL69_L;AN000;Length expanded panel in mem
	DW	PANEL69	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_DISKCOPY
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB70:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	4		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL70_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL70_W*PANEL70_L;AN000;Length expanded panel in mem
	DW	PANEL70	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	2		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_DSKCPY_SRC
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB71:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL71_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL71_W*PANEL71_L;AN000;Length expanded panel in mem
	DW	PANEL71	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	1		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_DSKCPY_TAR
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB72:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL72_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL72_W*PANEL72_L;AN000;Length expanded panel in mem
	DW	PANEL72	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	1		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_DSKCPY_CPY
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB73:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL73_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL73_W*PANEL73_L;AN000;Length expanded panel in mem
	DW	PANEL73	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_PARTIAL
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB74:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	6		;AN000;row location of panel
	DW	left_col+7	;AC028;column location of panel
	DW	PANEL74_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL74_W*PANEL74_L;AN000;Length expanded panel in mem
	DW	PANEL74	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; FORMAT_DISKETTE  (SINGLE DRIVE - SHELL)
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB75:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL75_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL75_W*PANEL75_L;AN000;Length expanded panel in mem
	DW	PANEL75	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; FORMAT_DISKETTE   (SINGLE DRIVE - STARTUP)
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB76:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL76_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL76_W*PANEL76_L;AN000;Length expanded panel in mem
	DW	PANEL76	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_REM_SHELL_360
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB77:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL77_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL77_W*PANEL77_L;AN000;Length expanded panel in mem
	DW	PANEL77	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_REM_SELECT_360
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB78:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL78_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL78_W*PANEL78_L;AN000;Length expanded panel in mem
	DW	PANEL78	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_REM_UTIL1_360
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB79:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL79_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL79_W*PANEL79_L;AN000;Length expanded panel in mem
	DW	PANEL79	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_COPYING
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB80:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL80_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL80_W*PANEL80_L;AN000;Length expanded panel in mem
	DW	PANEL80	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_INS_WORK1_360
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB81:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL81_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL81_W*PANEL81_L;AN000;Length expanded panel in mem
	DW	PANEL81	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	1		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_INS_WORK2_360
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB82:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL82_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL82_W*PANEL82_L;AN000;Length expanded panel in mem
	DW	PANEL82	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	1		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_INS_SHELL_360
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB83:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL83_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL83_W*PANEL83_L;AN000;Length expanded panel in mem
	DW	PANEL83	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	1		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_INS_START_360
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB84:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL84_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL84_W*PANEL84_L;AN000;Length expanded panel in mem
	DW	PANEL84	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	1		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_INS_INSTALL_360
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB85:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL85_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL85_W*PANEL85_L;AN000;Length expanded panel in mem
	DW	PANEL85	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	1		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_INS_WORK1_S360   EQU 86	  ;AN000;DT 1 drive 360 installation
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB86:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL86_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL86_W*PANEL86_L;AN000;Length expanded panel in mem
	DW	PANEL86	;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	1		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_INS_WORK2_S360   EQU 87	  ;AN000;DT
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB87:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL87_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL87_W*PANEL87_L;AN000;Length expanded panel in mem
	DW	PANEL87	;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	1		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_INS_SHELL_S360   EQU 88	  ;AN000;DT	    "
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB88:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL88_W      ;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL88_W*PANEL88_L ;AN000;Length expanded panel in mem
	DW	PANEL88 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	1		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_INS_STARTT_S360	EQU 89	   ;AN000;DT	     "
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB89:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL89_W      ;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL89_W*PANEL89_L ;AN000;Length expanded panel in mem
	DW	PANEL89 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	1		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_START360
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB90:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL90_W      ;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL90_W*PANEL90_L ;AN000;Length expanded panel in mem
	DW	PANEL90 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	1		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_COMPLETE3
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB91:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	left_col+7	;AC028;column location of panel
	DW	PANEL91_W      ;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL91_W*PANEL91_L ;AN000;Length expanded panel in mem
	DW	PANEL91 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_INSTALL_COPY
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB92:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL92_W      ;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL92_W*PANEL92_L ;AN000;Length expanded panel in mem
	DW	PANEL92 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_SHELL_HD
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB93:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL93_W      ;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL93_W*PANEL93_L;AN000;Length expanded panel in mem
	DW	PANEL93 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_EXP_MEMORY2 EQU	  94	  ;AN000;JW
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB94:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL94_W      ;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW PANEL94_W*PANEL94_L;AN000;Length expanded panel in mem
	DW	PANEL94 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	3		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_START720
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB95:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL95_W      ;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL95_W*PANEL95_L ;AN000;Length expanded panel in mem
	DW	PANEL95 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	1		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_START1440
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB96:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL96_W      ;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL96_W*PANEL96_L ;AN000;Length expanded panel in mem
	DW	PANEL96 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	1		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; ERR_INS_INSTALL
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB97:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	11		;AN000;row location of panel
	DW	LEFT_COL+1	;AN000;column location of panel
	DW	PANEL97_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_RED	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL97_W*PANEL97_L;AN000;Length expanded panel in mem
	DW	PANEL97	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	0		;AN000;Number of child panel entries
	DW	0		;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PAN_CHOOSE_SHELL  EQU	  98	  ;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB98:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	1		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL98_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL98_W*PANEL98_L;AN000;Length expanded panel in mem
	DW	PANEL98	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	3		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_INS_WORKING_A equ 99
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB99:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL99_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL99_W*PANEL99_L;AN000;Length expanded panel in mem
	DW	PANEL99	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	1		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_INS_MSSHELL_A equ 100
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB100:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL100_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL100_W*PANEL100_L;AN000;Length expanded panel in mem
	DW	PANEL100	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	1		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_INS_SHELL_DISKS equ 101
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB101:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL101_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL101_W*PANEL101_L;AN000;Length expanded panel in mem
	DW	PANEL101	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	1		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_INS_OP_WORK = 102
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB102:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL102_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL102_W*PANEL102_L;AN000;Length expanded panel in mem
	DW	PANEL102	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	1		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SUB_INS_WORK3_A equ 103
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PCB103:;AN000;
	DW	PCB_EXP 	;AN000;option word
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DB	0		;AN000;GHG new adds
	DW	8		;AN000;row location of panel
	DW	LEFT_COL	;AN000;column location of panel
	DW	PANEL103_W	;AN000;text char width of panel
	DW	0		;AN000;Max poss panel sizing in text
	DW	WHITE_BLUE	;AN000;Index number of log color
	DB	'�Ŀ�����'      ;AN000;8 log border characters
	DW	0		;AN000;Length compress panel in mem
	DW	0		;AN000;Off addr compressed panel
	DW	0		;AN000;Seg addr compressed panel
	DW   PANEL103_W*PANEL103_L;AN000;Length expanded panel in mem
	DW	PANEL103	 ;AN000;Off addr of expanded panel in
	DW	0		;AN000;Seg addr of expanded panel in
	DW	0		;AN000;Len of the mixed panel in mem
	DW	0		;AN000;Off addr of mixed panel in mem
	DW	0		;AN000;Seg addr of mixed panel in mem
	DW	0		;AN000;Len of the panel label
	DW	0		;AN000;Off addr of the panel label
	DW	0		;AN000;Seg addr of the panel label
	DW	0		;AN000;Beg relative row of panel label
	DW	0		;AN000;Beg relative col of panel label
	DW	0		;AN000;Len of the panel stored in file
	DW	0		;AN000;Off address of full filespec
	DW	0		;AN000;Seg address of full filespec
	DW	0		;AN000;Lower off word of the beg off
	DW	0		;AN000;High off word of the beg off
	times 9 dw 0;AN000;Reserved for scroll and size
	DW	1		;AN000;Number of child panel entries
	DW	CHILD2	;AN000;Off address of child panel table
	DW	0		;AN000;Seg address of child panel table
	times 10 dw 0;AN000;GHG new adds


	%include "PANEL.INF";AN000;

; END SECTION .CODE;AN000;
	; END;AN000;
