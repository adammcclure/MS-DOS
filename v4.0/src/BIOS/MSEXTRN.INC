;	SCCSID = @(#)IBMEXTRN.ASM	1.11 85/11/18
;This is for IBMINIT module.
;=======================================================
;REVISION HISTORY:
;AN000; - NEW Version 4.00. J.K.
;AC000; - Modified Line 4.00. J.K.
;ANxxx; - PTMyyy
;==============================================================================
;AN001; D486 SHARE installation for large media 		   2/23/88 J.K.
;==============================================================================

	extern ORIG13,ORIG19
	extern COM2DEV,COM1DEV
	extern COM4DEV,COM3DEV
	extern LPT3DEV,LPT2DEV,LPT1DEV
	extern HARDDRV,HARDNUM,DRVMAX,HDSKTAB
	extern DSKDRVS,HNUM,EOT,FHAVE96
	extern REAL13,DAYCNT,CONHEADER
	extern TWOHARD,INT_2F_NEXT
	extern BDSH,BDSX,START_BDS
	extern FHAVEK09, NEW_ROM
	extern SINGLE
	extern BDSMs;for Mini Disk -J.K. 4/7/86
	extern HaveCMOSClock;set by IBMINIT. Used by IBMCLOCK.ASM
	extern BinToBCD;set by IBMINIT. Used by IBMCLOCK.ASM
	extern DaycntToDay;set by IBMINIT. Used by IBMCLOCK.ASM
	extern OLD13
	extern Temp_H;J.K. For 32 bit calculation. IBMDISK
	extern Start_Sec_H;J.K.  IBMDISK.
	extern KEYRD_Func;J.K. For IBMCON. Defined in IBMBDATA.
	extern KEYSTS_Func;J.K. For IBMCON. Defined in IBMBDATA.
	extern DiskSector;J.K. IBMBDATA
	extern Bpb_In_Sector;J.K. IBMBDATA
	extern SecPerCLusInSector;J.K. IBMBDATA
	extern NumberOfFats;J.K. IBMBDATA
	extern MediaByte;J.K. IBMBDATA
	extern Ext_Boot_Sig;J.K. IBMBDATA
	extern Boot_Serial_L;J.K. IBMBDATA
	extern Boot_Serial_H;J.K. IBMBDATA
	extern Boot_Volume_Label;J.K. IBMBDATA
	extern Boot_System_ID;J.K. IBMBDATA
	extern Fat_12_ID;J.K. IBMDISK
	extern Fat_16_ID;J.K. IBMDISK
	extern Vol_No_Name;J.K. IBMDISK
	extern MotorStartup;J.K. IBMBDATA
	extern DoubleWordMov;J.K. IBMDISK
	extern Model_Byte;J.K. IBMBIO2
	extern Secondary_Model_Byte;J.K. IBMBIO2

	%if iTEST
	  %ifndef NUMBUF
	    extern NUMBUF,DIGITS,FTESTBITS
	  %endif
	%endif

	extern START$,ERROUT,BLOCK13,INT19
	extern INTRET,HDRIVE,DRIVEX,INT13,CBREAK,OUTCHR
	extern DISKRD,MEDIA_PATCH,GETBP1_PATCH
	extern SET_PATCH,DISKIO_PATCH,DSKERR,INIT_PATCH
	extern TABLE_PATCH,EXIT,CHANGED_PATCH
	extern ERRIN,GETBP,SWPDSK
	extern OUTCHR,WRMSG,TIME_TO_TICKS
	extern INT2F_DISK,INSTALL_BDS,SETDRIVE
	extern Mov_Media_IDs;J.K.
	extern Clear_IDs;J.K.
	%if iTEST
	  %ifndef NUMBUF
	    extern MSGNUM,MSGOUT,dumpbytes,hex_to_ascii
	    extern outchar
	  %endif
	%endif

SECTION .SYSINITSEG
	; ASSUME	CS:SYSINITSEG
	extern CURRENT_DOS_LOCATION
	extern FINAL_DOS_LOCATION
	extern DEVICE_LIST
	extern MEMORY_SIZE
	extern DEFAULT_DRIVE
	extern BUFFERS
	extern SYSINIT
	extern Big_Media_Flag;AN001;
; END SECTION .SYSINITSEG

	; ASSUME	CS:CODE

; END OF DISK MODULES FOR CONFIGURATION

	extern END96TPI
	extern ENDTWOHARD
	extern ENDONEHARD
	extern ENDSWAP
	extern ENDFLOPPY

; IBM FIXED UP AT ROM

	extern IBM_DISK_IO
