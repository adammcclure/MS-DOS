;	SCCSID = @(#)ibmdata.asm	1.1 85/04/10
;
; DATA Segment for DOS.
;

; .xlist
; .xcref
%include "mssw.asm"
%include "dosseg.asm"
debug = FALSE                           ; No dossym (too big)
%include "DOSMAC.INC"
%include "SF.INC"
%include "DIRENT.INC"
%include "CURDIR.INC"
%include "DPB.INC"
%include "BUFFER.INC"
%include "ARENA.INC"
%include "VECTOR.INC"
%include "DEVSYM.INC"
%include "PDB.INC"
%include "FIND.INC"
%include "MI.INC"
; .cref
; .list

; TITLE   IBMDATA - DATA segment for DOS
; NAME    IBMDATA

installed = TRUE

%include "ms_data.asm"
%include "msinit.asm"
	; END
