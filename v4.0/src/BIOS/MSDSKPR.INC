; The following structure defines the disk parameter table
; pointed to by Interrupt vector 1EH (location 0:78H)

struc DISK_PARMS
DISK_SPECIFY_1: db 0
DISK_SPECIFY_2: db 0
DISK_MOTOR_WAIT: db 0; Wait till motor off
DISK_SECTOR_SIZ: db 0; Bytes/Sector (2 = 512)
DISK_EOT: db 0; Sectors per track (MAX)
DISK_RW_GAP: db 0; Read Write Gap
DISK_DTL: db 0
DISK_FORMT_GAP: db 0; Format Gap Length
DISK_FILL: db 0; Format Fill Byte
DISK_HEAD_STTL: db 0; Head Settle Time (MSec)
DISK_MOTOR_STRT: db 0; Motor start delay
endstruc

ROMStatus	equ	1
ROMRead 	equ	2
ROMWrite	equ	3
ROMVerify	equ	4
ROMFormat	equ	5
