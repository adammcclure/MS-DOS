; The following structure defines the disk parameter table
; pointed to by Interrupt vector 1EH (location 0:78H)

struc DISK_PARMS
DISK_SPECIFY_1: resb 1
DISK_SPECIFY_2: resb 1
DISK_MOTOR_WAIT: resb 1; Wait till motor off
DISK_SECTOR_SIZ: resb 1; Bytes/Sector (2 = 512)
DISK_EOT: resb 1; Sectors per track (MAX)
DISK_RW_GAP: resb 1; Read Write Gap
DISK_DTL: resb 1
DISK_FORMT_GAP: resb 1; Format Gap Length
DISK_FILL: resb 1; Format Fill Byte
DISK_HEAD_STTL: resb 1; Head Settle Time (MSec)
DISK_MOTOR_STRT: resb 1; Motor start delay
endstruc

ROMStatus	equ	1
ROMRead 	equ	2
ROMWrite	equ	3
ROMVerify	equ	4
ROMFormat	equ	5
