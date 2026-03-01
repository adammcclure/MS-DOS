;	SCCSID = @(#)dpl.asm	1.1 85/04/10
;	SCCSID = @(#)dpl.asm	1.1 85/04/10
struc DPL
DPL_AX: resw 1; AX register
DPL_BX: resw 1; BX register
DPL_CX: resw 1; CX register
DPL_DX: resw 1; DX register
DPL_SI: resw 1; SI register
DPL_DI: resw 1; DI register
DPL_DS: resw 1; DS register
DPL_ES: resw 1; ES register
DPL_reserved: resw 1; Reserved
DPL_UID: resw 1; User (Machine) ID (0 = local macine)
DPL_PID: resw 1; Process ID (0 = local user PID)
endstruc
