;	SCCSID = @(#)dpl.asm	1.1 85/04/10
;	SCCSID = @(#)dpl.asm	1.1 85/04/10
struc DPL
DPL_AX: dw 0; AX register
DPL_BX: dw 0; BX register
DPL_CX: dw 0; CX register
DPL_DX: dw 0; DX register
DPL_SI: dw 0; SI register
DPL_DI: dw 0; DI register
DPL_DS: dw 0; DS register
DPL_ES: dw 0; ES register
DPL_reserved: dw 0; Reserved
DPL_UID: dw 0; User (Machine) ID (0 = local macine)
DPL_PID: dw 0; Process ID (0 = local user PID)
endstruc
